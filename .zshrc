export EDITOR="vim"
bindkey -v 
ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="fishy"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

n() {
        $EDITOR ~/sync/notes/"$*".txt
}

nls() {
        ls -c ~/sync/notes/ | grep "$*"
}

commit ()
{
        bzr pull && bzr commit -m "$1" && bzr push
}

export PATH=$PATH:/home/oatman/.cabal/bin:/home/oatman/bin

source /usr/local/bin/virtualenvwrapper.sh

export LEIN_REPL_HOST=0.0.0.0

# ZSH Theme emulating the Fish shell's default prompt.
_fishy_collapsed_wd() {
  echo $(pwd | perl -pe "
   BEGIN {
      binmode STDIN,  ':encoding(UTF-8)';
      binmode STDOUT, ':encoding(UTF-8)';
   }; s|^$HOME|~|g; s|/([^/])[^/]*(?=/)|/\$1|g
")
} 

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT='%{$fg_bold[red]%}λ %{$fg[$user_color]%}$(_fishy_collapsed_wd)%{$reset_color%}%(!.#.) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"
. ~/.canonistack/novarc

alias apt-get='echo "Did you mean apt"'
source /home/oatman/system-setup/.zshrc; #0atman-shellconfig
