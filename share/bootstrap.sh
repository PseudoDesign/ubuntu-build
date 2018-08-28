set -x

apt-get install -y --no-install-recommends ubuntu-desktop
adduser --disabled-password --gecos "" cytovale
usermod -aG sudo cytovale
