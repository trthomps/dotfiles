dotfiles
========
This is my repository for all of my configuration files that I use across machines.  It checks for updates and can be used to bootstrap a new system quickly.  Files and folders starting with # will be renamed to start with a ., i.e. `#file` will become `~/.file`.

Installing
----------
Read-only:
```
git clone https://github.com/aka-butters/dotfiles.git ~/.dotfiles
./.dotfiles/dotfiles.sh
```
Read/Write (for me):
```
git clone git@github.com:aka-butters/dotfiles.git ~/.dotfiles
./.dotfiles/dotfiles.sh
```

Pulling Updates
---------------
Once `~/.dotfiles/dotfiles.sh` is being sourced by `~/.zshrc` you can just run `dfup` to manually update.  It will also automatically update once a week.

Pushing Updates
---------------
`dfup` now syncs back with github.  It's usually better to do it by hand, but it will remind you if you have unsyned changes.

Adding Submodules
-----------------
To add submodules run:
```
cd ~/.dotfiles
git submodule add http://example.com/repo/repo.git where/you/want/the/submodule
dfup
```
Of course, remember to add/commit your changes when you're ready :)
