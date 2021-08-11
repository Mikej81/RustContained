#!/bin/sh
clear while : do
  exec ./RustDedicated -batchmode -nographics \
  -server.ip $IPADDRESS \
  -server.port 28015 \
  -rcon.ip $IPADDRESS \
  -rcon.port $PORT \
  -rcon.password $RCONPASSWORD \
  -server.maxplayers $MAXPLAYERS \
  -server.hostname $SERVERNAME \
  -server.identity $SERVERIDENTITY \
  -server.level "Procedural Map" \
  -server.seed $SERVERSEED \
  -server.worldsize $WORLDSIZE \
  -server.saveinterval 300 \
  -server.globalchat true \
  -server.description "RustContained" \
  #-server.headerimage "512x256px JPG/PNG headerimage link here" \
  -server.url $SERVERURL
  echo "\nRestarting server...\n" 
  done