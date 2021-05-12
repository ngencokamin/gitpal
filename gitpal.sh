#!/bin/bash
ask() {
    local prompt default reply

    if [[ ${2:-} = "Y" ]]; then
        prompt="Y/n"
        default="Y"
    elif [[ ${2:-} = "N" ]]; then
        prompt="y/N"
        default="N"
    else
        prompt="y/n"
        default=""
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read -n1 -r reply </dev/tty

        # Default?
        if [[ -z $reply ]]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

commit() {
    while true; do
        read -r -p "Please enter a commit message: " msg
        if ask "Does '$msg' look right?" Y; then
            if git commit -m "$msg"; then
                printf "Succesfully commited changes with message $msg\n"
                current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
                if [ "$current_branch" == "main" ] || [ "$current_branch" == "master" ]; then
                    pushprompt=N
                else
                    pushprompt=Y
                fi
                if ask "Push to branch $current_branch?" "$pushprompt"; then
                    if git push origin "$current_branch"; then
                        printf "\n Changes successfully pushed! Have a nice day :)"
                        exit 0
                    else 
                        git reset HEAD~
                        printf "ERROR! Could not push changes! Aborting."
                        exit 1
                    fi
                else
                    branches=()
                    eval "$(git for-each-ref --shell --format='branches+=(%(refname:short))' refs/heads/)"
                    echo
                    select branch in "${branches[@]}" "Cancel"; do
                    case $branch in
                    "")
                        echo "Invalid selection"
                        ;;
                        "Cancel")
                        echo "Branch switching cancelled"
                        # break
                        ;;
                        * )
                        echo "Branch $branch selected"
                        "$current_branch" = "$branch"
                        ;;
                            
                    esac
                    done
                fi

            else
                printf "ERROR! Could not commit changes! Aborting."
                exit 1
            fi            
            return 0
        else
            echo
            if ! ask "Would you like to try again?" Y; then
                echo
                if ask "Alright, would you like to unstage all files and revert to the latest commit?" Y; then
                    if git reset HEAD~; then
                        printf "\nAll changes reverted, have a nice day :)"
                        exit 0
                    else
                        printf "\nERROR! Could not unstage files! Aborting."
                        exit 1
                    fi
                else
                    printf "\nSure thing, have a good one!"
                    exit 0
                fi

            fi
        fi
    done
}

printf "Hi there!\n" 
pwd
if ask "Is this the directory you would like to push?" Y; then
    if git add -A ; then
        printf "Files added!\n"
        commit
    else
        printf "ERROR! Could not add files! Aborting."
        exit 1
    fi
else
    printf "\nPlease navigate to the correct directory and try again"
    exit 0
fi
