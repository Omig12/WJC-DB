<!DOCTYPE HTML>
<html lang="en">
<head>
	<title>WJC - Wildlife Journal for Conservation </title>
	<link rel="icon" href="http://static1.squarespace.com/static/5067061fc4aa71efcf50abc1/532e0065e4b0f59c297a79c4/532e0a87e4b0011333cb20ca/1395526281114/OK-Icon-Wildlife.png" sizes="16x16 32x32" > 
	<meta charset="utf-8">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
</head>
<body> 
	<div class="container-fluid">
		<!-- Body -->
		<div class="navbar" style="background: rgba(63, 121, 78, 0.68); border-bottom:1px solid #666;  box-shadow:.1em .3em .3em #666; "> 
			<h1 class="navbar" style="padding-left: 1em;"> Wildlife Journal for Conservation </h1>
			<p style="padding-left: 3em; color: #F5F5F8;"> Proyecto para CCOM 4027 <br> Creado por Israel O. Dilán y Juan Lugo</p>
		</div>
		<div  class="jumbotron">
			<img src="https://farm9.staticflickr.com/8658/16225191300_fab6a93a4e_b.jpg)" style="width: 100%; border-radius: .5em;" />
		</div>
		<div class="row no-gutter" style="background:#EEE; padding: 1em 1em 1em 1em;"><br><br>
			<!-- Catalog -->
			<div class="no-gutter" style="background:#EEE;">
				<h3 style="background:#EEE; border-bottom:1px solid #666;"> Search WJC </h3><br>
				<h4><em>Please select only one checkbox or create a custom query and then submit.</em></h4>
				<form action="index.php" method="post">
					<input type="checkbox" name='Tables' value=""> Tables <em>(Shows the list of tables contained in WJC's Database)</em><br>
					<input type="checkbox" name='Full_DB' value=""> Full DB <em>(Shows a relation between all entities except for Transfers)</em><br>

					<input type="checkbox" name='Animals' value=""> Animals <em>(Shows the attributes contained in the Animals entity)</em><br>
					<input type="checkbox" name='Predators' value=""> Predators <em>(Shows the attributes contained in the Eats entity)</em><br>
					<input type="checkbox" name='Reserves' value=""> Reserves <em>(Shows the attributes contained in the Reserves entity)</em><br>
					<input type="checkbox" name='Populations' value=""> Populations <em>(Shows the attributes contained in the Populations entity)</em><br>
					<input type="checkbox" name='Transfers' value=""> Transfers <em>(Shows the attributes contained in the Transfers entity)</em><br>
					
					Custom Query: <input typq="text" name="Custom" placeholder="SELECT * FROM WHERE ;" style="width:50%;"><br>
					
					<input type="submit" value="Query WJC">
				</form>
				<table class="table table-responsive">
					<?php
						// Connection Settings
						$db_host = 'localhost';
						$db_username = 'root';
						$db_pass = '';
						$db_name = 'WJC';
						// Open Connection
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
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show Animals Table
						else if (isset($_POST['Animals'])){
							$sql = "SELECT * FROM Animals;";
							$result = mysqli_query($conn, $sql);
							echo "<TR><TH>speciesID</TH><TH>speciesName</TH><TH>class</TH></TR>";	
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show Reserves Table
						else if (isset($_POST['Reserves'])){
							$sql = "SELECT * FROM Reserves";
							$result = mysqli_query($conn, $sql);
							echo "<TH>reserveID</TH><TH>reserveName</TH><TH>city</TH></TR>";
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show Eats Table
						else if (isset($_POST['Predators'])){
							$sql = "SELECT * FROM Eats order BY speciesID";
							$result = mysqli_query($conn, $sql);
							echo "<TR><TH>speciesID</TH><TH>preyID</TH></TR>";
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show Populations Table
						else if (isset($_POST['Populations'])){
							$sql = "SELECT * FROM Populations";
							$result = mysqli_query($conn, $sql);
							echo "<TR><TH>speciesID</TH><TH>reserveID</TH><TH>Population</TH></TR>";
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show Transfers Table
						else if (isset($_POST['Transfers'])){
							$sql = "SELECT * FROM Transfers";
							$result = mysqli_query($conn, $sql);
							echo "<TR><TH>reserveID</TH><TH>speciesID</TH><TH>Amount</TH><TH>destinationID</TH><TH>transfer_Date</TH></TR>";
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}
						}
						// Show full Table of db
						else if (isset($_POST['Full_DB'])){
							$sql = "SELECT * FROM (((Animals natural join Populations) natural join Reserves) natural join Eats) natural join Animals as A;";
							$result = mysqli_query($conn, $sql);
							echo "<TR><TH>speciesID</TH><TH>speciesName</TH><TH>class</TH><TH>reserveID</TH><TH>Population</TH><TH>reserveName</TH><TH>city</TH><TH>preyID</TH></TR>";
							while($record = mysqli_fetch_array($result)){
								echo "<tr>";
								for ($i=0; $i < mysqli_field_count($conn); $i++) { 
									echo "<td>".$record[$i]."</td>";
								};
								echo "</tr>";	
							}	 
						}
						// Run custom Query
						else if (isset($_POST['Custom'])){
							$sql = $_POST['Custom'];
							$result = mysqli_query($conn, $sql);
							echo "<h4> CUSTOM QUERY:	".$_POST['Custom']."</h4>";
							echo "<TR>";
							// Generate Headers
							$fieldinfo=mysqli_fetch_fields($result);
							  foreach ($fieldinfo as $val) {
							    echo "<th>".$val->name."</th>";
							   }
							echo "</TR>";
							// Populate table
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
