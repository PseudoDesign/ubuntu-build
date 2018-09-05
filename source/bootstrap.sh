##################################################################
# This script is run after the second stage debbootstrap.  
# System config, both for debug and release rootfs, should be here
##################################################################

# x: command echo
set -x

DEBUG=True

export LC_ALL=C.UTF-8 LANGUAGE=C.UTF-8 LANG=C.UTF-8

function add_to_environment() {
  variable=$1
  value=$2
  if ! grep -q "${variable}=" /etc/environment ; then
    echo "${variable}=\"${value}\"" >> /etc/environment
  fi
}

add_to_environment LC_ALL C.UTF-8
add_to_environment LANGUAGE C.UTF-8
add_to_environment LANG C.UTF-8

SYSTEM_NAME=pseudo-ubuntu

#Set the system name
if [ -n ${DEBUG+x} ]; then
  SYSTEM_NAME=${SYSTEM_NAME}-debug
fi
echo $SYSTEM_NAME > /etc/hostname

# Add the standard ubuntu package repos 
echo "deb http://ports.ubuntu.com/ubuntu-ports/ xenial main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ubuntu-ports/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ubuntu-ports/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

# Add the standard ubuntu keys
apt-key add --recv-keys --keyserver keyserver.ubuntu.com 40976EAF437D05B5
apt-key add --recv-keys --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32

# Upgrade all of the current packages
apt-get update
apt-get -y upgrade

if [ -n ${DEBUG+x} ]; then
  # Debug Config

  # Install debug packages
  apt-get install -y vim openssh-server
  # Enable root account
  echo "root:12345" | chpasswd
else
  # Release Config
  
  # Remove debug packages
  apt-get remove -y vim openssh-server 
  # Disable root account
  passwd -d root
fi

