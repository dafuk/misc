#!/usr/bin/perl
package redistd;
sub new
{
	use Socket;
	my $port = shift;
	my $host = shift;
	my $timeout = shift;
	$this->{timeout} = $timeout or 30;
	$this->{'conn'} = socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2]);

	#, $host, $port, $errno, $errstr, $timeout);
	if (!$this->{'conn'}) { die('i cannot socket') };
	connect(SOCKET,pack_sockaddr_in($port,inet_aton($host)));
}
sub callredis
{
	my $cmd = shift; # why sanitize if you should only use it yourself?
	if ('quit' eq lc($cmd)) {return fclose($this->{'conn'});}
	$return = print $this->{'conn'}, redistd::_multi_bulk_answer($cmd) ;
	if ($return eq false) {	die('foo'); }
	$answer = redistd::_answer($this->{'conn'});

	if ('hgetall' eq substr(lc($cmd), 0, 7))
	{
		$answer_count = count($answer);
		$hash_answer = array();
		for ($i = 0; $i < $answer_count; $i += 2)
		{
			$hash_answer[$answer[$i]] = $answer[$i+1];
		}

			return $hash_answer;
		}

		return $answer;
	}


sub _multi_bulk_answer
{
	my $cmd = shift;
	$tokens = $cmd; #str_getcsv($cmd, ' ', '"');
	$tokens =~ s/ /\"/g;
	$number_of_arguments = scalar(keys %tokens); #count($tokens);
	$multi_bulk_answer = "*$number_of_arguments\r\n";
	foreach $tokens ($token) { $multi_bulk_answer .= redistd::_bulk_answer($token); }
	return $multi_bulk_answer;
}

sub _bulk_answer
{
	my $arg = shift;
	return '$'.length($arg)."\r\n".$arg."\r\n";
}

sub _answer
{
	$answer = <SOCKET>;
	if ( $answer eq false) {die('Fail to read response');}

	$answer = chomp($answer);
	$answer_type = $answer[0];
	$data = substr($answer, 1);
	use Switch;
	switch($answer_type)
	{
		case '+' {
			if ('ok' == lc($data)) { return true};
			return $data;
		}
		case '-'{
			die(substr($data, 4));
		}
		case ':'{
			return $data;
		}
		case '$'{
			$data_length = intval($data);
			if ($data_length < 0) { return NULL };
			$bulk_answer = stream_get_contents($this->{'conn'}, $data_length + strlen("\r\n"));
			if ( $bulk_answer eq false) { die('Fail to read response');}
			return chomp($bulk_answer);
		}
		case '*'{
			$bulk_answer_count = intval($data);
			if ($bulk_answer_count < 0)  { return NULL };
			$multi_bulk_answer = array();
			for($i = 0; $i < $bulk_answer_count; $i++) { push @multi_bulk_answer, $this->_answer($this->{'conn'}); }
			return $multi_bulk_answer;
		}
		else {
			die("Unsupported response: $answer"); }
	}
}
1;
