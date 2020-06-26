# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/kostya/.dotfiles/oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="lambda-mod"

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
plugins=(git docker brew django)

source $ZSH/oh-my-zsh.sh

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
# export SSH_KEY_PATH="~/.ssh/dsa_id"
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$PATH:$HOME/.yarn/bin:$HOME/Applications/Other/bin"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
eval "$(pyenv init -)"

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
alias gitb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset)) - %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject)'"
# git diff but over all git log
alias gitd="git log -p"
# git diff that githlight characters in line that were changed
alias diff="git diff --color | diff-so-fancy | less"
alias diffc="git diff --cached --color | diff-so-fancy | less"
alias gtags="git for-each-ref --sort=-creatordate --format '%(objectname:short) %(refname:lstrip=-1) %(tagger:name) %(creatordate:human-local)' refs/tags"
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
alias theme='osascript ~/Applications/Other/bin/change_terminal_theme.scpt'
