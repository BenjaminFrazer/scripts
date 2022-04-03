#!/bin/bash
chmod go-w /home/$USER
chmod 700 /home/$USER/.ssh
chmod 644 /home/$USER/.ssh/authorized_keys
chown $USER:$USER authorized_keys
chown $USER:$USER /home/$USER/.ssh
service ssh restart
