Setting up Nginx + Percona + PHP + Symfony 2.3 on Debian Wheezy 
===============================================================

This document documents how I setup my Nginx + Percona + PHP-FPM
+ Symfony 2.3 stack for Development on Debian Wheezy.

This is NOT meant to be a production config! 

Install Percona
---------------

* Homepage: http://www.percona.com
* quick instructions from http://www.percona.com/doc/percona-server/5.5/installation/apt_repo.html

.. code-block:: bash

    $ sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

put this in ``/etc/apt/sources.list``

.. code-block::

    deb http://repo.percona.com/apt wheezy main
    deb-src http://repo.percona.com/apt wheezy main

and install it:

.. code-block:: bash

    $ sudo apt-get update
    $ sudo apt-get install percona-server-server-5.5 percona-server-client-5.5


Install Nginx
-------------

Homepage: http://nginx.org


.. code-block:: bash

    $ sudo apt-get install nginx

Start it with it´s default configuration:

.. code-block:: bash

    $ sudo nginx

You should now be able to connect to http://localhost

    
Install PHP
-----------

PHP CLI
~~~~~~~

I don't use ``php5`` because that would install unnecessary packages like apache.

.. code-block:: bash

    $ apt-get install php5-cli

At the times of writing this ``php -v`` is ``PHP 5.4.4-14+deb7u3 (cli) (built: Jul 17 2013 14:54:08)``


PHP FPM
~~~~~~~

.. code-block:: bash

    $ apt-get install php5-fpm


Setup ``date.timezone`` and ``short_open_tag`` in ``php.ini``  for both CLI and FPM

.. code-block:: ini

    # /etc/php5/cli/php.ini
    # AND 
    # /etc/php5/fpm/php.ini
    
    date.timezone = Europe/Vienna
    short_open_tag = Off


Install php modules Symfony expects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Needed are intl extension, php accelerator and PDO driver, i also install xdebug because it's just essential

.. code-block:: bash

    $ sudo apt-get install php5-intl
    $ sudo apt-get install php-apc
    $ sudo apt-get install php5-mysql
    $ sudo apt-get install php5-xdebug


Install composer
----------------

* Homepage: http://getcomposer.org/
* To install globally run:

.. code-block:: bash
    
    $ curl -sS https://getcomposer.org/installer | php
    $ sudo mv composer.phar /usr/local/bin/composer
    

Install Symfony 2.3.3 standard edition
--------------------------------------

For this example i use ``www/symfony`` in my home directory

.. code-block:: bash

    $ cd /home/koyaan/www
    $ composer create-project symfony/framework-standard-edition symfony/ 2.3.3
    
The interactive config will pop up.
Defaults are fine for almost anything for this example but you have to enter:

* database password
* secret

Create a Site configuration
---------------------------

I copied and adjusted this one from http://wiki.nginx.org/symfony

.. code-block:: conf

    upstream phpfcgi {
        server unix:/var/run/php5-fpm.sock; #for PHP-FPM running on UNIX socket
    }

    server {
        listen 80;
     
        server_name symfony.loc;
        root /home/koyaan/www/symfony/web;
     
        error_log /var/log/nginx/symfony.error.log;
        access_log /var/log/nginx/symfony.access.log;
     
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
            fastcgi_pass phpfcgi;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include fastcgi_params;
            fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param  HTTPS off;
        }
    }

Activate the site and reload nginx config

.. code-block:: bash

    $ sudo ln -s /etc/nginx/sites-available/symfony.loc /etc/nginx/sites-enabled/symfony.loc
    $ sudo /etc/init.d/nginx reload

Add symfony.loc to ``/etc/hosts``

.. code-block:: bash

    $ echo "127.0.0.1 symfony.loc" | sudo tee -a /etc/hosts


Now all that is left is fix permissions according to http://symfony.com/doc/current/book/installation.html#configuration-and-setup

.. code-block:: bash

    $ cd /home/koyaan/www/symfony
    $ rm -rf app/cache/*
    $ rm -rf app/logs/*
    $ sudo setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs
    $ sudo setfacl -dR -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs


http://symfony.loc/app_dev.php  should be now up and running!


Happy coding!
