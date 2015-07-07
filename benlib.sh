#!/bin/bash

genpass()
{
    cat /dev/urandom | head -n 1  | md5| head -c $1
}
onlyroot()
{
    if [ `id -u` != 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
    fi
}
sysusers()
{
    awk -F":" $'{ print $1 $3 }' /etc/passwd
}
stripcomments()
{
    grep -v '^[ \t]*$\|^[ \t]*#' $1
}
