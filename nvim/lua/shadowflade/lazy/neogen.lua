return {
    "danymat/neogen",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local neogen = require("neogen")
        local extractors = require("neogen.utilities.extractors")
        local nodes_utils = require("neogen.utilities.nodes")
        local helpers = require("neogen.utilities.helpers")
        local i = require("neogen.types.template").item

        -- Default PHP granulator only extracts parameter *names* (no types). PHPDoc template uses `%s`
        -- for the type+signature slot, so we collect each parameter node's full text (e.g. `int $id`).
        local function extract_php_func(node)
            local buf = vim.api.nvim_get_current_buf()

            local tree = {
                {
                    node_type = "compound_statement",
                    retrieve = "first",
                    subtree = {
                        {
                            retrieve = "first",
                            node_type = "return_statement",
                            recursive = true,
                            extract = true,
                            as = i.Return,
                        },
                    },
                },
            }
            local nodes = nodes_utils:matching_nodes_from(node, tree)
            local res = extractors:extract_from_matched(nodes)
            if res[i.Return] and #res[i.Return] > 1 then
                res[i.Return] = { res[i.Return][1] }
            end

            -- Prefer native return type hint (`: ?self`, `: void`) for @return; otherwise keep first return statement text.
            local rt_nodes = node:field("return_type")
            if rt_nodes and rt_nodes[1] then
                local t = vim.trim(helpers.get_node_text(rt_nodes[1], buf)[1]):gsub("%s+", " ")
                if t ~= "" then
                    res[i.Return] = { t }
                end
            end

            res[i.Parameter] = {}
            for i_child = 0, node:named_child_count() - 1 do
                local child = node:named_child(i_child)
                if child:type() == "formal_parameters" then
                    for p = 0, child:named_child_count() - 1 do
                        local param = child:named_child(p)
                        local pt = param:type()
                        if pt == "simple_parameter" or pt == "property_promotion_parameter" or pt == "variadic_parameter" then
                            local text = helpers.get_node_text(param, buf)[1]
                            text = vim.trim(text):gsub("%s+", " ")
                            if text ~= "" then
                                table.insert(res[i.Parameter], text)
                            end
                        end
                    end
                    break
                end
            end

            return res
        end

        -- Stock phpdoc uses `@param $1 %s $1`; we use full param text in `%s` and omit `$1` (no per-param TODO tabs).
        local phpdoc_tpl = vim.deepcopy(require("neogen.templates.phpdoc"))
        for _, row in ipairs(phpdoc_tpl) do
            if row[1] == i.Parameter and type(row[2]) == "string" then
                -- No `$1`: avoids `[TODO:parameter]` snippet tab-stops after each @param
                row[2] = " * @param %s"
            elseif row[1] == i.Return and type(row[2]) == "string" then
                -- Use `%s` for hinted return type; no trailing `$1` placeholder
                row[2] = " * @return %s"
            end
        end

        -- Per-filetype template (avoid mutating shared require("neogen.template") table).
        local tpl_proto = require("neogen.template")
        local php_template = setmetatable({ annotation_convention = "phpdoc", phpdoc = phpdoc_tpl }, { __index = tpl_proto })

        neogen.setup({
            snippet_engine = "luasnip",
            -- Still get tab-stops on summary lines; not after each @param/@return
            placeholders_text = {
                parameter = "",
                ["return"] = "",
            },
            languages = {
                php = {
                    template = php_template,
                    data = {
                        func = {
                            ["function_definition|method_declaration"] = {
                                ["0"] = {
                                    extract = extract_php_func,
                                },
                            },
                        },
                    },
                },
            },
        })

        vim.keymap.set("n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end)

        vim.keymap.set("n", "<leader>nt", function()
            neogen.generate({ type = "type" })
        end)

        -- `/**` on a line alone, then <CR> → generate PHPDoc for function/method below (neogen).
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "php",
            callback = function(ev)
                local buf = ev.buf
                local function insert_cr()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "in", false)
                end

                vim.keymap.set("i", "<CR>", function()
                    local ok_cmp, cmp = pcall(require, "cmp")
                    if ok_cmp and cmp.visible() then
                        return insert_cr()
                    end
                    if vim.fn.pumvisible() == 1 then
                        return insert_cr()
                    end
                    if vim.trim(vim.fn.getline(".")) == "/**" then
                        local lnum = vim.fn.line(".")
                        vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, true, {})
                        vim.fn.cursor(lnum, 1)
                        neogen.generate({ type = "func" })
                        return
                    end
                    insert_cr()
                end, { buffer = buf, desc = "PHPDoc: /** + CR triggers neogen" })
            end,
        })
    end,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}

