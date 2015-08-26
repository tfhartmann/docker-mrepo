# MREPO

Mirror and Serve Package Repos 

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

#### `Mirror Repos`


docker run --link puppet:puppet  -it --rm tfhartmann/puppetdb


docker run --link puppet:puppet -P -it -d tfhartmann/puppetdb

#### `Serve Repos with Apache`

##  environment variables 
### `WEB`
Passing any value to the WEB variable will start apache, in a typical run you might pass `-e WEB=true`
This would start apache **after** mrepo runs, and will continue to serve the /mrepo/wwwdir until the container stops

### `FROZEN`

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

