#!/bin/bash

: ${UPDATE:=True}
: ${WEB}
: ${REPO}

# Step1 Update the Repos - Defaults to 'True'
if [ ${UPDATE} == 'True' ]; then
  if [ -n ${REPO} ]; then
    /usr/bin/mrepo -gu -r ${REPO}
  else
    /usr/bin/mrepo -gu
  fi
fi

# Create frozen repos
if [ ${FROZEN} ]; then
    if [ ! -d /mrepo/${FROZEN}/frozen ]; then
        mkdir /mrepo/${FROZEN}/frozen
    fi

    cd /mrepo/${FROZEN}
    REPOS=$(/bin/ls | /bin/grep -v frozen)
    rm frozen/*
    for RPM in $(find ${REPOS}/ -iname *.rpm) ; do
        ln ${RPM} frozen/${RPM##*/};
    done
    /usr/bin/mrepo -gv
fi

# run that web server!
if [ ${WEB} ]; then
    rm -rf /var/run/httpd/* /tmp/httpd*
    echo 'Starting Apache...'
    exec /usr/sbin/apachectl -D FOREGROUND
fi
