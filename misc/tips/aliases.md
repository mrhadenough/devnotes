### Aliases for `~/.bashrc ~/.zshrc`

```
alias gs="git status"
alias gitl="git log --oneline --graph --decorate --full-history --all"
alias gitll="git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=relative"
alias gitlc="git log --oneline --graph --decorate"
function gitlb() {
    current_branch=$('git branch | grep \* | cut -d ' ' -f2')
    git log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=relative master..$current_branch
}
alias gitf="git log --stat --oneline"
alias gitb="git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset)) - %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject)' | head"
alias gitd="git log -p"
alias docker_rmi="docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi -f"
alias docker_rm="docker ps -a | grep -E \"Exited.*?ago\" | awk '{print $1}' | xargs docker rm -f"
alias ll="ls -lhA"
alias refresh="killall -KILL Finder;killall -KILL Dock;killall -KILL SystemUIServer"
alias lr="ls -1tl | head -20"
alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'

function ss() {
    eval $(python -c 'import sys; print("source ../venv/{}/bin/activate".format(sys.argv[1].split("/")[-1]))' $(pwd))
}

function gitc() {
    for i in $(git status -s | grep ^UU | cut -c4-); do
        echo -e "\e[31m'$i\e[39m"
        awk '/<<<<<<</,/>>>>>>>/' $i;
    done
}
function search() {
  search=$(find . -name "*$1*" | head -n 10)
  echo $search
}

alias todo="grep -Rin '# TODO\|// TODO' --exclude-dir=node_modules --exclude-dir='vendors' --exclude-dir=misc --exclude-dir=dist ."
alias tags_turfmapp='rm -rf tags* ; rm .tags* ; ctags -R --exclude=node_modules --exclude=cache --exclude=vendors --exclude="js-vendors" --exclude="translations" --exclude=templates --exclude="*.pyc,*.mo,*.po,*.css,*.sass,*.html,*.json,*.json.*" .'
alias tags="ctags --exclude=misc --exclude=node_modules --exclude=vendors --exclude=dist -R ."

```
