### Aliases for `~/.bashrc ~/.zshrc`

```
alias gs="git status"
# graph look
alias gitl="git log --oneline --graph --decorate --full-history"
# graph look with full history
alias gitlf="git log --oneline --graph --decorate --full-history --all"
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
alias docker_rmi="docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi -f"
alias docker_rm="docker ps -a | grep -E \"Exited.*?ago\" | awk '{print $1}' | xargs docker rm -f"
alias ll="ls -lhA"
alias refresh="killall -KILL Finder;killall -KILL Dock;killall -KILL SystemUIServer"
alias lr="ls -1tl | head -20"
alias lockscreen='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CGSession -suspend'
# activate current python environment
alias ss="pipenv shell"
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

```
