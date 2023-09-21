#!/bin/bash

# Define the function as a string
dcls_function=$(cat << 'EOF'

dcls() {
  containers=$(docker ps --all --no-trunc --format='{{json .}}')
  max_name=0
  max_status=0
  max_host_port=0
  max_container_port=0
  
  while IFS= read -r container; do
    name=$(echo "$container" | jq -r '.Names')
    status=$(echo "$container" | jq -r '.Status')
    ports=$(echo "$container" | jq -r '.Ports' | tr ',' '\n')
    (( ${#name} > max_name )) && max_name=${#name}
    (( ${#status} > max_status )) && max_status=${#status}
    
    while IFS= read -r port; do
      host_port=${port%%->*}
      container_port=${port##*->}
      (( ${#host_port} > max_host_port )) && max_host_port=${#host_port}
      (( ${#container_port} > max_container_port )) && max_container_port=${#container_port}
    done <<< "$ports"
  done <<< "$containers"
  
  printf "%-${max_name}s  %-${max_status}s  %${max_host_port}s -> %-s\n" "NAMES" "STATUS" "HOST PORT" "CONTAINER PORT"
  echo "-----------------------------------------------------------------------------------"
  
  while IFS= read -r container; do
    name=$(echo "$container" | jq -r '.Names')
    status=$(echo "$container" | jq -r '.Status')
    ports=$(echo "$container" | jq -r '.Ports' | tr ',' '\n')
    first_port=true
    
    while IFS= read -r port; do
      host_port=${port%%->*}
      container_port=${port##*->}
      
      if [ "$first_port" = true ]; then
        printf "%-${max_name}s  %-${max_status}s  %${max_host_port}s -> %-s\n" "$name" "$status" "$host_port" "$container_port"
        first_port=false
      else
        printf "%-${max_name}s  %-${max_status}s  %${max_host_port}s -> %-s\n" "" "" "$host_port" "$container_port"
      fi
    done <<< "$ports"
  done <<< "$containers"
}

EOF
)

# Check if the function is already in .bashrc
if ! grep -q "dcls()" ~/.bashrc; then
  echo "$dcls_function" >> ~/.bashrc
  echo "dcls function has been added to your .bashrc file."
else
  echo "dcls function already exists in your .bashrc file."
fi

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
"alias reboot-router='ssh root@192.168.1.1 /sbin/reboot'"
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