fpath=(~/.zsh_completions $fpath)
fpath=($fpath "/Users/steffen/.zfunctions")

# ZPlug stuff

if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi
source ~/.zplug/init.zsh

zplug "themes/robbyrussell", from:oh-my-zsh, as:theme

zplug "plugins/git", from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:3

zplug "zsh-users/zsh-history-substring-search"
zplug "joshskidmore/zsh-fzf-history-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

# plugin configurations

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=isearch

export ZSH_FZF_HISTORY_SEARCH_FZF_ARGS='+m -x --preview-window=hidden'

# direnv
eval "$(direnv hook zsh)"

# history setup

export HISTFILE=~/.zsh_history
export SAVEHIST=1000000
export HISTSIZE=100000

setopt inc_append_history
setopt HIST_IGNORE_ALL_DUPS
setopt share_history

# completions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

export GPG_TTY=$(tty)
