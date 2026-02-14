#=====================================================
#
#   ██████╗  █████╗ ███████╗██╗  ██╗
#   ██╔══██╗██╔══██╗██╔════╝██║  ██║
#   ██████╔╝███████║███████╗███████║
#   ██╔══██╗██╔══██║╚════██║██╔══██║
#   ██████╔╝██║  ██║███████║██║  ██║
#   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#=====================================================
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== CATPPUCCIN MOCHA (RETRO TOKYO) COLORS =====
MAUVE='\[\033[38;5;183m\]'     # Soft Purple
LAVENDER='\[\033[38;5;147m\]'  # Light Blue/Purple
SAPPHIRE='\[\033[38;5;74m\]'   # Deep Cyan
SKY='\[\033[38;5;117m\]'       # Sky Blue
TEAL='\[\033[38;5;115m\]'      # Seafoam
PINK='\[\033[38;5;212m\]'      # Retro Pink
FLAMINGO='\[\033[38;5;218m\]'  # Soft Rose
TEXT='\[\033[38;5;253m\]'      # Off-white
SUBTEXT='\[\033[38;5;246m\]'   # Grayish
SURFACE='\[\033[38;5;239m\]'   # Dark Gray

BOLD='\[\033[1m\]'
RESET='\[\033[0m\]'

# ===== PROMPT LOGIC =====
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

git_status() {
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        echo " ${PINK}●"  # Pink for dirty
    else
        echo " ${TEAL}●"  # Teal for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${TEAL}✓"
    else
        echo "${PINK}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Line 1: [✓] UwU@Archy-Chan [~/dir]
    PS1="${BOLD}${SURFACE}[${exit_code}${SURFACE}] "
    PS1+="${MAUVE}UwU${SUBTEXT}@${LAVENDER}Archy-Chan${RESET} "
    PS1+="${BOLD}${SAPPHIRE}[󰄛 \w]${RESET}"

    # Git branch info
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${SKY}${git_branch}${git_status_indicator}${RESET}"
    fi

    # Line 2: The Gradient Arrows
    PS1+="${BOLD}${LAVENDER}❯${MAUVE}❯${PINK}❯${FLAMINGO}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# ===== ALIASES =====
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# Arch Linux (Pacman)
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias orphans='pacman -Qtdq'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Modern overrides
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias tree='tree -C'

# Safety
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'

# Quick Edit
alias bashrc='nvim ~/.bashrc'
alias nvimrc='nvim ~/.config/nvim/init.lua'

# ===== FUNCTIONS =====
# Create and enter directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# Archive extractor
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Weather (Retro themed)
weather() { curl -s "wttr.in/${1:-}?F" | head -7; }

# ===== ENVIRONMENT & BEHAVIOR =====
export EDITOR=nvim
export VISUAL=nvim
export HISTSIZE=10000
export HISTCONTROL=ignoreboth:erasedups

# Vi mode for the elite
set -o vi

# Better completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# LS_COLORS for Mocha
export LS_COLORS="di=1;34:ln=1;36:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;44"

# FZF Integration
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
fi
