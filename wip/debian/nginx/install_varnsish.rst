https://www.varnish-cache.org/installation/debian

.. code-block:: bash

    curl http://repo.varnish-cache.org/debian/GPG-key.txt | apt-key add -
    echo "deb http://repo.varnish-cache.org/debian/ wheezy varnish-3.0" >> /etc/apt/sources.list
    apt-get update
    apt-get install varnish
