# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

shopt -s histappend
PROMPT_COMMAND='history -a'

# User specific aliases and functions
export LC_ALL=ru_RU.UTF-8
export LANG=ru_RU.UTF-8
export PATH=~/bin/:$PATH

alias gs='git status --short'
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias go='git checkout '

alias python=python2.7

# Set git autocompletion and PS1 integration
if [ -f /etc/bash_completion.d/git ]; then
  . /etc/bash_completion.d/git
fi
GIT_PS1_SHOWDIRTYSTATE=true

#if [ -f /opt/local/etc/bash_completion ]; then
#    . /opt/local/etc/bash_completion
#fi

PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '