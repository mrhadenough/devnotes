local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
PROMPT='%{$fg[cyan]%}%c%{$reset_color%}$(git_prompt_info) '

ZSH_THEME_GIT_PROMPT_PREFIX=":%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" ${ret_status}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%} ✔"
