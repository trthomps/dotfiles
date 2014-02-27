#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    sudo $0 $@;
    exit $?
fi

while [ "$1x" != "x" ]; do
    case "$1" in
        "-t" | "--threshold")
            THRESHOLD=$2
            shift
            ;;
        "-d" | "--dir")
            DIR=$2
            shift
            ;;
        "-h" | "--help")
            echo -e "Usage: $0 [-t THRESHOLD] [-d DIR]\n"
            echo -e "\t-t | --threshold\tThreshold Percentage, Default: 0"
            echo -e "\t-d | --dir\t\tDirectory to check, Default: /tmp"
            exit 0
            ;;
    esac
    shift
done

THRESHOLD=${THRESHOLD:=0}
DIR=${DIR:=/tmp}

if [[ $(df -Ph ${DIR}) =~ .+[[:space:]]{1}([0-9]+[A-Z]{1})[[:space:]]+.*[[:space:]]{1}([0-9]+)%[[:space:]]{1}([[:graph:]]+) ]]; then
    total=${BASH_REMATCH[1]}
    percent=${BASH_REMATCH[2]}
    vol=${BASH_REMATCH[3]}
    if [ $percent -gt $THRESHOLD ]; then
        free=$((100-percent))
        echo -e "$free% free of $total on ${vol}\n"
        echo -e "Top 10 users\n"
        DU=$(du -xb --max-depth=1 $DIR | sort -rn)
        oifs=$IFS
        IFS=$'\n'
        i=0
        printf "%-30s %-10s %-8s %-8s\n" "DIR" "SIZE" "OWNER" "GROUP"
        for item in $DU; do
            ((i++))
            [[ $i -eq 1 ]] && continue
            [[ $i -gt 11 ]] && break

            if [[ $item =~ ^([0-9]+)[[:space:]]+([[:graph:]]+)$ ]]; then
                size=${BASH_REMATCH[1]}
                dir=${BASH_REMATCH[2]}

                if [[ $(ls -dl ${dir}) =~ ^([[:graph:]]+)[[:space:]]{1}([[:graph:]]+)[[:space:]]{1}([[:graph:]]+)[[:space:]]{1}([[:graph:]]+)[[:space:]]{1}.* ]]; then
                    owner=${BASH_REMATCH[3]}
                    group=${BASH_REMATCH[4]}
                fi

                if [ $size -ge 1073741824 ]; then
                    size=$(echo "scale=2;$size/1073741824"| bc)G
                elif [ $size -ge 1048576 ]; then
                    size=$(echo "scale=2;$size/1048576"| bc)M
                elif [ $size -ge 1024 ]; then
                    size=$(echo "scale=2;$size/1024" | bc)K
                fi

                printf "%-30s %-10s %-8s %-8s\n" $dir $size $owner $group
            fi
        done
        IFS=$oifs
    fi
fi
