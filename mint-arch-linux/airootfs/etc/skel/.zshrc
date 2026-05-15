# =============================================================================
# Mint OS — ZSH Configuration  |  Professional developer shell
# =============================================================================

# ── Plugins ───────────────────────────────────────────────────────────────────
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ── Prompt (Starship or fallback) ─────────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{46}%n%f%F{245}@%f%F{36}mintos%f %F{220}%~%f %# '
    RPROMPT='%F{196}$(git branch --show-current 2>/dev/null | sed "s/.*/ &/")%f'
fi

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY SHARE_HISTORY INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS EXTENDED_HISTORY

# ── Options ───────────────────────────────────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt CORRECT INTERACTIVE_COMMENTS GLOB_DOTS
setopt NO_BEEP NO_CASE_GLOB EXTENDED_GLOB

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache

# ── Key Bindings ──────────────────────────────────────────────────────────────
bindkey -e
bindkey '^[[A'  history-beginning-search-backward
bindkey '^[[B'  history-beginning-search-forward
bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ── FZF Integration ───────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
    source /usr/share/fzf/key-bindings.zsh 2>/dev/null || true
    source /usr/share/fzf/completion.zsh 2>/dev/null || true
    export FZF_DEFAULT_OPTS="
        --color=fg:#c8d8c8,bg:#0d160d,hl:#2ecb71
        --color=fg+:#ffffff,bg+:#1a2a1a,hl+:#3ddc80
        --color=info:#2ecb71,prompt:#2ecb71,pointer:#2ecb71
        --color=marker:#2ecb71,spinner:#2ecb71,header:#2ecb71
        --border --height 60% --layout=reverse"
    export FZF_CTRL_R_OPTS="--sort --exact"
fi

# ── Modern CLI Aliases ────────────────────────────────────────────────────────
# Use eza instead of ls if available
if command -v eza &>/dev/null; then
    alias ls='eza --color=always --icons'
    alias ll='eza -lah --color=always --icons --git'
    alias la='eza -a --color=always --icons'
    alias lt='eza --tree --level=2 --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah'
    alias la='ls -A'
fi

# Use bat instead of cat if available
command -v bat &>/dev/null && alias cat='bat --style=auto'

# Use ripgrep instead of grep
command -v rg &>/dev/null && alias grep='rg'

# Safer defaults
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# System
alias update='sudo mint-update'
alias upgrade='sudo mint-update'
alias clean='sudo mint-clean'
alias fetch='mint-fetch'
alias health='sudo mint-health'
alias doctor='sudo mint-doctor'
alias snapshot='sudo mint-snapshot'
alias optimize='sudo mint-optimizer'
alias drivers='sudo mint-driver-manager'

# Network
alias myip='curl -s ifconfig.me && echo'
alias localip="ip route get 1 | awk '{print \$NF;exit}'"
alias ports='ss -tulpn'
alias listening='ss -tlnp'
alias ping='ping -c 5'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'

# Pacman / AUR
alias pacin='sudo pacman -S'
alias pacrem='sudo pacman -Rns'
alias pacsearch='pacman -Ss'
alias pacinfo='pacman -Si'
alias paclist='pacman -Q'

# Docker
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias di='docker images'

# Disk
alias df='df -h'
alias du='du -sh'
alias ncdu='ncdu --color dark'

# ── Functions ─────────────────────────────────────────────────────────────────

# Extract any archive
x() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2|*.tbz2) tar xjf "$1" ;;
            *.tar.gz|*.tgz)   tar xzf "$1" ;;
            *.tar.xz|*.txz)   tar xJf "$1" ;;
            *.tar.zst)         tar --zstd -xf "$1" ;;
            *.tar)             tar xf "$1" ;;
            *.bz2)             bunzip2 "$1" ;;
            *.gz)              gunzip "$1" ;;
            *.rar)             unrar x "$1" ;;
            *.zip)             unzip "$1" ;;
            *.7z)              7z x "$1" ;;
            *.zst)             zstd -d "$1" ;;
            *)                 echo "Cannot extract: $1" ;;
        esac
    else
        echo "'$1' is not a file"
    fi
}

# Quick HTTP server
serve() { python3 -m http.server "${1:-8080}"; }

# mkcd — mkdir + cd
mkcd() { mkdir -p "$1" && cd "$1"; }

# fzf git branch checkout
fbr() {
    command -v fzf &>/dev/null || return
    git checkout "$(git branch --all | grep -v HEAD | fzf --height 40% | sed 's/.* //')"
}

# Show PATH nicely
path() { echo "$PATH" | tr ':' '\n' | nl; }

# System info
info() { mint-fetch; }

# ── Environment ───────────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R --mouse'
export TERM=xterm-256color
export COLORTERM=truecolor
export MANPAGER='nvim +Man!'

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Development
export GOPATH="$HOME/go"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$GOPATH/bin:$PATH"

# ── Show system info on new terminal ─────────────────────────────────────────
[[ -z "$TMUX" ]] && command -v mint-fetch &>/dev/null && mint-fetch
