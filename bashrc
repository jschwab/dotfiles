#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set up mesa
export MESA_DIR=/home/jschwab/Software/mesa
export MESASDK_ROOT=/opt/mesasdk
export REPO_NAME=mesa^mesa

export MESA_OP_MONO_DATA_PATH=/home/jschwab/Software/OP4STARS_1.3/mono
export MESA_OP_MONO_DATA_CACHE_FILENAME=/home/jschwab/Software/OP4STARS_1.3/mono/op_mono_cache.bin

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
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# http://stackoverflow.com/questions/19454837/bash-histsize-vs-histfilesize
# numeric values less than zero inhibit truncation
HISTSIZE=-1
HISTFILESIZE=-1

# Save the history after each command finishes
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# replace directory names with the results of word expansion when
# performing filename completion
shopt -s direxpand

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

# add local binary directory
export PATH="$PATH:$HOME/.local/bin"

# add rubygems to path
export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"

# add scripts directory
export PATH="$PATH:$HOME/scripts"

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

# view file read-only in emacs
ev() {
    emacsclient -n -c --eval "(view-file \"$1\")"
}

# open magit in current dir
eg() {
    emacsclient -n -c --eval "(magit-status-internal \"$(pwd)\")"
}

# Use emacs for everything
export ALTERNATE_EDITOR=emacs
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# quickly go to research directory
cdrp(){
    cd /home/jschwab/Research/Eliot/project$1_*
}

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

# make comments on a pdf
make_comments() {
    NEWNAME="$(basename $1 .pdf)-$(date +%F)-jws.pdf"
    mv "$1" "$NEWNAME" && ec "$NEWNAME"
}

# update path in systemd
systemctl --user import-environment PATH

# set up conda
. /opt/anaconda/etc/profile.d/conda.sh
