#/bin/bash -e

RUBY_VERSION=${1:? is not given}

# swap
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# install yum modules
sudo yum update
sudo yum install -y \
  git \
  make \
  gcc-c++ \
  patch \
  openssl-devel \
  libyaml-devel \
  libffi-devel \
  libicu-devel \
  libxml2 \
  libxslt \
  libxml2-devel \
  libxslt-devel \
  zlib-devel \
  readline-devel \
  mysql \
  mysql-server \
  mysql-devel \
  ImageMagick \
  ImageMagick-devel \
  epel-release

# install nginx
sudo amazon-linux-extras install -y nginx1.12
sudo yum install -y nginx

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

# install node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
cat << EOS >> ~/.bash_profile
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
EOS
nvm install v14.17.3

# install yarn
curl -L https://yarnpkg.com/install.sh | bash -s -- --version 1.12.3
echo 'export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"' >> ~/.bash_profile
. ~/.bash_profile

# Set Timezone to JST
sudo timedatectl set-timezone Asia/Tokyo

# install clamav aide
sudo amazon-linux-extras install -y epel
sudo yum install -y clamav aide
sudo mkdir -p /var/log/clamav

# awslogs
sudo yum install -y awslogs
sudo sed -i "s/region.*/region = ap-northeast-1/g" /etc/awslogs/awscli.conf

# mkdir
sudo mkdir -p /var/www
sudo chown ec2-user:ec2-user /var/www