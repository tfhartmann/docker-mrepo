#!/bin/bash

: ${UPDATE:=True}
: ${WEB}
: ${REPO}
: ${DIST}
: ${VERBOSE:=False}

# Step1 Update the Repos - Defaults to 'True'
if [ ${UPDATE} == 'True' ]; then
  mrepo_cmd='/usr/bin/mrepo -gu'
  if [ ${VERBOSE} != 'False' ]; then
    mrepo_cmd+=' -vvv'
  fi
  if [ ! -z ${REPO} ]; then
    mrepo_cmd+=" -r ${REPO}"
  fi
  if [ ! -z ${DIST} ]; then
    mrepo_cmd+=" ${DIST}"
  fi
#  echo $mrepo_cmd
  eval ${mrepo_cmd}
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
    #Run mrepo, without updates/generation, to mount iso(s)
    /usr/bin/mrepo -v
    rm -rf /var/run/httpd/* /tmp/httpd*
    echo 'Starting Apache...'
    exec /usr/sbin/apachectl -D FOREGROUND
fi

#if we made it this far, we're exiting (mrepo finished its update, or apache exited)
#so lets unmount any isos mrepo had mounted as to not eat all the /dev/loop devices
/usr/bin/mrepo --unmount -vvv 

