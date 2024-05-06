<?php  
/*
don't use this, I wrote it under influence

*/

class mem
{
    public $ram = false; 
    public $entry_timeout = 3600; // 0 - infinite, 2592000 - maximum 
    public $memhost = '127.0.0.1';
    public $memport = 11211;
    function __construct($memhost=false,$memport=false) 
    {
    	if ($memhost !== false)
	{
		$this->memhost=$memhost; // shorthand it when sober
	}
    	if ($memport !== false)
	{
		$this->memport=$memport; // shorthand it when sober
	}


	$this->make_this_foo_work(); 
    }
    function make_this_foo_work()
    {
	$memcache = new Memcache; //
	$memcache->connect($this->memhost, $this->memport); // ever considered flexible configuration?
	if(!is_object($memcache))
	{
	    die('insane in the membrane');
	}
	$this->ram = $memcache;
    }
    function save($key,$val) 
    {
	if(!is_object($this->ram)) 
        {
	    $this->make_this_foo_work(); 
	}
	if($key != 'count')
	{
	    $this->ram->set($key,$val, MEMCACHE_COMPRESSED, $this->entry_timeout); 
	}
	else
	{
	    $this->ram->set($key,$val);
	}
    }
    function load($key)
    {
	if(!is_object($this->ram)) 
        {
	    $this->make_this_foo_work(); 
	    return 0;
	}
	return $this->ram->get($key);
    }
    function increment($dest)
    {
	$o = $this->load($dest); 
	if(empty($o))
	{
	    $o=0;
	}
	$this->save($dest,$o+1); 
	return $o+1;
    }
    
}
?>
