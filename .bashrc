# ~/.bashrc — minimal, funcional, profesional
case $- in
    *i*) ;;
      *) return;;
esac

# ===== HISTORIAL =====
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize
PROMPT_COMMAND='history -a'

# ===== LESS =====
export LESS='-R --use-color --mouse'
export LESSOPEN='| /usr/bin/lesspipe %s 2>/dev/null'

# ===== GREP =====
export GREP_COLORS='mt=01;31:fn=35:ln=32:bn=32:se=36'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# ===== LS =====
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# ===== ALIASES =====
alias ll='ls -lh --group-directories-first'
alias lla='ls -lah --group-directories-first'
alias la='ls -A'
alias l='ls -CF'
alias diff='diff --color=auto'
alias ip='ip -c'
alias cls='clear'
alias vim='nvim'
alias ta='tmux attach -t'
alias tls='tmux ls'
export EDITOR='nvim'

# ===== PROMPT =====
RESET='\[\e[0m\]'
RED='\[\e[1;31m\]'
CYAN='\[\e[1;36m\]'
GRAY='\[\e[0;37m\]'

git_branch() {
  git branch 2>/dev/null | grep '^\*' | cut -c3-
}

if [ "$EUID" -eq 0 ]; then
    PS1="${RED}root${GRAY}@\h \w # ${RESET}"
else
    PS1="${CYAN}\u${GRAY}@\h \w\$(git_branch | sed 's/.\+/ (&)/') \$ ${RESET}"
fi

# ===== XTERM TITLE =====
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
esac

# ===== COMPLETION =====
if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && \
  . /usr/share/bash-completion/bash_completion
fi

# ===== SILENCIO TECLADO =====
[ -n "$DISPLAY" ] && xset b off 2>/dev/null

# ===== TMUX AUTO-START =====
if command -v tmux &>/dev/null && [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then
  tmux attach-session -t default 2>/dev/null || tmux new-session -s default
fi
