# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# fix python ssl issue
export PATH="/usr/local/opt/openssl/bin:/usr/local/opt/python/libexec/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="my"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
#   git
  gitfast
#   osx
  pip
  kubectl
#   brew
  cargo
  docker
  zsh-peco-history
  pyenv
)

source $ZSH/oh-my-zsh.sh
# . ~/.cdm-completion.sh

export CFLAGS="-I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix openssl)/lib"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
# pyenv init

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PYTHONSTARTUP="$HOME/.pythonstartup.py"
# eval "$(pipenv --completion)"

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/usr/local/sbin"

alias gs="git status"
# graph look
alias gitl="git log --oneline --graph --decorate"
alias gitla="git log --oneline --graph --decorate --full-history --all"
# graph look with full history
alias gitlp="git log --oneline --graph --decorate --full-history --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold red)%d%C(reset)'"
# git log, ignore the individual commits brought in to your history by such a merge
alias gitlm="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=relative --first-parent"
# pretty git log with relative dates
alias gitll="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=relative"
# pull current branch from origin
alias gitp="git pull origin $(git rev-parse --abbrev-ref HEAD)"
# show commits that make a difference between current branch and master
function gitlb() {
    current_branch=$('git branch | grep \* | cut -d ' ' -f2')
    git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=relative master..$current_branch
}
# show file changes stats
alias gitf="git log --stat --oneline"
# show last used branches
alias gitb="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset)) - %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject)'"
# git diff but over all git log
alias gitd="git log -p"
# git diff that githlight characters in line that were changed
alias gd="git diff --color | diff-so-fancy | less"
alias gdd="git diff --cached --color | diff-so-fancy | less"
alias gtags="git for-each-ref --sort=-creatordate --format '%(objectname:short) %(refname:lstrip=-1) %(tagger:name) %(creatordate:human-local)' refs/tags"
alias grb='git branch -r | grep -v HEAD | while read b; do git log --color --format="%ci _%C(magenta)%cr %C(bold cyan)$b%Creset %s %C(bold blue)<%an>%Creset" $b | head -n 1; done | sort -r | cut -d_ -f2- | sed "s;origin/;;g" | head -20'
alias docker_rmi="docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi -f"
alias docker_rm="docker ps -a | grep -E \"Exited.*?ago\" | awk '{print $1}' | xargs docker rm -f"
alias ll="ls -lhA"
alias refresh="killall -KILL Finder;killall -KILL Dock;killall -KILL SystemUIServer"
alias lr="ls -1tl | head -20"
alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
#alias ss="pipenv shell"
alias ss="poetry shell"
# alias ss="source .venv/bin/activate"
alias ssc="python -m .venv"
function watch() {
    while :; do res=`bash -c "$@"`;clear; echo $res; sleep 2; done
}
#function ss() {
#    eval $(python -c 'import sys; print("source ../venv/{}/bin/activate".format(sys.argv[1].split("/")[-1]))' $(pwd))
#}
# show conficts
function gitc() {
    for i in $(git status -s | grep ^UU | cut -c4-); do
        echo -e "\e[31m'$i\e[39m"
        awk '/<<<<<<</,/>>>>>>>/' $i;
    done
}
alias vsrm="rm -rf .vscode"
alias dockerh="docker history --no-trunc --format '📦 {{.Size}}\n{{.CreatedBy}}\n'"
# alias jq="jq -C | less -R"
alias jql="jq -C | less -R"
alias date1='date +%Y-%m-%d\ %H:%M:%S'
# pip install Pygments
alias fzfp='fzf --preview "pygmentize {}" --color light'
#alias theme='osascript ~/Applications/Other/bin/change_terminal_theme.scpt'
alias dark='osascript ~/Applications/Other/bin/change_terminal_theme.scpt my'
alias light='osascript ~/Applications/Other/bin/change_terminal_theme.scpt Basic'
# brew install dark-mode
function theme() {
	if [[ $(dark-mode status) = 'off' ]]; then
		osascript ~/Applications/Other/bin/change_terminal_theme.scpt my;
		~/Applications/Other/bin/vscode_change_theme.py --theme dark
		dark-mode on
	else
		osascript ~/Applications/Other/bin/change_terminal_theme.scpt Basic;
		~/Applications/Other/bin/vscode_change_theme.py --theme light
		dark-mode off
	fi
}
#fbr() {
#  local branches branch
#  branches=$(git branch --all | grep -v HEAD) &&
#  branch=$(echo "$branches" |
#           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
#  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
#}
klog() {
	kubectl logs --tail 30 -f $(kubectl get pods | fzf | awk '{print $1}')
}
kex() {
	kubectl exec -it $(kubectl get pods | fzf | awk '{print $1}') sh
}
ks() {
	preview='kubectl describe services $(echo {} | cut -d " " -f1 | tr -d "[:space:]")'
	kubectl describe services $(kubectl get services | fzf --preview $preview | awk '{print $1}') | less
}
gb() {
	preview='git show --color=always $(echo {} | tr -d "[:space:]")'
	branch=$(git branch --sort=committerdate | fzf --no-sort --preview "$preview" | awk '{print $1}')
	git checkout $branch
}
#fkill() {
#    set pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')
#
#    if [[ -n "$pid" ]]
#   	then
#        echo $pid | xargs kill -9
#	fi
#}
gstash() {
	git stash list | fzf --preview 'git stash show $(echo {} | cut -d ":" -f1)'
}
history_top () {
	history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10;
}
pj() {
	cd $(projects=$(for i in ~/Documents/*projects/*; do if [[ -d $i ]]; then echo $i; fi; done); echo $projects | fzf)
}

# show execution time for command
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
	timer_show=$(python -c "from datetime import timedelta; print(str(timedelta(seconds=$timer_show)))")
    export RPROMPT="%F{cyan}${timer_show} %{$reset_color%}"
    unset timer
  fi
}

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PYTHONSTARTUP=~/.pythonrc
export GOPATH="${HOME}/.go"
export GOROOT="/usr/local/opt/go/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin:$HOME/.poetry/bin:/Users/$HOME/.local/bin"
export PATH="$PATH:/Users/$HOME/Applications/Other/bin"
export PATH="$PATH:$HOME/.cargo/bin"
if [[ $PWD =~ ^'$HOME/Documents/projects/exos/exos'.* ]]
then
	export KUBECONFIG=~/.kube/config
else
	export KUBECONFIG=~/.kube/config.dev1
fi
