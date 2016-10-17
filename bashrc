#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set up mesa
export MESA_DIR=/home/jschwab/Software/mesa
export MESASDK_ROOT=/opt/mesasdk

activatemesasdk () {
    source /home/jschwab/Software/mesa-init/mesasdk_init.sh
}

# change how bash prompt appears
source /usr/share/git/git-prompt.sh
source /home/jschwab/Software/mesa-init/mesa_init.sh

export PROMPT_DIRTRIM=2
PS1='\[\033]0;\w\007\]$(__mesa_ps1)\h:$(__git_ps1 "(%s)") \W$ '

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# http://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize
HISTSIZE=1000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# basic command tweaks
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -I'

# other aliases
alias pdfmerge="gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=merge.pdf -dBATCH"
alias timestamp="date +%d%m%y-%H%M%S"
alias pdb="python -m pdb"


# add rubygems to path
export PATH=$PATH:/home/jschwab/.gem/ruby/2.3.0/bin

# add cabal (haskell) to path
export PATH=$PATH:/home/jschwab/.cabal/bin

# add scripts directory
export PATH=$PATH:/home/jschwab/scripts

# look for python modules in my software directory
export PYTHONPATH=/home/jschwab/Software/:$PYTHONPATH
export PYTHONPATH=/home/jschwab/Software/elpy/:$PYTHONPATH
export PYTHONPATH=/home/jschwab/Software/py_mesa_reader/:$PYTHONPATH
export PYTHONPATH=/home/jschwab/Software/solvertools/:$PYTHONPATH

# make sure systemd knows about this PYTHONPATH
systemctl --user import-environment PYTHONPATH

# this is a machine has two physical cores
export OMP_NUM_THREADS=2

# convinient emacs aliases
alias ec="emacsclient -n -c"
alias ecof="emacsclient -n"

# use emacs for everything
export ALTERNATE_EDITOR=emacs
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# easily interact with python virtualenvs
# https://wiki.archlinux.org/index.php/Python_VirtualEnv#Virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

# quickly go to research directory
cdrp(){
    cd /home/jschwab/Research/Eliot/project$1_*
}

# for msmtpq; hardcoded now
# export EMAIL_QUEUE_QUIET=t

# no need to break osx habits...
alias open="xdg-open"

# docs for orgmode
export INFOPATH=/home/jschwab/Software/org-mode/doc:$INFOPATH

# aliases from https://wiki.archlinux.org/index.php/Allow_Users_to_Shutdown
alias reboot="sudo systemctl reboot"
alias poweroff="sudo systemctl poweroff"
alias halt="sudo systemctl halt"

# alias for pacman
search() {
  aura -Ss $1 && aura -As $1
}

# OPAM configuration
. /home/jschwab/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
