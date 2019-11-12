<?php
$servername = "localhost";
$username 	= "itschizo_emilysiew";
$password 	= "emilysiew98";
$dbname 	= "itschizo_myETrash";
$conn = new mysqli($servername, $username, $password, $dbname);
if (!$conn) {
   echo "fail";
}else
//echo "Connection Successful!";
?>