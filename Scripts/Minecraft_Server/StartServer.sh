#!/bin/bash
echo "This will create your Minecraft Server with the playitgg Tunelling!!!"
cd Java/
tmux new-session -s "mySession" -d
tmux split-window -h
tmux send-keys -t 0 './playit-linux-amd64' C-m
tmux send-keys -t 1 'java -Xmx1024M -Xms1024M -jar server.jar nogui' C-m
tmux -2 attach-session -d
