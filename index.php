<!DOCTYPE HTML>
<html lang="en">
<head>
	<title>WJC - Wildlife Journal for Conservation </title>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
</head>
<body> 
	<div class="container-fluid">
		
	<div class="navbar" style="background: rgba(63, 121, 78, 0.68); border-bottom:1px solid #666;  box-shadow:.1em .3em .3em #666; "> 
		<h1 class="navbar" style="padding-left: 1em;"> Wildlife Journal for Conservation </h1>
	</div>

		<!-- Body -->
		<div  class="jumbotron">
			<img src="https://farm9.staticflickr.com/8658/16225191300_fab6a93a4e_b.jpg)" style="width: 100%; border-radius: .5em;" />
		</div>
		<div class="row no-gutter" style="background:#EEE;"><br><br>
	
			<!-- Catalog -->
			<div class="col-md-6 no-gutter" style="background:#EEE;">
				<h3 style="background:#EEE; border-bottom:1px solid #666;">Search and Obtain Result</h3><br>
				<form action="index.php" method="post">
					<input type="checkbox" name='Tables' value=""> Tables </input><br>
					
					<input type="checkbox" name='Animals' value=""> Animals </input><br>
					<input type="checkbox" name='Predators' value=""> Predators  </input><br>
					<input type="checkbox" name='Reserves' value=""> Reserves </input><br>
					<input type="checkbox" name='Populations' value=""> Populations </input><br>
					<input type="checkbox" name='Transfers' value=""> Transfers </input><br>
					
					<input type="checkbox" name='Full_DB' value=""> Full DB </input><br>
					Custom Query: <input typq="text" name="Custom" placeholder="SELECT * FROM WHERE ;"> </input><br>
					
					<input type="submit" value="Query WJC"></input>
				</form>
				<table class="table table-responsive">
					<?php
							// Create connection
							$db_host = 'localhost';
							$db_username = 'root';
							$db_pass = '';
							$db_name = 'WJC';
							$conn = mysqli_connect($db_host,$db_username,$db_pass,$db_name);
							
							// Check connection
							if($conn->connect_error){
					     		die('<br>Could not connect: ' . mysqli_error().'<br>');
					   		} 
					   		else {
					 			echo '<br>Connected successfully<br>';
					  		}	

					  		// Show all tables
					  		if (isset($_POST['Tables'])){
								$sql = "SHOW Tables;";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>Tables_in_WJC</TH></TR>";	
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
									</tr>";	
								}
							}
							// Show Animals Table
							else if (isset($_POST['Animals'])){
								$sql = "SELECT * FROM Animals;";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>speciesID</TH><TH>speciesName</TH><TH>class</TH></TR>";	
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
										<td>" .$record[1]. "</td>
										<td>" .$record[2]."<td>
										</td>" .$record[3]."</td>
									</tr>";	
								}
							}
							// Show Reserves Table
							else if (isset($_POST['Reserves'])){
								$sql = "SELECT * FROM Reserves";
								$result = mysqli_query($conn, $sql);
								echo "<TH>reserveID</TH><TH>reserveName</TH><TH>city</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
										<td>" .$record[1]. "</td>
										<td>" .$record[2]."<td>
									</tr>";	
								}
							}
							// Show Eats Table
							else if (isset($_POST['Predators'])){
								$sql = "SELECT * FROM Eats order BY speciesID";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>speciesID</TH><TH>preyID</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
										<td>" .$record[1]. "</td>
									</tr>";	
								}
							}
							// Show Populations Table
							else if (isset($_POST['Populations'])){
								$sql = "SELECT * FROM Populations";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>speciesID</TH><TH>reserveID</TH><TH>Population</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
										<td>" .$record[1]. "</td>
										<td>" .$record[2]."<td>
									</tr>";	
								}
							}
							// Show Transfers Table
							else if (isset($_POST['Transfers'])){
								$sql = "SELECT * FROM Transfers";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>reserveID</TH><TH>speciesID</TH><TH>Amount</TH><TH>destinationID</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo 
									"<tr>
										<td>".$record[0]."</td>
										<td>" .$record[1]. "</td>
										<td>" .$record[2]."<td>
										<td>" .$record[3]. "</td>
									</tr>";	
								}
							}
							// Show full Table of db
							else if (isset($_POST['Full_DB'])){
								$sql = "SELECT * FROM (((Animals natural join Populations) natural join Reserves) natural join Eats) natural join Animals as A;";
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>speciesID</TH><TH>speciesName</TH><TH>class</TH><TH>reserveID</TH><TH>Population</TH><TH>reserveName</TH><TH>city</TH><TH>preyID</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo
									"<tr>
										<td>".$record[0]."</td>
										<td>".$record[1]."</td>
										<td>".$record[2]."</td>
										<td>".$record[3]."</td>
										<td>".$record[4]."</td>
										<td>".$record[5]."</td>
										<td>".$record[6]."</td>
										<td>".$record[7]."</td>
									</tr>";	
								}	 
							}
							// Run custom Query
							else if (isset($_POST['Custom'])){
								$sql = $_POST['Custom'];
								$result = mysqli_query($conn, $sql);
								echo "<TR><TH>CUSTOM QUERY</TH><TH>".$_POST['Custom']."</TH></TR>";
								while($record = mysqli_fetch_array($result)){
									echo "<tr>";
									for ($i=0; $i < mysqli_field_count($conn); $i++) { 
										echo "<td>".$record[$i]."</td>";
									};
									echo "</tr>";	
								}
							}

							$result->free();
							$mysqli->close();
					?>
				</table>
			</div>
		</div>
	</div>
</body>
</html>