#!/usr/bin/awk -f

BEGIN { x=0 } 
/a/  { x=x+1 } 
END   { print "I found " x " occurances of a. :)" }