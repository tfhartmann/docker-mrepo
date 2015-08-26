#!/bin/bash

: ${DBHOST:=puppetdbopen.cpmpxebkd7tp.us-east-1.rds.amazonaws.com}
#: ${DBHOST:=$PUPPET_PORT_8140_TCP_ADDR}
: ${DBUSER:=puppetdb}
: ${DBPASS:=puppetdb}
# SSL Doesn't actually work yet
: ${SSL:=true}
: ${PUPPETHOST:=$PUPPET_PORT_8140_TCP_ADDR}

: ${WEB}

rm -rf /var/run/httpd/* /tmp/httpd*

/usr/bin/mrepo -guvv

# run that web server!
if [ ${WEB} ]
    then
        echo 'Starting Apache...'
        exec /usr/sbin/apachectl -D FOREGROUND
fi
