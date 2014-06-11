This guide is a bit outdated + use with care
============================================

Setting up Nginx + Percona + PHP on Mac for Symfony 2
====================================================

This document shows how to setup a Nginx + Percona + PHP
stack on a Mac from scractch, if you want a one click installer 
there is on here: http://getmnpp.org/

Mac´s do not come with a decent package manager like apt-get. So first things first:

Install Command Line Tools for Xcode
------------------------------------

* Download and install Command Line Tools for XCode https://developer.apple.com/downloads 

If you don´t have them already, in my case installing git required and downloaded them.

Install the brew package manager
--------------------------------

* Homepage: http://brew.sh/
* Detailed instructions: https://github.com/mxcl/homebrew/wiki/Installation 
* Quick and dirty: Use ``ruby`` to install ``brew``

.. code-block:: bash

    $ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    
Install Percona
---------------

* Homepage: http://www.percona.com
* quick instructions from http://www.percona.com/doc/percona-server/5.5/installation/apt_repo.html

.. code-block:: bash

    $ brew install percona-server
    

To have launchd start percona-server at login:
    ``ln -sfv /usr/local/opt/percona-server/*.plist ~/Library/LaunchAgents``
Then to load percona-server now:
    ``launchctl load ~/Library/LaunchAgents/homebrew.mxcl.percona-server.plist``
Or, if you don't want/need launchctl, you can just run:
    ``mysql.server start``
    
Install Nginx
-------------

* Homepage: http://nginx.org
* Use ``brew`` to install ``nginx``

.. code-block:: bash

    $ brew install nginx

* Start it with it´s default configuration:

.. code-block:: bash

    $ nginx

You should now be able to connect to http://localhost:8080
If you can see the Nginx Default Screen shut it down for now:

.. code-block:: bash

    $ nginx -s stop

To have launchd start nginx at login:
    ``ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents``
Then to load nginx now:
    ``launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist``

Installing PHP 5.4
------------------

You need to tap some extra formulas to install php 5.4 with brew:

.. code-block:: bash

    $ brew tap homebrew/dupes
    $ brew tap josegonzalez/homebrew-php
    $ brew update
    $ brew install php54 --with-fpm

Make php-fpm autostart:
    ``ln -sfv /usr/local/opt/php54/homebrew-php.josegonzalez.php54.plist ~/Library/LaunchAgents/``
and load it now:
    ``launchctl load -w ~/Library/LaunchAgents/homebrew-php.josegonzalez.php54.plist``
check if it worked:
    ``lsof -Pni4 | grep LISTEN | grep php``


Now make sure that CLI php also uses brew version you have to change your ``PATH`` environment variable
One way to do this (which you can easily put in you .bash_profile): 

.. code-block:: bash
    
    $ export PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"

* Setup ``date.timezone`` in ``php.ini`` using our favorite editor ``vim``

.. code-block:: ini

    # /usr/local/etc/php/5.4/php.ini 
    
    date.timezone = Europe/Vienna
 

* Install intl extension and php accelerator

.. code-block:: bash

    $ brew install php54-intl
    $ brew install php54-apc
    

You can do a ``php -i | grep intl`` and ``php -i | grep apc`` to see if installation was successful.

Install composer
----------------

* Homepage: http://getcomposer.org/
* To install globally run:

.. code-block:: bash
    
    $ curl -sS https://getcomposer.org/installer | php
    $ mv composer.phar /usr/local/bin/composer
    
Install Symfony 2.4.2 standard edition
--------------------------------------

For this example i use a www/symfony directory in my home directory

.. code-block:: bash

    $ mkdir ~/www
    $ cd ~/www
    $ composer create-project symfony/framework-standard-edition symfony/ 2.4.2
    
The interactive config will pop up.
Defaults are fine for almost anything but:

* database name
* database user
* database password
* secret 


Create nginx site configuration
-------------------------------


I copied and adjusted this one from http://wiki.nginx.org/symfony
For quick & dirty you can just add this block to ``/usr/local/etc/nginx/nginx.conf``

.. code-block:: conf

    server {
        listen 8080;
    
        server_name symfony.loc;
        root /Users/armin/www/symfony/web;
    
        error_log /Users/armin/log/nginx/symfony.error.log;
        access_log /Users/armin/log/nginx/symfony.access.log;
    
        # strip app.php/ prefix if it is present
        rewrite ^/app\.php/?(.*)$ /$1 permanent;
    
        location / {
            index app.php;
            try_files $uri @rewriteapp;
        }
    
        location @rewriteapp {
            rewrite ^(.*)$ /app.php/$1 last;
        }
    
        # pass the PHP scripts to FastCGI server from upstream phpfcgi
        location ~ ^/(app|app_dev|config)\.php(/|$) {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include fastcgi_params;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param  HTTPS off;
        }
    }

Activate the site and reload nginx config

.. code-block:: bash

    $ nginx -s stop
    $ nginx

Add symfony.loc to ``/etc/hosts``

.. code-block:: bash

    $ echo "127.0.0.1 symfony.loc" | sudo tee -a /etc/hosts


http://symfony.loc:8080/app_dev.php  should be now up and running!


Happy coding!
