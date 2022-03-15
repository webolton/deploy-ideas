# Provision notes for deploying the app on AMI 2 with Capistrano

### Setup SSH

    mkdir ~/.ssh/
    chmod 700 .ssh
    touch ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    vim ~/.ssh/authorized_keys

Add `id_rsa.pub` to `authorized_keys` and update `~/.ssh/config` with alias. Comment out reference to
`.pem` in `~/.ssh/config`.


### Install RVM on the host

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

    \curl -sSL https://get.rvm.io | bash

    source /home/ec2-user/.rvm/scripts/rvm

### Install Ruby and Prerequisite gems

    rvm install ruby-2.4.4

    gem install bundler --no-document

    gem install rails -v 5.2.3 --no-document

    rvm use 2.4.4

### Install Postgres and git (as ec2-user)

    sudo yum install postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs

    sudo service postgresql initdb

    sudo service postgresql start

    sudo -u postgres createuser ec2-user

    sudo yum install git

### Set up database

I manually set up database.

```bash
sudo su

su - postgres

psql

CREATE USER "ec2-user";

ALTER USER "ec2-user" PASSWORD "#############";

ALTER USER "ec2-user" WITH SUPERUSER;

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE'; # Fix database encoding

DROP DATABASE template1;

UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';

\c template1

VACUUM FREEZE;
```

### Make project directory (as ec2-user)

    sudo mkdir -p /var/www/digital-sel-api

### Deploy the code

## SSL

```bash
#change to our home directory
cd

# Download and install the "Extra Packages for Enterprise Linux (EPEL)"
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm

sudo yum install -y certbot python2-certbot-nginx

sudo su

certbot certonly --standalone -d api.digitalsel.com

```

## nginx

### The above worked

In order to get Certbot to run on Amazon Linux, I edited the source code of `certbot-auto` at line 842:

    elif grep -i "Amazon Linux" /etc/issue > /dev/null 2>&1 || \
        grep 'cpe:.*:amazon_linux:2' /etc/os-release > /dev/null 2>&1; then

I was then able to run:

    certbot-auto certonly --standalone -d api.digitalsel.com --debug

cron job to renew the cert:

    0 12 * * 6 sudo /usr/local/bin/certbot-auto renew