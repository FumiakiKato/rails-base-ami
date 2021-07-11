#!/bin/bash -e

# swap
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# install yum modules
sudo yum update
sudo yum install -y gcc \
  gcc-c++ \
  dstat \
  sysstat \
  iotop \
  jq \
  htop \
  readline-devel \
  libffi-devel \
  openssl \
  openssl-devel \
  python27-devel \
  libcurl-devel \
  git \
  ImageMagick \
  ImageMagick-devel \
  epel-release

# install tools
sudo yum install -y @Development tools

# install postgresql
sudo yum install -y https://yum.postgresql.org/11/redhat/rhel-7-x86_64/postgresql11-libs-11.3-1PGDG.rhel7.x86_64.rpm \
  https://yum.postgresql.org/11/redhat/rhel-7-x86_64/postgresql11-devel-11.3-1PGDG.rhel7.x86_64.rpm \
  https://yum.postgresql.org/11/redhat/rhel-7-x86_64/postgresql11-11.3-1PGDG.rhel7.x86_64.rpm \
  https://yum.postgresql.org/11/redhat/rhel-7-x86_64/postgresql11-contrib-11.3-1PGDG.rhel7.x86_64.rpm

echo 'export PATH="/usr/pgsql-11/bin:$PATH"' >> ~/.bash_profile
. ~/.bash_profile

# install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
. ~/.bash_profile
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby ${RUBY_VERSION}
rbenv install ${RUBY_VERSION}
rbenv global ${RUBY_VERSION}
rbenv rehash

# install node ${NODE_VERSION}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
cat << 'EOS' >> ~/.bash_profile
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOS
. ~/.bash_profile
nvm install ${NODE_VERSION}

# install awslogs
sudo yum install -y awslogs
sudo sed -i "s/region.*/region = ap-northeast-1/g" /etc/awslogs/awscli.conf

# install nginx
sudo amazon-linux-extras install -y nginx1.12
sudo yum install -y nginx

# Set Timezone to JST
sudo timedatectl set-timezone Asia/Tokyo

# install clamav aide
sudo amazon-linux-extras install -y epel
sudo yum install -y clamav aide
sudo mkdir -p /var/log/clamav

# yarn
curl -L https://yarnpkg.com/install.sh | bash -s -- --version 1.16.0

# mkdir
sudo mkdir -p /var/www
sudo chown ec2-user:ec2-user /var/www