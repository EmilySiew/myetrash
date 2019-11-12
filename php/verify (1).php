<?php
error_reporting(0);
include_once("dbconnector.php");
$email = $_GET['email'];

$sql = "UPDATE Register SET VERIFY = '1' WHERE EMAIL = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>