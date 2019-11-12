<?php

    include_once('dbconnector.php');

    $email = $_POST['email'];
    $verify = '1';
    $sql = "SELECT * FROM Register WHERE EMAIL = '$email' AND VERIFY = '$verify'";
    $result = $conn->query($sql);
        if($result -> num_rows > 0) {
            sendEmail($email);
            echo "Success";
        } else {
            echo "Failed";
        }


function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Reset Password for myETrash'; 
    $message = 'http://itschizo.com/emily_siew/myETrash/php/changepw.php?email='.$useremail; 
    $headers = 'From: noreply@myETrash.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>