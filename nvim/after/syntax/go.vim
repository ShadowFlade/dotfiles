" Improve Go function name visibility
" - goFunction: function declarations/definitions (links to `Function` by default)
" - goFunctionCall: function calls (links to `Type` by default)
"
" We keep the base `Function` foreground color, but force `bold` for Go.

let s:base = 'Function'
let s:fg = synIDattr(synIDtrans(hlID(s:base)), 'fg#')
let s:ctermfg = synIDattr(synIDtrans(hlID(s:base)), 'ctermfg')

if s:fg !=# '' && s:fg !=# 'NONE'
  execute 'hi GoFunction guifg=' . s:fg . ' gui=bold'
else
  hi GoFunction gui=bold
endif

if s:ctermfg !=# '' && s:ctermfg !=# 'NONE'
  execute 'hi GoFunction ctermfg=' . s:ctermfg . ' cterm=bold'
endif

hi! link goFunction GoFunction
hi! link goFunctionCall GoFunction

" Method value / selector references: `timerHandler.CreateUser`
" These are NOT calls (no `(` right after the method name), so we want
" them slightly less prominent than real calls.
" Calls like `timerHandler.CreateUser(...)` stay covered by `goFunctionCall`.

if s:fg !=# '' && s:fg !=# 'NONE'
  execute 'hi GoMethodValue guifg=' . s:fg . ' gui=NONE'
else
  hi GoMethodValue gui=NONE
endif

if s:ctermfg !=# '' && s:ctermfg !=# 'NONE'
  execute 'hi GoMethodValue ctermfg=' . s:ctermfg . ' cterm=NONE'
endif

hi! link goMethodValue GoMethodValue

" Highlight `.MethodName` only when it's not followed by `(` after optional whitespace.
" The negative lookahead uses `\@!` (requires an atom).
syn match goMethodValue /\.\zs\w\+\ze\s*\(\s*(\)\@!/

