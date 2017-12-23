<?php
session_start();

define('DS',  TRUE); // used to protect includes
define('USERNAME', $_SESSION['username']);
define('SELF',  $_SERVER['PHP_SELF'] );

if (!USERNAME or isset($_GET['logout']))
 include('login.php');

// everything below will show after correct login
?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PROGRAMARE ORAR</title>
<script language="javascript" src="serverDate.js"></script>
<?php
//conectare mysql:
$servername = "localhost";
$username = "orar";
$password = "orar";
$dbname = "mp3player";
$con = mysqli_connect($servername, $username, $password, $dbname);
// Verifica conexiune:
if (!$con) {
    die("Eroare MySQL: " . mysqli_connect_error());
}
//echo "Conectare cu succes la MySQL <br />";

//Creaza tabela daca nu exista:
$sql="CREATE TABLE IF NOT EXISTS orar (Id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, f11 INT NOT NULL , f10 INT NOT NULL , f21 INT NOT NULL , f20 INT NOT NULL , f31 INT NOT NULL , f30 INT NOT NULL , random INT NOT NULL)";
mysqli_query($con,$sql);
$sql = "SELECT * FROM orar";
$result = mysqli_query($con,$sql);
if (mysqli_num_rows($result) == 0) {
	$sql = "INSERT INTO orar(f11,f10,f21,f20,f31,f30) VALUES (0,24,24,24,24,24)";
	mysqli_query($con,$sql);
	$f11 = 0;
	$f10 = 24;
	$f21 = 24;
	$f20 = 24;
	$f31 = 24;
	$f30 = 24;
	$random = 1;
} else {
		//Citeste valorile trimise anterior si scrie-le in baza de date
		if (($_GET['f11'] >= 0) && ($_GET['f11'] <= 24)) {
			$sql="UPDATE orar SET f11=".$_GET['f11'];
			mysqli_query($con,$sql);
		}
		if (($_GET['f10'] >= 0) && ($_GET['f10'] <= 24)) {
			$sql="UPDATE orar SET f10=".$_GET['f10'];
			mysqli_query($con,$sql);
		}
		if (($_GET['f21'] >= 0) && ($_GET['f21'] <= 24)) {
			$sql="UPDATE orar SET f21=".$_GET['f21'];
			mysqli_query($con,$sql);
		}
		if (($_GET['f20'] >= 0) && ($_GET['f20'] <= 24)) {
			$sql="UPDATE orar SET f20=".$_GET['f20'];
			mysqli_query($con,$sql);
		}
		if (($_GET['f31'] >= 0) && ($_GET['f31'] <= 24)) {
			$sql="UPDATE orar SET f31=".$_GET['f31'];
			mysqli_query($con,$sql);
		}
		if (($_GET['f30'] >= 0) && ($_GET['f30'] <= 24)) {
			$sql="UPDATE orar SET f30=".$_GET['f30'];
			mysqli_query($con,$sql);
		}
		if ($_GET['submitted'] == '1') {
			if ($_GET['random'] == '1') {
				$sql="UPDATE orar SET random='1'";
				mysqli_query($con,$sql);
			} else {
				$sql="UPDATE orar SET random='0'";
				mysqli_query($con,$sql);
			}
		}
		//Scrie valorile din baza de date in variabile locale
		$sql = "SELECT * FROM orar";
		$result = mysqli_query($con,$sql);
        while($row = mysqli_fetch_assoc($result)) {
			$f11 = $row['f11'];
			$f10 = $row['f10'];
			$f21 = $row['f21'];
			$f20 = $row['f20'];
			$f31 = $row['f31'];
			$f30 = $row['f30'];
			$random = $row['random'];
		}
}
//Generare fisier config.txt
$handle = fopen("config.txt", 'w') or die("Can't create file config.txt");
fwrite($handle, "f11=".$f11."\nf10=".$f10."\nf21=".$f21."\nf20=".$f20."\nf31=".$f31."\nf30=".$f30."\nrandom=".$random);
//Generare fisier reboot.sh
if ($_GET['restart'] == 9) {
	$handle = fopen("reboot.sh", 'w') or die("Can't create file reboot.sh");
	fwrite($handle, "rm -rf /var/www/html/reboot.sh\nsudo reboot");
	$restart = 1;
	?>
	<script>
	setTimeout(function(){
		history.go(-1);
	}, 950);
	</script>
	<?php
} else {
	$restart = 9;
}
?>
<body>
<center>
Schedule:
<br />
<form action="index.php" method="get">
Folder 1:
<br />
From:
<input type="text" name="f11" size="5" value="<?php echo $f11; ?>">
To:
<input type="text" name="f10" size="5" value="<?php echo $f10; ?>">
<br />
<br />
Folder 2:
<br />
From:
<input type="text" name="f21" size="5" value="<?php echo $f21; ?>">
To:
<input type="text" name="f20" size="5" value="<?php echo $f20; ?>">
<br />
<br />
Folder 3:
<br />
From:
<input type="text" name="f31" size="5" value="<?php echo $f31; ?>">
To:
<input type="text" name="f30" size="5" value="<?php echo $f30; ?>">
<br />
<br />
Random:
<input type="checkbox" name="random" value="1" <?php if ( $random == '1' ) {echo "checked";} ?>>
<br />
<input type="hidden" name="submitted" value="1">
<br />
<script language="javascript">
  var localTime = new Date();
  document.write("Clock on this device: " + localTime + "<br>");
  document.write("Clock on server: " + date);
</script>
<br />
<br />
<input type="submit" value="Apply Settings">
</form>
<br />
<br />
<form action="index.php" method="get">
<input type="hidden" name="restart" size="5" value="<?php echo $restart; ?>">
<input type="submit" value="Restart System">
</form>
<br />
<br />
The from and to fields must have values between 0 and 24, to not run a file at all the from field must be 24.
</center>
</body>
</html>