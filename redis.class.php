<?php

class redistd {

	public $conn = false;
	public $host = '127.0.0.1';
	public $port = 6379;
	public $timeout;
	function __construct($host='127.0.0.1', $port=6379, $timeout=NULL)
	{
		$timeout = $timeout ?: 30;
		$this->conn = fsockopen($host, $port, $errno, $errstr, $timeout);
		if (!$this->conn) throw new Exception($errstr, $errno);
	}
	function call($cmd) 
	{
		$cmd = trim($cmd);
		if ('quit' == strtolower($cmd)) return fclose($this->conn);
		$return = fwrite($this->conn, $this->_multi_bulk_answer($cmd));
		if ($return === false) 	throw new Exception();
		$answer = $this->_answer($this->conn);

		if ('hgetall' === substr(strtolower($cmd), 0, 7))
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


	function _multi_bulk_answer($cmd)
	{
		$tokens = str_getcsv($cmd, ' ', '"');
		$number_of_arguments = count($tokens);
		$multi_bulk_answer = "*$number_of_arguments\r\n";
		foreach ($tokens as $token) $multi_bulk_answer .= $this->_bulk_answer($token);
		return $multi_bulk_answer;
	}

	function _bulk_answer($arg)
	{
		return '$'.strlen($arg)."\r\n".$arg."\r\n";
	}

	function _answer()
	{
		$answer = fgets($this->conn);
		if ( $answer === false) throw new Exception('Fail to read response');

		$answer = rtrim(trim($answer));
		$answer_type = $answer[0];
		$data = substr($answer, 1);

		switch($answer_type)
		{
			case '+':
				if ('ok' == strtolower($data)) return true;
				return $data;

			case '-':
				throw new Exception(substr($data, 4));

			case ':':
				return $data;

			case '$':
				$data_length = intval($data);
				if ($data_length < 0) return NULL;
				$bulk_answer = stream_get_contents($this->conn, $data_length + strlen("\r\n"));
				if ( $bulk_answer === false) throw new Exception('Fail to read response');
				return trim($bulk_answer);

			case '*':
				$bulk_answer_count = intval($data);
				if ($bulk_answer_count < 0) return NULL;
				$multi_bulk_answer = array();
				for($i = 0; $i < $bulk_answer_count; $i++) $multi_bulk_answer[] = $this->_answer($this->conn);
				return $multi_bulk_answer;

			default:
				throw new Exception("Unsupported response: $answer");
		}
	}
}
?>
