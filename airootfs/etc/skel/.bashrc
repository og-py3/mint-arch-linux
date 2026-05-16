# Mint OS default bashrc — switch to zsh if available
if command -v zsh &>/dev/null; then
    exec zsh
fi

# Fallback bash config
PS1='\[\033[0;32m\]\u\[\033[0m\]@\[\033[0;36m\]mintos\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]\$ '
alias ls='ls --color=auto'
alias ll='ls -lah'
alias update='sudo pacman -Syu'
alias tools='sudo mint-tools-setup'
