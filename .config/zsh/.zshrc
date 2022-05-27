## ▒███████ ████████░ ██ ██▀███ ▄████▄  
## ▒ ▒ ▒ ▄▒██    ▓██░ ██▓██ ▒ █▒██▀ ▀█  
## ░ ▒ ▄▀▒░ ▓██▄ ▒██▀▀██▓██ ░▄█▒▓█    ▄ 
##   ▄▀▒    ▒   █░▓█ ░██▒██▀▀█▄▒▓▓▄ ▄██ 
## ▒██████▒██████░▓█▒░██░██▓ ▒█▒ ▓███▀  
## ░▒▒ ▓░▒▒ ▒▓▒ ▒ ▒ ░░▒░░ ▒▓ ░▒░ ░▒ ▒   
## ░░▒ ▒ ░░ ░▒  ░ ▒ ░▒░ ░ ░▒ ░ ▒ ░  ▒   
## ░ ░ ░ ░░  ░  ░ ░  ░░ ░ ░░   ░        
##   ░ ░        ░ ░  ░  ░  ░   ░ ░      
## ░                           ░        

COLORTERM="truecolor"

### Zsh specific settings
# Completion
autoload -Uz compinit
compinit
unsetopt completealiases
zstyle ':completion:*' rehash true

# General opts
setopt autocd
unsetopt beep notify
bindkey -e
zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"

## Nifty third party tools
# Import gitstatus tool
source $HOME/.config/zsh/gitstatus/gitstatus.prompt.zsh
# Startup zoxide
eval "$(zoxide init zsh)"

# Source aliasrc
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

# History opts
HISTFILE=$HOME/.cache/zsh/history
HISTSIZE=100000
SAVEHIST=100000
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# Colors for prompt
autoload -U colors && colors

# Default to vi mode bay-bee
bindkey -v
bindkey -v '^?' backward-delete-char
vim_ins_mode="■"
vim_cmd_mode="□"
vim_mode=$vim_ins_mode
export KEYTIMEOUT=1

function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
} 

# Make home/end/del keys work properly
bindkey  "^[[7~"   beginning-of-line
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[8~"   end-of-line
bindkey  "^[[4~"   end-of-line
bindkey  "^[[3~"   delete-char
bindkey  "^[[5~"   up-line-or-history
bindkey  "^[[6~"   down-line-or-history

#Word Navigation
WORDCHARS=''
bindkey "^[[1;5C" forward-word 
bindkey "^[[1;5D" backward-word

# Remap Esc with Caps  
setxkbmap -option caps:escape
setxkbmap -option escape:caps

# Autosuggestions 
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Autosuggest keybind ctrl + space
bindkey '^ ' autosuggest-accept

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Setup fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh

# Style completion menu
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==35=35}:${(s.:.)LS_COLORS}")';
zstyle ':completion:*:descriptions' format $'\e[01;33m %d\e[0m'
zstyle ':completion:*:messages' format $'\e[01;31m %d\e[0m'
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

## Prompt stuff
# Helper functions for prompt
# determine cursor position to either start with/out newline
cup(){
    echo -ne "\033[6n" > /dev/tty
    read -t 1 -s -d 'R' line < /dev/tty
    line="${line##*\[}"
    line="${line%;*}"
    echo "$line"
}

# Collapse path to single chars if it gets too long
collapse_pwd() {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

# Truncate the dir path
truncated_pwd() {
    n=$1 # n = number of directories to show in full (n = 3, /a/b/c/dee/ee/eff)
    path=`collapse_pwd`

    # split our path on /
    dirs=("${(s:/:)path}")
    dirs_length=$#dirs

    if [[ $dirs_length -ge $n ]]; then
        # we have more dirs than we want to show in full, so compact those down
        ((max=dirs_length - n))
        for (( i = 1; i <= $max; i++ )); do
            step="$dirs[$i]"
            if [[ -z $step ]]; then
                continue
            fi
            if [[ $step =~ "^\." ]]; then
                dirs[$i]=$step[0,2] #make .mydir => .m
            else
                dirs[$i]=$step[0,1] # make mydir => m
            fi
        done
    fi

    echo ${(j:/:)dirs}
}

# Vim mode helper function; notifies current state
zle-keymap-select() {
    vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
    custom_prompt
	zle reset-prompt
}

zle -N zle-keymap-select

zle-line-finish() {
    vim_mode=$vim_ins_mode
}

zle -N zle-line-finish

# Preexec function
setup() {
	# Change window title to current command right after command is inputted
	print -Pn "\e]0;$1\a"
}

# Classy touch inspired prompt
custom_prompt() {
	cmd_cde=$?
	# Set window title
	print -Pn "\e]2;%n@%M: %~\a"
	if [ $(cup) -eq 1 ]; then
		PROMPT=""
	else
		# PROMPT=$'\n'
		PROMPT=$''
	fi
	PROMPT+="%{$fg[red]%}┏━"

	#Are we root?
	[ "$(id -u)" -eq 0 ] && PROMPT+="[%{$fg[white]%}root%{$fg[red]%}]%{%G━%}"
	
	#Current directory
	PROMPT+="[%{$fg[white]%}%{$(truncated_pwd 3)%}%{$fg[red]%}]"
	
	#Git status
	if gitstatus_query MY && [[ "$VCS_STATUS_RESULT" == ok-sync ]]; then
		if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
			PROMPT+="%{%G━%}[%{$fg[white]%}${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}" # escape backslash
		else
			PROMPT+="%{%G━%}%{$fg[white]%}@${${VCS_STATUS_COMMIT}//\%/%%}" # escape backslash
		fi
		(( VCS_STATUS_HAS_STAGED )) && PROMPT+=' +'
		(( VCS_STATUS_HAS_UNSTAGED )) && PROMPT+=' !'
		(( VCS_STATUS_HAS_UNTRACKED )) && PROMPT+=' ?'
		PROMPT+="%{$fg[red]%}]"
	fi

	if [ $cmd_cde -eq 0 ]; then
		PROMPT+=$'\n'"%{$fg[red]%}┗━━ %{$fg_bold[yellow]%}${vim_mode} %{$reset_color%}"
	else
		PROMPT+=$'\n'"%{$fg[red]%}┗━━ %{$reset_color%}${vim_mode} "
	fi
	
	setopt no_prompt_{bang,subst} prompt_percent  # enable/disable correct prompt expansions
}

gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
autoload -Uz add-zsh-hook
add-zsh-hook preexec setup
add-zsh-hook precmd custom_prompt
export PROMPT2="%{$fg_bold[yellow]%} %{%G■%}%{$reset_color%} "

### General configs
# Color support for ls, fd, etc
eval $(dircolors -p | perl -pe 's/^((CAP|S[ET]|O[TR]|M|E)\w+).*/$1 00/' | dircolors -)

# Pfetch configuration
export PF_INFO="ascii title os host kernel wm pkgs shell editor palette"

### Functions
# extract files
ex () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;      
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Colorized man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;40;35m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;33m") \
		man "$@"
}

# ls after a cd
cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null
		ls -la
	else
		echo "zsh: cl: $dir: Directory not found"
	fi
}

font_test() {
echo "
                0 1 2 3 4 5 6 7 8 9
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
a b c d e f g h i j k l m n o p q r s t u v w x y z
            ! @ # \$ % ^ & * ( ) _ + = -
                   , . / ; ' [ ]
                   < > ? : \" { }
"
}

# Syntax highlighting
source ~/.config/zsh/fsh/fast-syntax-highlighting.plugin.zsh
