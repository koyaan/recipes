Setting up Nginx + Percona + PHP on Mac for Symfony 2
====================================================

This document shows how to setup a Nginx + Percona + PHP
stack on a Mac from scractch, if you want a one click installer 
there is on here: http://getmnpp.org/

Mac´s do not come with a decent package manager like apt-get. So first things first:

Install Command Line Tools for Xcode
------------------------------------

* Download and install Command Line Tools for XCode https://developer.apple.com/downloads 

Install the brew package manager
--------------------------------

* Homepage: http://brew.sh/
* Detailed instructions: https://github.com/mxcl/homebrew/wiki/Installation 
* Quick and dirty: Use ``ruby`` to install ``brew``

.. code-block:: bash

    $ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    

Install Nginx
-------------

* Homepage: http://nginx.org
* Use ``brew`` to install ``nginx``

.. code-block:: bash

    $ brew install nginx

* Start it with it´s default configuration:

.. code-block:: bash

    $ sudo nginx

You should now be able to connect to http://localhost:8080
If you can see the Nginx Default Screen shut it down for now:

.. code-block:: bash

    $ sudo nginx -s stop
    
Installing PHP 5.4
------------------

You need to tap some extra formulas to install php 5.4 with brew:

.. code-block:: bash

    $ brew tap homebrew/dupes
    $ brew tap josegonzalez/homebrew-php
    $ brew update
    $ brew install php54

Now make sure that ``/usr/local/bin`` comes before ``/usr/local`` in your ``PATH`` environment variable
One way to ensure this (which you can easily put in you .bash_profile): 

.. code-block:: bash
    
    $ export PATH=/usr/local/bin:$PATH

* Setup ``date.timezone`` in ``php.ini`` using our favorite editor ``vim``

.. code-block:: ini

    # /usr/local/etc/php/5.4/php.ini 
    
    date.timezone = Europe/Vienna
 

* Install intl extension and php accelerator

.. code-block:: bash

    $ brew install php54-intl
    $ brew install php54-apc
    
Install composer
----------------

* Homepage: http://getcomposer.org/
* To install globally run:

.. code-block:: bash
    
    $ curl -sS https://getcomposer.org/installer | php
    $ mv composer.phar /usr/local/bin/composer
    
Install Symfony 2.3.3 standard edition
--------------------------------------

For this example i use a www/symfony directory in my home directory

.. code-block:: bash

    $ mkdir  /Users/koyaan/www
    $ cd /Users/koyaan/www
    $ composer create-project symfony/framework-standard-edition symfony/ 2.3.3
    
The interactive config will pop up.
Defaults are fine for almost anything but:

* database name
* database user
* database password
* secret 

