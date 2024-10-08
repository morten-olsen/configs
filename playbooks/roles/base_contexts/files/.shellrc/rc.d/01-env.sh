export TMPDIR="${TMPDIR:-/tmp}"
export PATH="$PATH:$HOME/.local/bin"

alias ls=eza
alias cat=bat
alias grep=rg
alias diff=delta
alias less=bat
alias gr='if [ "`git rev-parse --show-cdup`" != "" ]; then cd `git rev-parse --show-cdup`; fi'
