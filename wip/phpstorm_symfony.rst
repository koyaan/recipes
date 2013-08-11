phpstorm + symfony 2
====================

Misc
----


* exclude page directory (avoid mutliple class defintion problems)


debugging console commands
--------------------------

* Run > Edit Configurations
* Add new Configuration
	* File:  /home/armin/www/sonata-sandbox/app/console
	* Arguments: sonata:page:update-core-routes --site=2
	* Custom working directory: /home/armin/www/sonata-sandbox
* Add PHP Interpreter
	* /usr/bin/php for me point to whatever you use in console
