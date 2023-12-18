# .bashrc

# User specific aliases and functions

# Safe versions of default commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions if available
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Warning when logged in as root
if [ "$(id -u)" -eq 0 ]; then
    echo "!! WARNING: Logged in as root !!"
    echo "Consider switching to a regular user."
    echo "e.g., su ldm"
fi
