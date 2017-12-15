# DevBox

### Introduction
DevBox provides a PHP development environment using Vagrant and VirtualBox. The development VM created is built on Ubuntu with Apache, Nginx, PHP and MySQL. The VM can be configured to use different versions of Ubuntu, PHP and MySQL. It can also be configured to use either Apache or Nginx.


### Configuration
DevBox can be configured using the `devbox.yaml` configuration file.


#### VM
The IP address for the VM can be changed by updating the `ip` property. Also the default name for the VM is 'devbox', this can be changed by adding the `name` property. The default hostname for the VM is also 'devbox', this can be changed by adding the `hostname` property.
```
ip: "192.168.22.18"
name: vmname
hostname: vmhostname
```
To use NFS for your synced folder, add the `nfs` property.
```
nfs: true
```


#### Ubuntu
By default DevBox uses Ubuntu 16.04. To use a different version, add/update the `ubuntu-ver` property. Supported versions are `14.04` and `16.04`. 
```
ubuntu-ver: "14.04"
```


#### Webserver
By default DevBox uses Nginx as the webserver. To use a different webserver, add/update the `webserver` property. The webservers supported are `nginx` and `apache`. 
```
webserver: apache
```


#### PHP
By default DevBox uses PHP 7.1. To use a different version, add/update the `php-ver` property. Supported versions are `5.6`, `7.0` and `7.1`.
```
php-ver: "7.0"
```
Note: PHP version 5.5 is also supported but this version is now EOL.

The VM includes the following PHP extensions/modules:
- cli
- curl
- fpm
- mysql

If you require additional PHP extensions/modules then they can be added to the `extenstion` property as follows:
```
extensions:
    - php5-gd
    - php5-json
    - php5-mcrypt
```
Note: Extensions are installed via Ubuntu's Advanced Packaging Tool (APT)


#### MySQL
By default DevBox uses MySQL 5.7. To use a different version, add/update the `mysql-ver` property. Supported versions are `5.5`, `5.6` and `5.7`.
```
mysql-ver: "5.6"
```


#### Websites
You can set up one or more sites by mapping the domain names to its root folder on the VM. The domain name is set via the `url` property and the root folder set via the `root` property. The root folder must be set to a directory in `/vagrant/sites/`. You must setup each site under `sites` property as follow:
```
sites: 
    - site1:
        url: site.example1.dev
        root: /vagrant/sites/example1
    - site2:
        url: site.example2.dev
        root: /vagrant/sites/example2

```
The domain name must be added to your machines `hosts` file. Example: 
```
192.168.22.18   site.example1.dev
192.168.22.18   site.example2.dev

```
To create a self-signed SSL certificate for the site add the following `ssl` property to the site where you want to add it.
```
sites: 
    - site1:
        url: site.example1.dev
        root: /vagrant/sites/example1
        ssl: true
    - site2:
        url: site.example2.dev
        root: /vagrant/sites/example2
```


#### Databases
You can create a MySQL database by adding the name for the database to the `databases` property.
```
databases:
    - dbname
```
Multiple databases can be created as follows:
```
databases:
    - dbname
    - dbname
    - dbname
```
The default user created for the databases is `devbox` with the password `secret`.


#### Xdebug
To install Xdebug add the following `xdebug` property:
```
xdebug: true
```


#### Laravel Envoy
To install Laravel Envoy add the following `envoy` property:
```
envoy: true
```


### Post provisioning
Use the `post.sh` file to run any further provisions that you require for your VM.


### Bash aliases
A number of default bash aliases are created for the VM. These can be found in the `aliases` file. Add any further aliases you require to this file before creating the VM.


### Other software included
- Git
- Composer
- NVM and Node with the following global packages:
    - Bower
    - Grunt
    - Gulp
- Yarn

### Installing on USB or EXTERNAL Disks
Use `install-on-usb.sh` script when you want to install the vagrant file from a USB. 

The vagrant file fails when you run `vagrant up` from a USB drive. Then you need to move the generated private_key to a local directory, and create a link to it, so you can bypass the thrown error. After that, the `vagrant up` must be run again.

This script only is provided to avoid running all the steps manually.

The script should run as `./install-on-usb.sh host_name`. `host_name` is the same name specified in the devbox.yaml file. 

Note: I do not know vagrant a lot, so I made this script only for my personal use. You can take it as is or, if you have better understanding of vagrant, improve the Vagrant file. But if you decide to improve it in a more efficient way, please, do not forget to share it with me :D

## Installing Symfony 4.0 on NGINX

This guidelines assumes that DEVBOX has PHP 7.1 installed.

#### Modifying `/etc/nginx/sites-available/example1.dev`
DEVBOX create a conf file for every site you specified in devbox.yaml. Suppose one of your create web site is example1.dev.

Follow the Symfony document to set a virtual host in nginx: https://symfony.com/doc/current/setup/web_server_configuration.html#nginx

For this, edit `/etc/nginx/sites-available/example1.dev` and update the file according Symfony documentation.
```
sudo vi /etc/nginx/sites-available/example1.dev
```

Remember the root directory of the virtual host should point to the public directory of your Symphony installation, i.e.:
```
   root /vagrant/sites/project-one/public;
```

After you configure your virtual host according to Symfony Documentation, look for the `fastcgi_pass` setting, it should be as follows:
```
        fastcgi_pass unix:/var/run/php/php7.1-fpm.sock;
```

#### Modifying `/etc/php/7.1/fpm/pool.d/www.conf`

Then, open `/etc/php/7.1/fpm/pool.d/www.conf`
```
sudo vi /etc/php/7.1/fpm/pool.d/www.conf
```
find
```
listen = /run/php/php7.1-fpm.sock
```
change to
```
listen = /var/run/php/php7.1-fpm.sock
```
