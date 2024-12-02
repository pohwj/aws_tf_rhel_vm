#!/bin/bash

# Set a password for the ec2-user
echo 'ec2-user:password123!' | chpasswd

# Enable password authentication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd