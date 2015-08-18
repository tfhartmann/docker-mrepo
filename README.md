# PuppetDB 

Run a PuppetDB Server out of docker

## requirements and assumptions
This container has a couple of assumptions and requirements. 

* You need a Postgres Server running.  This server can be another container, a RDS end point or a physical DB somewhere 
* Puppet Master server running. The Puppetlabs/puppetdb module uses ssl certs created during your nodes inital puppet runs so you will
  need at least a token puppet master running that the container(s) can connect to to initialze the certs. 


To test against another container you can link the two containers. To Run a puppet master run something like this:
```Shell
docker run -it -d -h puppet --name puppet -h puppet tfhartmann/puppetserver
```
Then Link PuppetDB to the master:
```Shell
docker run --link puppet:puppet -P -it -d tfhartmann/puppetdb
```

## Examples



#### `Run PuppetDB`


docker run --link puppet:puppet  -it --rm tfhartmann/puppetdb


docker run --link puppet:puppet -P -it -d tfhartmann/puppetdb

##  environment variables 
### `DBHOST`
You ***MUST** Pass a DB host into the container, otherwise puppetdb will have no idea what to connect to as it doesn't run a local db.


### `DBUSER`
The Postgres user that has access to the puppetdb database on your postgres server.
Defaults to 'puppetdb'
```Shell
-e DBUSER='puppetdb'
```

### `DBPASS`
The Postgres password for the above user. Defaults to 'puppetdb'
```Shell
-e DBPASS='puppetdb'
```

### `SSL`
Use SSL to connect to the postgres DB Defaults to false
```Shell
-e SSL=true/false
```

### `JAVA_ARGS`
Pass Java args 
```Shell
-e JAVA_ARGS=''
```

### `NODE_TTL`

### `NODE_PURGE_TTL`

