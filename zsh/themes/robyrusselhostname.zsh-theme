
if [[ -n $SSH_CONNECTION ]]; then
    local host="%{[38;5;008m%}%n@%m"
    PROMPT="$host: %{$fg[cyan]%}%c%{$reset_color%}"
else
    PROMPT="%{$fg[cyan]%}%c%{$reset_color%}"
fi
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"