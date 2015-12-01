#!/bin/bash

# OSX Terminal app calls bash_profile instead of bashrc. Source it automagically
src_prof="if [ -f ~/.bashrc ]; then source ~/.bashrc; fi"
if ! fgrep -qi "$src_prof" ~/.bash_profile; then echo $src_prof >> ~/.bash_profile; fi


# Note, myssh will create action audit log of ssh sessions to your home directory 
bashArr=(
'myssh () { ssh $1 2>&1 | tee -a ~/$1.log; }'
"alias ssh='myssh'"
"alias spot='mdfind -onlyin \`pwd\`'"
"alias locate='mdfind '"
"alias ll='ls -la'"
"alias cd..='cd ..'"
"alias wget='wget -c'"
"alias sha1='openssl sha1'"
"alias md5='openssl md5'"
"alias mount='mount |column -t'"
"alias now='date +\"%T\"'"
"alias nowtime=now"
"alias nowdate='date +\"%d-%m-%Y\"'"
"alias ports='netstat -tulanp'"
"alias header='curl -Ia'"
"alias javaws='/System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/javaws'"
"alias reboot-router='ssh root@10.10.10.254 /sbin/reboot'"
)
vimArr=(
"filetype off"
"set backspace=indent,eol,start"
"set ts=4"
"set ai"
"syntax enable"
"set bg=dark"
"set so=5"
'syntax match nonascii "[^\x00-\x7F]"'
"highlight nonascii guibg=Red ctermbg=2"
)

# Bash Additions
for i in "${bashArr[@]}"
do
    if ! grep -qi "^$i" ~/.bashrc; then
        echo $i >> ~/.bashrc
    else
        echo "Bash alias already exists. Skipping...";
    fi; 
done
echo 
# Vim Additions
for i in "${vimArr[@]}"
do
    if ! grep -qi "^$i" ~/.vimrc; then
        echo $i >> ~/.vimrc
    else
        echo "Vimrc line already exists. Skipping...";
    fi; 
done


$(. ~/.bashrc) 
printf "\r\n\r\n\r\nDone. Restart Terminal.app or source bashrc to start using aliasses.\r\n\r\n"
