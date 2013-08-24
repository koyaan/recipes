#!/bin/bash

echo 127.0.0.1 $1.loc | sudo tee -a /etc/hosts
sudo cp /etc/nginx/sites-available/symfony.loc /etc/nginx/sites-available/$1.loc 
sudo sed -i "s/symfony/$1/g" /etc/nginx/sites-available/$1.loc
sudo sed -i "s/phpfcgi/phpfcgi-$1/g" /etc/nginx/sites-available/$1.loc
sudo ln -s /etc/nginx/sites-available/$1.loc /etc/nginx/sites-enabled/$1.loc
rm -rf /home/armin/dev/www/$1/app/cache/*
rm -rf /home/armin/dev/www/$1/app/log/*
sudo setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX /home/armin/dev/www/$1/app/cache /home/armin/dev/www/$1/app/logs
sudo setfacl -dR -m u:www-data:rwX -m u:`whoami`:rwX /home/armin/dev/www/$1/app/cache /home/armin/dev/www/$1/app/logs
sudo /etc/init.d/nginx reload
