# Gitpal

## Explanation

Not long ago, a friend was involved in a group project. Their group mates were challenging, to say the least. One day, they recounted to me how they had to fix a number of issues that had arisen when one of the group mates overwrote main while 5-6 commits behind. Needless to say I was confused. The few times I'd forgotten to pull, git had always yelled at me to pull and fix it first. That was when they let me know their group mates refused to use git, and instead dragged and dropped to the github desktop client. Horrified, I decided to write a cli to guide people through git in a way that is potentially less catastrophic. And so, gitpal was born

## Installation

For now, just run the script. Can add an alias for it if you want. I intend to add a script to automate the process soon.

## Features

- Easy to use guided process
- Friendly language throughout
- Uses git commands at its core, so all those features (including not allowing you to push to if you're behind main)
- Requires confirmation to push to main
- Ability to unstage all files/undo commit at any point before push if you need to make a last minute change
- Commit message confirmation to avoid typos
- Branch switching in cli
- Create new branch in cli

## Todo

- Install script for easier usage
- --no-conf flag, can be passed in on running gitpal or set as default through installer script (will still require confirmation for pushing to main, I draw the line at that level of danger)
