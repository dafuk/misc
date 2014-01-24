<?php
$filename =  $_SERVER['argv'][1];
if(!file_exists($filename))
{
	die('no file =  no work');
}
else
{
	$data = file_get_contents($filename);
	$data = str_replace("\t",' ',$data); // screw tabs
	$data = str_replace("\n\n","\n",$data); // screw linebreaks
	$data = str_replace('*/',"*/\n",$data); // allow them comments, aii
	$data = str_replace('}',"}\n",$data); // add linebreaks after  }
	file_put_contents($filename.time(),$data); // ta-da!
}
?>

