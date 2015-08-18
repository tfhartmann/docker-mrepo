#!/bin/bash

: ${DBHOST:=puppetdbopen.cpmpxebkd7tp.us-east-1.rds.amazonaws.com}
#: ${DBHOST:=$PUPPET_PORT_8140_TCP_ADDR}
: ${DBUSER:=puppetdb}
: ${DBPASS:=puppetdb}
# SSL Doesn't actually work yet
: ${SSL:=true}
: ${PUPPETHOST:=$PUPPET_PORT_8140_TCP_ADDR}


# If This Puppet Server isn't a CA Server disable it
if  [ $CA_SERVER ]
  then
    echo "### Disable Local CA Make sure you have passed in or linked a Puppet Server and CA Server ###"
    # Configure Puppet Certs
    echo "Puppet First run to request cert"
    puppet agent --test --server $CA_SERVER
    echo "Puppet Second run - nuke it from orbit just to be sure..."
    puppet agent --test --server $CA_SERVER
    puppet resource file /etc/puppetserver/bootstrap.cfg ensure=file mode='0644' owner=root group=root source='/tmp/bootstrap-ca-disabled.cfg'
fi

# run that puppet server!
/usr/bin/puppetserver foreground

puppet apply -e 'class { "puppetdb::server": database_host => "'${DBHOST}'", database_username => "'${DBUSER}'", database_password => "'${DBPASS}'", puppetdb_service_status => stopped, listen_address => "0.0.0.0", ssl_listen_address => "0.0.0.0" }' --verbose
