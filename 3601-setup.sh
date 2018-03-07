#!/bin/bash

#
# Sets up an Ubuntu droplet for 3601 project.
# Should be run as root.
#

# Add a group for users needing to do stuff with our application
addgroup webapp-deployment

# Add a user for running our server (we shouldn't run this stuff under root!)
echo
echo "We're adding a user to run your web application now."
echo "You'll be asked to set a password and enter some additional"
echo "information. Please remember the password. The rest of the info"
echo "doesn't matter very much."
echo "------------------------------------------------------------------"
adduser --ingroup webapp-deployment deploy-user

# Adding your ssh key to the new user so you can log in.
mkdir /home/deploy-user/.ssh/
cp /root/.ssh/authorized_keys /home/deploy-user/.ssh/
chown -R deploy-user /home/deploy-user/.ssh/
chgrp -R webapp-deployment /home/deploy-user/.ssh/

# Set up swap space
fallocate -l 3G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
echo 'vm.swappiness=10' >> /etc/sysctl.conf

# Install OpenJDK
apt-get update
apt-get upgrade 
apt-get install default-jdk

# Install MongoDB
apt-get install -y mongodb

#All done!
echo
echo "Basic setup should be done now."
echo "You should reboot this droplet and then login as 'deploy-user'"
echo "Clone your project, build it, and run it."
