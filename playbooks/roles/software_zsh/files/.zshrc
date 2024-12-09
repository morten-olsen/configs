export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.cache}
export LANG=en_US.UTF-8

# Load all files from .shell/rc.d directory
if [ -d $HOME/.shellrc/rc.d ]; then
  for file in $HOME/.shellrc/rc.d/*.sh; do
    source $file
  done
fi

# Load all files from .shell/zshrc.d directory
if [ -d $HOME/.shellrc/zshrc.d ]; then
  for file in $HOME/.shellrc/zshrc.d/*.zsh; do
    source $file
  done
fi
export GPG_TTY=$(tty)
if [[ -n "$SSH_CONNECTION" ]] ;then
  export PINENTRY_USER_DATA="USE_CURSES=1"
fi

[ -f ~/.env ] && source ~/.env

if [ `tput cols` -gt "70" ]; then
function PRINT_CENTER {
  COLS=`tput cols`
  OFFSET=$(( ($COLS - $1) / 2 ))
  PRE=""
  for i in `seq $OFFSET`; do
    PRE="$PRE "
  done 
  while IFS= read -r line; do
    echo "$PRE$line"
  done <<< "$2"
}
PRINT_CENTER 60 "

       ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
       █░▄▄▀█▀▄▄▀█░▄▄░█▄░▄█▀▄▀██░▄░██░██░█░▄▄█░▄▄░█
       █░▀▀▄█░██░█░▀▄░██░██░█▀█░▀▀░▀█░██░█▄▄▀███▄██
       █▄█▄▄██▄▄██░▀▀░██▄███▄█████░███▄▄▄█▄▄▄█░▀▀░█
       ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
             
               ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          
                ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       
                      ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     
                       ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    
                      ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   
               ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  
              ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   
             ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  
             ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ 
                  ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     
                   ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     
▄▄▄ . ▌ ▐·▪  ▄▄▌    ▄▄▌ ▐ ▄▌▪  ▄▄▄▄▄ ▄ .▄      ▄• ▄▌▄▄▄▄▄
▀▄.▀·▪█·█▌██ ██•    ██· █▌▐███ •██  ██▪▐█ ▄█▀▄ █▪██▌•██  
▐▀▀▪▄▐█▐█•▐█·██ ▪   ██▪▐█▐▐▌▐█· ▐█.▪██▀▀█▐█▌.▐▌█▌▐█▌ ▐█.▪
▐█▄▄▌ ███ ▐█▌▐█▌ ▄  ▐█▌██▐█▌▐█▌ ▐█▌·██▌▐▀▐█▌.▐▌▐█▄█▌ ▐█▌·
 ▀▀▀ . ▀  ▀▀▀.▀▀▀    ▀▀▀▀ ▀▪▀▀▀ ▀▀▀ ▀▀▀ · ▀█▄▀▪ ▀▀▀  ▀▀▀ 

  > welcome x_x
"
fi

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

which atuin &> /dev/null && eval "$(atuin init zsh)"
which direnv &> /dev/null && eval "$(direnv hook zsh)"
which starship &> /dev/null && eval "$(starship init zsh)"
which zoxide &> /dev/null && eval "$(zoxide init zsh)"
which pyenv &> /dev/null && eval "$(pyenv init --path)"
