# MREPO

Mirror and Serve Package Repos

## requirements and assumptions
This container has a couple of assumptions and requirements.

* You need a Postgres Server running.  This server can be another container, a RDS end point or a physical DB somewhere
* Puppet Master server running. The Puppetlabs/puppetdb module uses ssl certs created during your nodes inital puppet runs so you will
  need at least a token puppet master running that the container(s) can connect to to initialze the certs.



## Examples

#### `Mirror Repos`


`docker run -it --rm tfhartmann/mrepo`

Mirror Repos and start apache to serve them over port 80

`docker run -p 80:80 -it -e WEB=True tfhartmann/mrepo`

Mirror Repos onto a shared file system - This allows your repos to persist after the container had gone to the bit bucket.

`docker run -it --rm -v /nfs/filesystem/repo:/mrepo tfhartmann/mrepo `


Mirror repose and freeze/lock the CentOS repo
`docker run -it --rm -e FROZEN=centos6-x86_64 -v /nfs/filesystem/repo:/mrepo tfhartmann/mrepo`


Run the container but overide the default repo config file. Use this to define the repos you want for your site

`docker run -it --rm -v /mrepo/config/repos.conf:/etc/mrepo.conf.d/repos.conf tfhartmann/mrepo`


##  Environment Variables

### `WEB`
Passing any value to the WEB variable will start apache at the end of the mrepo run, in a typical run you might pass `-e WEB=True`
This starts apache **after** mrepo runs, and will continue to serve the /mrepo/wwwdir until the container is stoped or killed.

### `FROZEN`
This variable takes a single argument, which *must* be the format "$dist-$arch" and must match the directory in the mrepo srcdir for the repo you want to freeze/lock.  You must also have a repo definition in your distro config called 'frozen'

For example, if you wanted to lock a CentOS repo that was configured like this:

```
[centos6.6]
name = CentOS $release ($arch)
release = 6.6
arch = x86_64
os = http://archive.kernel.org/centos-vault/$release/os/$arch/
centosplus = http://archive.kernel.org/centos-vault/$release/centosplus/$arch/
updates = http://archive.kernel.org/centos-vault/$release/updates/$arch/
extras = http://archive.kernel.org/centos-vault/$release/extras/$arch/
frozen = file:///mrepo/$dist-$arch/frozen
```
The value of the frozen variable would be `centos6-x86_64`

**FROZEN** Should only be passed *once* for each repo you want to freeze. It locks the repo at a particular point in time, and passing the FROZEN variable multiple times would updated the frozen repo to the most current version of the packages.

### `UPDATE`
UPDATE defaults to the string "True" and causes mrepo to run with the -guv argument.  It can be passed as *anything* other then true if you want to run this container, but do *not* want to updated your configured mirrors.
