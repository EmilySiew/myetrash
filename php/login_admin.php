<?php
//error_reporting(0);
include_once("dbconnector.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);
$sql = "SELECT * FROM Register WHERE EMAIL = '$email' AND PASSWORD = '$passwordsha' AND VERIFY='1'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    echo "success";
}else{
    echo "failed";
}