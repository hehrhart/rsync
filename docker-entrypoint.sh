#!/bin/sh

eval `ssh-agent -s` 1>/dev/null

# If we set RSA_KEY variable, change value of id_rsa file
if [ "$RSA_KEY" ]; then echo $RSA_KEY | base64 -d > /root/.ssh/id_rsa; fi

# Exit if id_rsa file doens't exist
if [ ! -s "$PATH_ID_RSA" ]
then
  echo "$PATH_ID_RSA is empty, need to pass \$PATH_ID_RSA at compile time or in env at run time"
  exit 0
fi

# If we use pssphrase, add in ssh-agent
if [ "$RSA_PASSPHRASE" ]
then
expect 1>/dev/null << EOF
  spawn ssh-add /root/.ssh/id_rsa
  expect "Enter passphrase"
  send "$RSA_PASSPHRASE\n"
  expect eof
EOF
fi

# create exclude file with all directories or files to be not transfer
for i in $(echo $SYNC_EXCLUDE | tr ":" "\n"); do echo $i >> $SYNC_EXCLUDE_PATH_FILE; done

# Test if we have a new command to the container
if [ -z "$@" ]
then
  # Test if we have all variable for exec default command
  if [[ -z "$SYNC_USER" || -z "$SYNC_HOST" || -z "$SYNC_DIST" ]]
  then
    echo "
One or more variables are undefined:
  - \$SYNC_USER: username use by ssh
  - \$SYNC_HOST: the host of the target server
  - \$SYNC_DIST: Absolute path of folder where files must be copied
  - \$SYNC_SRC: (default: /root/sync/) Absolute path of folder where includes files to be copied
  - \$SYNC_PORT: (default: 22) the port of the target server
  - \$SYNC_EXCLUDE: (optional) List of directories or files to be exclude
"
    exit 0
  fi
  rsync -e "ssh -i /root/.ssh/id_rsa -o StrictHostKeyChecking=no -p $SYNC_PORT" -Phrvz --delete --exclude-from '/exclude-list.txt' $SYNC_SRC $SYNC_USER@$SYNC_HOST:$SYNC_DIST
else
  exec "$@"
fi