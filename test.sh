#!/bin/bash

. benlib.sh

 awk -F":" $'{ print $1 $3 }' /etc/passwd

#stripcomments /etc/apache2/httpd.conf