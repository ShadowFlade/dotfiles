weather(){
	curl "wttr.in/$1"
}
bindkey -s ^f "~/.local/bin/scripts/tmux-sessionizer\n"
bindkey -s ^p "~/.local/bin/scripts/tmux-sessionizer ~/Desktop/personal/projects/pintereset_clone \n"
cdf() {
  if [ -n "$1" ] && [ -d "$1" ]; then
    cd "$1"
  fi

  local selected_dir
  selected_dir=$(fzf)
  cd "$(dirname "$selected_dir")"
}
bindkey -s ^f "tmux-sessionizer\n"

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

blackout(){
    picom-trans -c 100
}

opacity(){
    picom-trans -c 90
}
