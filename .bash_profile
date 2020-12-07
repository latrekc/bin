# .bashrc
export BASH_SILENCE_DEPRECATION_WARNING=1

PAGER=more;

. ~/.colorsrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

shopt -s histappend
PROMPT_COMMAND='history -a'

# User specific aliases and functions
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=~/bin/:$PATH

#export PATH=~/Library/Python/3.6/bin:"$PATH"
#export PATH=~/Code/vendor/depot_tools:"$PATH"

alias ls='ls -G'

#alias gs='git status --short'
#alias ga='git add '
#alias gb='git branch '
#alias gc='git commit'
#alias gd='git diff'
#alias go='git checkout '

#alias python=python2.7

# Set git autocompletion and PS1 integration
if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
  . /usr/local/git/contrib/completion/git-completion.bash
fi
if [ -f /etc/bash_completion.d/git ]; then
  . /etc/bash_completion.d/git
fi
GIT_PS1_SHOWDIRTYSTATE=true

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh";

#if [ -f /opt/local/etc/bash_completion ]; then
#    . /opt/local/etc/bash_completion
#fi
#alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"

if [ -f ~/bin/.git-prompt.sh ]; then
  source ~/bin/.git-prompt.sh
fi

#PS1='\[\033[32m\]\u@\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

if [ "$TERM_PROGRAM" = "vscode" ]; then
	ROOT_DIR=`pwd`
	PS1='\[\033[34m\]$(realpath --relative-to=$ROOT_DIR `pwd`)\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
else
	PS1='\[\033[32m\]\u@\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '
fi


export NVM_DIR="/home/s.tugovikov/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="/usr/local/opt/openssl/bin:$PATH"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH


_ssh() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# docker completion
if [ -f ~/bin/docker-compose.completion.sh ]; then
  . ~/bin/docker-compose.completion.sh
fi
if [ -f ~/bin/docker-machine.completion.sh ]; then
  . ~/bin/docker-machine.completion.sh
fi


. ~/.bashrc

# Get the values of all SSM parameters under the given path
ssm-for () {
    color_on=$(tput setaf 1)
    color_off=$(tput sgr 0)
    aws ssm get-parameters-by-path --recursive --path "$1" --with-decryption \
        | jq -r ".Parameters[] | .Name + \": $color_on\" + .Value + \"$color_off\""
}

export PATH="/usr/local/opt/postgresql@10/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# Connect to the replica DB by SSM parameters
psql-replica () {
	if [[ -z $1 ]]
	then
		echo "Empty environment name"
		return 1
	fi

	case $1 in 
		production) replicaPath="replica-dev";;
		staging) replicaPath="replica-analytics";;
		*) echo "Wrong environment name $1"; return 2;;
	esac

	local _REPLICA_PREFIX="/databases/rds-pg-threads-main-$replicaPath"
	echo "Connect to $_REPLICA_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_REPLICA_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _REPLICA_\"+(.Name|sub(\"$_REPLICA_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`


	local _RO_PREFIX="/databases/rds-pg-threads-main/threads_main/analyticsro"
	echo "Connect to $_RO_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_RO_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _RO_\"+(.Name|sub(\"$_RO_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`

	if [[ -z $3 ]]
	then
		PGPASSWORD="$_RO_PASSWORD" psql -U $_RO_USER -h $_REPLICA_HOST $_RO_DB
	else
		PGPASSWORD="$_RO_PASSWORD" psql -U $_RO_USER -h $_REPLICA_HOST $_RO_DB -c "$3"
	fi
}

# Connect to the DB by SSM parameters
psql-for () {
	if [[ -z $1 ]]
	then
		echo "Empty service name"
		return 1
	fi

	if [[ -z $2 ]]
	then
		echo "Empty environment name"
		return 2
	fi

	local _PREFIX="/databases/rds-pg-threads-main/threads_main/$1"
	echo "Connect to $_PREFIX ..."

	eval `AWS_PROFILE="threads-$2" aws ssm get-parameters-by-path --recursive --path "$_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _\"+(.Name|sub(\"$_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`
	echo "host ${_HOST}"

	if [[ -z $3 ]]
	then
		PGPASSWORD="$_PASSWORD" psql -U $_USER -h $_HOST $_DB
	else
		PGPASSWORD="$_PASSWORD" psql -U $_USER -h $_HOST $_DB -c "$3"
	fi
} 