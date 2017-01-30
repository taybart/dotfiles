local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}%m%{$fg_bold[blue]%} %2~ %{$reset_color%}$(git_prompt_info)%{$reset_color%}%(!.%{$fg[red]%}#%{$reset_color%}.%{$fg[white]%}%B»%b%{$reset_color%}) '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
