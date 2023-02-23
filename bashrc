# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Warn user if they start a shell as root
if [ "$(whoami)" = "root" ];
then
echo " !!!!!!!!!!!!!!!!!!!!!!!!!!
! WARNING: YOU ARE ROOT. !
!!!!!!!!!!!!!!!!!!!!!!!!!!
Login as user ldm before proceeding unless you know what you're doing: su ldm"
fi
