# Mint OS root zshrc

[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

PROMPT='%F{red}root%f@%F{cyan}mintos%f %F{yellow}%~%f # '

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

autoload -Uz compinit && compinit

alias ls='ls --color=auto'
alias ll='ls -lah'
alias update='pacman -Syu'
alias install='pacman -S'
alias remove='pacman -Rns'
alias tools='mint-tools-setup'
alias installer='mint-installer'

fastfetch 2>/dev/null || true
