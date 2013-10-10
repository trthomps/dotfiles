#!/bin/zsh
[[ -z "$DF_DIR" ]] && DF_DIR=$HOME/.dotfiles
[[ -z "$DF_TARGET" ]] && DF_TARGET=$HOME
[[ -z "$DF_UPCHECKTIME" ]] && DF_UPCHECKTIME=604800 # 1 week default
DF_BASE=$DF_DIR/base

function dfinstall() {
    local SDIR=$1
    local LIST=$2

    for file in `ls -a $DF_BASE$SDIR`; do
        # Ignore . and ..
        [[ "$file" = "." || "$file" = ".." ]] && continue

        # File is ignored, starts with !
        [[ "${file[0,1]}" = "!" ]] && continue

        # File is recursive
        if [[ "${file[0,1]}" = "#" ]]; then
            dfinstall $SDIR/$file $LIST
            continue
        fi
        
        local TARGET=$DF_BASE$SDIR/$file
        local LINKDIR=$DF_TARGET${SDIR:gs/#//}
        local LINK=$LINKDIR/$file
        
        if [[ ! -d "$LINKDIR" ]]; then
            echo "Creating $LINKDIR"
            rm -rf $LINKDIR
            mkdir -p $LINKDIR
        fi

        if [[ "$LIST" = "true" ]]; then
            echo "$LINK --> $TARGET"
        else
            if [[ ! -L "$LINK" ]]; then
                echo "Installing $LINK --> $TARGET"
                rm -rf $LINK
                ln -sfn $TARGET $LINK
            fi
        fi
    done
}

function dflist() {
    echo "### List of installed"
    dfinstall "" "true"
}

function dfup() {
    cd $DF_DIR
    echo "### Checking for dotfile updates..."
    
    # Update remote branch
    git remote update >/dev/null
    
    # See what we need to do
    # If we're behind, hopefully no conflicts, you're on your own if there are
    git log | grep behind >/dev/null
    if [ $? -eq 0 ]; then
        echo "### Updates found, pulling from github"
        git pull
    fi

    # If we have changes to commit, commit them then push them
    if [[ "$DF_NOCOMMIT" == "true" ]]; then
        echo "### No Commit Enabled, not checking for files to push"
    else
        # Check first for add
        echo "### Looking for untracked files..."
        git status -s --ignore-submodules | grep -E '^\?\?.+'
        if [ $? -eq 0 ]; then
            echo -n "### Do you want to add these files? If not consider adding them to .gitignore (y/N) "
            read -sk addfiles
            echo
            if [[ $addfiles:l = y ]]; then
                git add -A
            fi
        else
            echo "### No untracked files found"
        fi

        # Check for modify/delete/new
        echo "### Looking for new or modified files..." 
        git status -s --ignore-submodules | grep -E '^( M|A ).+'
        if [ $? -eq 0 ]; then
            echo -n "### Do you want to commit these changes? (y/N) "
            read -sk commitchanges
            echo
            if [[ $commitchanges:l = y ]]; then
                git commit -a
            fi
        else
            echo "### No changes found"
        fi

        # Check if push is needed
        echo "### Checking if we're ahead of remote/origin..."
        git status --ignore-submodules | grep ahead >/dev/null
        if [ $? -eq 0 ]; then
            echo -n "### Do you want to push your changes upstream? (y/N) "
            read -sk pushchanges
            echo
            if [[ $pushchanges:l = y ]]; then
                git push
            fi
        else
            echo "### You're in sync with remote"
        fi
    fi

    echo "### Running dfinstall..."
    dfinstall
    echo "### done"
    
    echo "### Checking for submodule updates..."
    git submodule update --init --recursive
    echo "### done"
    
    echo `date +%s` > $DF_DIR/.lastup
    cd $OLDPWD
}

if [ -f "$DF_DIR/.lastup" ]; then
    read lastup < $DF_DIR/.lastup
else
    lastup=0
fi
((lastup = `date +%s` - lastup))

if [ $lastup -ge $DF_UPCHECKTIME ]; then
    if [ "$DF_NOUPDATE" != "true" ]; then
        dfup
    fi
fi
