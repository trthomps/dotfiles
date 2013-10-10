dotfiles
========
This is my repository for all of my configuration files that I use across machines.  It checks for updates and can be used to bootstrap a new system quickly.

Installing
----------
Remember to setup ssh keys first (or use https for read only)
```
git clone git@github.com:aka-butters/dotfiles.git ~/.dotfiles
./.dotfiles/dotfiles.sh
```

Pulling Updates
---------------
Once `~/.dotfiles/dotfiles.sh` is being sourced by `~/.zshrc` you can just run `dfup` to manually update.  It will also automatically update once a week.

Pushing Updates
---------------
If a change is made to a non-local config file, you must push the update or updates won't pull down
```
cd ~/.dotfiles
git commit -a
git push
```
