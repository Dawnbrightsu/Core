<?php

require_once("config.php");

session_start();

if(!empty($_POST["security"])){

	if($_SESSION["security"]  != $_POST["security"]) { $errors[] = "Invalid input. Please try again."; }

}

$security = rand(10000, 100000);
$_SESSION["security"] = $security;

if(!empty($_POST["accountname"]) && !empty($_POST["password"]) && !empty($_POST["password2"]) && !empty($_POST["email"]) && $_POST["expansion"] != "" && !empty($_POST["security"])){

	$mysql_connect = mysqli_connect($mysql["host"], $mysql["username"], $mysql["password"]) or die("Unable to connect to the database.");
	mysqli_select_db($mysql_connect, $mysql["realmd"]) or die("Unable to select logon database.");
	
	$post_accountname = mysqli_real_escape_string($mysql_connect, trim(strtoupper($_POST["accountname"])));
	$post_password = mysqli_real_escape_string($mysql_connect, trim(strtoupper($_POST["password"])));
	$post_password_final = mysqli_real_escape_string($mysql_connect, SHA1("".$post_accountname.":".$post_password.""));
	$post_password2 = trim(strtoupper($_POST["password2"]));
	$post_email = mysqli_real_escape_string($mysql_connect, trim($_POST["email"]));
	$post_expansion = mysqli_real_escape_string($mysql_connect, trim($_POST["expansion"]));
	
	$check_account_query = mysqli_query($mysql_connect, "SELECT COUNT(*) FROM account WHERE username = '".$post_accountname."'");
	$check_account_results = mysqli_fetch_array($check_account_query);
	if($check_account_results[0]!=0){ $errors[] = "The requested account name is already in use. Please try again."; }
	
	if(strlen($post_accountname) < 3) { $errors[] = "The requested account name is to short. Please try again."; }
	if(strlen($post_accountname) > 32) { $errors[] = "The requested account name is to long. Please try again."; }
	if(strlen($post_password) < 6) { $errors[] = "The requested password is to short. Please try again."; }
	if(strlen($post_password) > 32) { $errors[] = "The requested password is to long. Please try again."; }
	if(strlen($post_email) > 64) { $errors[] = "The requested e-mail address is to long. Please try again."; }
	if(strlen($post_email) < 8) { $errors[] = "The requested e-mail address is to short. Please try again."; }
	if(!ereg("^[0-9a-zA-Z%]+$", $post_accountname)) { $errors[] = "Your account name can only contain letters or numbers. Please try again."; }
	if(!ereg("^[0-9a-zA-Z%]+$", $post_password)) { $errors[] = "Your password can only contain letters or numbers. Please try again."; }
	if(!ereg("^[0-2%]+$", $post_expansion)) { $errors[] = "Invalid input. Please try again."; }
	if(strlen($post_expansion) > 1) { $errors[] = "Invalid input. Please try again."; }
	if($post_accountname == $post_password) { $errors[] = "The passwords do not match. Please try again."; }
	if($post_password != $post_password2) { $errors[] = "The passwords do not match. Please try again."; }
	
	if(!is_array($errors)){
	
		mysqli_query($mysql_connect, "INSERT INTO account (username, sha_pass_hash, email, last_ip, expansion) VALUES ('".$post_accountname."', '".$post_password_final."', '".$post_email."', '".$_SERVER["REMOTE_ADDR"]."', '".$post_expansion."')") or die(mysqli_error($mysql_connect));
		
	$errors[] = 'You have successfully created the account: <font color="yellow">'.$post_accountname.'</font>.';  
	
	}
	
	mysqli_close($mysql_connect);

}

function error_msg(){

	global $errors;
	
	if(is_array($errors)){
	
		foreach($errors as $msg){
		
			echo '<div class="errors">'.$msg.'</div>';
		
		}
	
	}

}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-2" />
<link rel="stylesheet" type="text/css" href="site.css" />
<meta name="description" content="<?php $site["meta_description"] ?>" />
<meta name="keywords" content="<?php echo $site["meta_keywords"]; ?>" />
<meta name="robots" content="<?php echo $site["meta_robots"] ?>" />
<meta name="author" content="Jordy Thery" />
<link rel="shortcut icon" href="img/favicon.png" type="image/png" />
<title><?php echo $site["title"]; ?></title>
</head>
<body>

 <script type="text/javascript">
 function checkform ( form )
 {
 
	 if (form.accountname.value == "") { alert( "You did not fill in your account name. Please try again." ); form.accountname.focus(); return false; } else { if (form.accountname.value.length < 3) { alert( "Az account neved túl rövid!" ); form.accountname.focus(); return false; } }
	 if (form.password.value == "") { alert( "You did not fill in a password. Please try again." ); form.password.focus(); return false; } else { if (form.password.value.length < 6) { alert( "A jelszavad túl rövid!" ); form.password.focus(); return false; } }
	 if (form.password2.value == "") { alert( "You did not fill in a password. Please try again." ); form.password2.focus(); return false; }
	 if (form.password.value == form.accountname.value) { alert( "The passwords do not patch. Please try again." ); form.password.focus(); return false; }
	 if (form.password.value != form.password2.value) { alert( "The passwords do not match. Please try again." ); form.password.focus(); return false; }
	 if (form.email.value == "") { alert( "You did not fill in your e-mail address. Please try again." ); form.email.focus(); return false; } else { if (form.email.value.length < 8) { alert( "Az email címed túl rövid!" ); form.email.focus(); return false; } }
	 if (form.security.value == "") { alert( "You did not fill in the security question. Please try again." ); form.security.focus(); return false; }
 
 return true ;
 }
 </script>

<table class="reg">
	<tr>
		<td>
			<a href="<?php echo $_SERVER["PHP_SELF"]; ?>"><img src="img/logo.png" alt="<?php echo $site["title"]; ?>" /></a>
		</td>
	</tr>
	<tr>
		<td>
		</td>
	</tr>
	<tr>
		<td>
		
		<?php error_msg(); ?>
			
			<form action="<?php echo $_SERVER["PHP_SELF"]; ?>" method="POST" onsubmit="return checkform(reg);" name="reg">
			
			<table class="form">
				<tr>
					<td align="right">
						Account name:
					</td>
					<td align="left">
						<input name="accountname" type="text" maxlength="32" />
					</td>
				</tr>
				<tr>
					<td align="right">
						Password:
					</td>
					<td align="left">
						<input name="password" type="password" maxlength="32" />
					</td>
				</tr>
				<tr>
					<td align="right">
						Confirm password:
					</td>
					<td align="left">
						<input name="password2" type="password" maxlength="32" />
					</td>
				</tr>
				<tr>
					<td align="right">
						E-mail address:
					</td>
					<td align="left">
						<input name="email" type="text" maxlength="32" />
					</td>
				</tr>
				<tr>
					<td align="right">
						Expantion:
					</td>
					<td align="left">
						<select name="expansion">
							<option SELECTED value="2">Wrath Of The Lich King</option>
						</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						Capacha: <font style="color:#00b0f2;"><?php echo $security; ?></font>
					</td>
					<td align="left">
						<input name="security" type="text" maxlength="5" />
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="submit" class="sbm" value="Register" />
					</td>
				</tr>
			</table>
			
			</form>
			
			<div class="copy"><b><?php echo $site["realmlist"]; ?></b><br /></div>

		</td>
	</tr>
</table>

</body>
</html>