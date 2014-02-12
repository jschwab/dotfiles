#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# change how bash prompt appears
source /usr/share/git/git-prompt.sh
export PROMPT_DIRTRIM=2
PS1='\[\033]0;\w\007\]\h:$(__git_ps1 "(%s)") \W$ '

# basic command tweaks
alias ls='ls --color=auto'
alias rm='rm -I'

# add shortcuts for frequent ssh targets
source ~/.server_aliases

# other aliases
alias pdfmerge="gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=merge.pdf -dBATCH"
alias timestamp="date +%d%m%y-%H%M%S"
alias bplcat="xterm -title 'BPLCAT' -e telnet library.berkeley-public.org &"
alias pdb="python -m pdb"
alias pylab="ipython --pylab"
alias pledge="/home/jschwab/Software/McAfee/Pledge/Pledge"

# help bash save history
#shopt -s histappend
#export PROMPT_COMMAND="history -a"

# add rubygems to path
export PATH=$PATH:/home/jschwab/.gem/ruby/2.1.0/bin

# add mathematica to path
export PATH=$PATH:/opt/Wolfram/bin

# add scripts directory
export PATH=$PATH:/home/jschwab/scripts

# look for python modules in the 
export PYTHONPATH=/home/jschwab/Software/:$PYTHONPATH

# this is a quad-core machine
export OMP_NUM_THREADS=4

# set up mesa
export MESA_DIR=/home/jschwab/Software/mesa
export MESASDK_ROOT=/opt/mesasdk

alias activatemesasdk="source $MESASDK_ROOT/bin/mesasdk_init.sh"
alias mkworkdir="cp -r $MESA_DIR/star/work"

# convinient emacs aliases
alias ec="emacsclient -n -c"
alias ecof="emacsclient -n"
alias kill-emacs="emacsclient -e '(kill-emacs)'"

# use emacs for everything
export ALTERNATE_EDITOR=emacs
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# easily interact with python virtualenvs
# https://wiki.archlinux.org/index.php/Python_VirtualEnv#Virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

# add some shortcuts

# quickly go to research directory
cdrp(){
    cd /home/jschwab/Research/Eliot/project$1_*
}

# quickly go to puzzle directory
cddc(){
    cd /home/jschwab/Puzzling/BerkeleyHunt/2014/hunt2014/dailycal/spring
}

# for msmtpq
export EMAIL_QUEUE_QUIET=t

# no need to break osx habits...
alias open="xdg-open"

# docs for orgmode
export INFOPATH=/home/jschwab/Software/org-mode/doc:$INFOPATH

# aliases from https://wiki.archlinux.org/index.php/Allow_Users_to_Shutdown
alias reboot="sudo systemctl reboot"
alias poweroff="sudo systemctl poweroff"
alias halt="sudo systemctl halt"
