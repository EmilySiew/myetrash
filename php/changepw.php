<?php
    error_reporting(0);
    include('dbconnector.php');
    
    $password=$_POST['password'];
    $confirmPass = $_POST['confirmpass'];
    
    if($password==$confirmPass){
        $sql="UPDATE Register SET PASSWORD='$password'";
    } else {
        echo "Password does not match.";
    }
    
    if ($conn->query($sql) === true) {
       // echo "Password have been successfully updated.";
    } else {
        echo "Please try again!";
    }

    ?>
    
    
    <link rel="stylesheet" href="stylesheet.css">
<!DOCTYPE html>
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Reset Password Form</title>
</head>
<body>
    <table class="table">
        <!--<img src="" class="picture" alt="logo" height="40%" weight="20%">-->
        <tr>
	<form method="post" name="resetPass">
	    
		<tr><td align="center"><p>Please input your password</p></td></tr>
		
		<tr><td align="center"><input type="password" name="password" id="password" placeholder="Your New Password"/ ></br></td></tr>
		
		<tr><td align="center"><p>Please re-confirm your password</p></td></tr>
		
		<tr><td align="center"><input type="password" name="confirmpass" id="confirm_password" placeholder="Reconfirm Password"/></td></tr>

		<tr><td align="center" height="60px">
		    <input type="submit" value="submit" class="button"/></td></tr>
		    
		</form>
		</table>
</body>
</html>

