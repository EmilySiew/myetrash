<?php
//error_reporting(0);
include_once ("dbconnector.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$sqlinsert = "INSERT INTO Register(NAME,EMAIL,PASSWORD,PHONE,VERIFY) VALUES ('$name','$email','$password','$phone','0')";
        if ($conn->query($sqlinsert) === TRUE) {
            $path = '../profile/'.$email.'.jpg';
            file_put_contents($path, $decoded_string);
            sendEmail($email);
            echo "success";
    } else {
        echo "failed";
}
function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for myETrash'; 
    $message = 'http://itschizo.com/emily_siew/myETrash/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@myETrash.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>