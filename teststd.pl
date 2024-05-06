#!/usr/bin/perl
require 'redistd.pm';
my $redisconn  = redistd::new("127.0.0.1","6379");
print redistd::callredis('keys *');
