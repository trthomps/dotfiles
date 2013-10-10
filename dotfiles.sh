#!/bin/zsh
[[ -z "$DF_DIR" ]] && DF_DIR=$HOME/.dotfiles
[[ -z "$DF_UPCHECKTIME" ]] && DF_UPCHECKTIME=604800 # 1 week default
DF_BLACKLIST+=("README.md" "dotfiles.sh")

function dfinstall() {
    for file in `ls $DF_DIR`; do
        # Check if file is black listed
        bl=false
        for e in "${DF_BLACKLIST[@]}"; do 
            if [[ "$file" = "$e" ]]; then 
                bl=true; 
            fi
        done

        if [[ "$bl" == "false" ]]; then
            dfile=$file

            # replace # with .
            if [[ "${file[0,1]}" = "#" ]]; then
                dfile=".${file[2,${#file}]}"
            fi
            if [ ! -L "$HOME/$dfile" ]; then
                echo "### Installing $HOME/$dfile --> $DF_DIR/$file"
                ln -sfn "$DF_DIR/$file" "$HOME/$dfile"
            fi
        fi
    done
}

function dfup() {
    cd $DF_DIR
    echo "### Checking for dotfile updates..."
        git pull
        dfinstall
    echo "### done"
    echo "### Checking for submodule updates..."
        git submodule update --init --recursive
    echo "### done"
    echo $(date +%s) > $DF_DIR/.lastup
}

if [ -f "$DF_DIR/.lastup" ]; then
    read lastup < $DF_DIR/.lastup
else
    lastup=0
fi
((lastup = `date +%s` - lastup))

if [ $lastup -ge $DF_UPCHECKTIME ]; then
    dfup
fi
