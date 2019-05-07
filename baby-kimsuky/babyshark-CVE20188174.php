if(file_exists($filename))

{

     if($ff=fopen(“resp”,”a”))

     {

          fwrite($ff, $date . ”  ” . $ip .  ”    “.$useragent.”     reopen document.” .”\r\n”);

          fclose($ff);

     }

     header(“location: http://google[.]com”);

     exit;

}

if($ff=fopen(“resp”,”a”))

{

     fwrite($ff, $date . ”  ” . $ip .  ”    “.$useragent.”            open document.” .”\r\n”);

     fclose($ff);

}
