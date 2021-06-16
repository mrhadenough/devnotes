## Git

### nice formatting, show whole tree

`git log --graph --all --decorate --oneline --full-history`

### See old version of file by date

`git show HEAD@{2013-02-25}:./fileInCurrentDirectory.txt`

### Checkout file from stash

`git checkout stash@{0} -- path/to/file.txt`

### Check out file or folder with some version

`git checkout 1f425b5 -- src/img/button/`


### Merge branch by overriding completely using particular branch

```
git checkout branch_we_want_to_override_from_master
git merge -s ours master
```

### Search text in file history

```
git log -S'bar' -- foo.rb
git log -S'bar'
```

### Search file changes in history

```
git --no-pager log --oneline --stat | grep "file.py"
```

### Rename git branch remotely

```
git branch -m old_branch new_branch         # Rename branch locally
git push origin :old_branch                 # Delete the old branch
git push --set-upstream origin new_branch   # Push the new branch, set local branch to track the new remote
```

### Clean untracked files

```
git clean -n
# Clean Step - beware: this will delete files:
git clean -f
```

### See old version of git file

```
git show HEAD~:app/accounts/models.py | grep get_avatar_photo -A 30
```

### See all commits of some branch (not merged commits)

```
git log master..branch --oneline
```

### Add submodule

`git submodule add ssh://git@example.git lib`

### To remove a submodule you need to:

Delete the relevant section from the `.gitmodules` file.

Stage the `.gitmodules` changes `git add .gitmodules`

Delete the relevant section from `.git/config`.

Run `git rm --cached path_to_submodule` (no trailing slash).

Run `rm -rf .git/modules/path_to_submodule`

Commit `git commit -m "Removed submodule <name>"`

Delete the now untracked submodule files `rm -rf path_to_submodule`

Clone repo with submodule

With version 1.6.5 `git clone --recursive git://github.com/foo/bar.git`

### Get git repo with submodule

```
git clone git://github.com/foo/bar.git
git submodule init
git submodule update
# or
git submodule update --init --recursive
```

Show contributors stats
```
git shortlog -s -n
```
