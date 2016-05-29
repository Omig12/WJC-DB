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
			<img src="https://farm9.staticflickr.com/8658/16225191300_fab6a93a4e_b.jpg" style="width: 100%; border-radius: .5em;" />
		</div>
		<div class="row no-gutter" style="background:#EEE; padding: 1em 1em 1em 1em;"><br><br>
			<!-- Catalog -->
			<div class="no-gutter" style="background:#EEE;">
				<h3 style="background:#EEE; border-bottom:1px solid #666;"> Search WJC </h3><br>
				<h4><em>Please select one radio or create a custom query and then submit.</em></h4>
				<form action="index.php" method="post">
					<input type="radio" name='Tables' value=""> Tables <em>(Shows the list of tables contained in WJC's Database)</em><br>
					<input type="radio" name='Full_DB' value=""> Full DB <em>(Shows a relation between all entities except for Transfer)</em><br>
					<input type="radio" name='Quantity' value=""> Quantity <em>(Shows Name and Quatity of each Animal in WJC's Database)</em><br>

					<input type="radio" name='Animal' value=""> Animal <em>(Shows the attributes contained in the Animal entity)</em><br>
					<input type="radio" name='Predators' value=""> Predators <em>(Shows the attributes contained in the Hazard entity)</em><br>
					<input type="radio" name='Reserve' value=""> Reserve <em>(Shows the attributes contained in the Reserve entity)</em><br>
					<input type="radio" name='Population' value=""> Population <em>(Shows the attributes contained in the Population entity)</em><br>
					<input type="radio" name='Transfer' value=""> Transfer <em>(Shows the attributes contained in the Transfer entity)</em><br>
					<input type="radio" name='List'> Optional Default Queries:
						<select name='Queries'>
								<option value='Default'> Select ... </option>
								<option value='Coqui'> Coqui </option>
								<option value='Canibal'> Canibals </option>
								<option value='Hazard'> Hazards </option>
								<option value='Coexists'> Dangerous Coexistance </option>
								<option value='IMG'> IMG </option>
								<option value='A_Like'> Animal Name Like </option>
								<option value='R_Like'> Reserve Name Like </option>
						</select><br><br>

					Custom Query: <input type="text" name="Custom" placeholder="SELECT (Attribute) FROM (Entity) WHERE (Condition);" style="width:50%;"><br><br>
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
						if($conn->connect_error) {
				     		die('<br>Could not connect: ' . mysqli_error().'<br>');
				   		}
				   		else {
				 			echo '<br>Connected successfully<br>';
				  		}

						// List option
				  		$List = $_POST['Queries'];

				  		// Show all tables
				  		if (isset($_POST['Tables'])) {
							$sql = "SHOW Tables;";
							$result = mysqli_query($conn, $sql);
						}
						// Show full Table of db
						else if (isset($_POST['Full_DB'])) {
							$sql = "SELECT * FROM (((Animal natural join Population) natural join Reserve) natural join Hazard) natural join Animal as A order by SpeciesID DESC, speciesName,class, preyID, reserveID, reserveName, quantity, city;";
							$result = mysqli_query($conn, $sql);
						}
						// Animal Amount
						else if (isset($_POST['Quantity'])) {
							$sql = "SELECT speciesName as Name, sum(quantity) as Quantity from Population natural join Animal group by speciesID;";
							$result = mysqli_query($conn, $sql);
						}
						// Show Animal Table
						else if (isset($_POST['Animal'])) {
							$sql = "SELECT * FROM Animal;";
							$result = mysqli_query($conn, $sql);
						}
						// Show Reserve Table
						else if (isset($_POST['Reserve'])) {
							$sql = "SELECT * FROM Reserve";
							$result = mysqli_query($conn, $sql);
						}
						// Show Hazard Table
						else if (isset($_POST['Predators'])) {
							$sql = "SELECT * FROM Hazard order BY speciesID";
							$result = mysqli_query($conn, $sql);
						}
						// Show Population Table
						else if (isset($_POST['Population'])) {
							$sql = "SELECT * FROM Population";
							$result = mysqli_query($conn, $sql);
						}
						// Show Transfer Table
						else if (isset($_POST['Transfer'])) {
							$sql = "SELECT * FROM Transfer";
							$result = mysqli_query($conn, $sql);
						}
						// Show Selction From list
						else if (isset($_POST['List'])and isset($_POST['Queries'])) {
							if ($_POST['Queries'] == 'Default') {
								echo "<script type='text/javascript'>
										alert('Please select a value from list.');
									</script>";
							}
							else if ($_POST['Queries'] == 'Coqui') {
								$sql = "Select * From Animal Where SpeciesName like '%coqui%';";
								$result = mysqli_query($conn, $sql);
							}
							else if ($_POST['Queries'] == 'Canibal') {
							$sql = "SELECT speciesName as Canibals FROM Animal WHERE speciesID in (SELECT distinct speciesID FROM Hazard WHERE speciesID = preyID order by speciesID);";
							$result = mysqli_query($conn, $sql);
							}
							else if ($_POST['Queries'] == 'Hazard') {
									$sql = "SELECT Animal.speciesName as Predator, Prey.speciesName as Prey FROM (Hazard natural join Animal), Animal as Prey WHERE preyID = Prey.speciesID order by Prey;";
									$result = mysqli_query($conn, $sql);
								}
							else if ($_POST['Queries'] == 'Coexists') {
									$sql = "SELECT speciesName as Extra_Hazards FROM Animal WHERE speciesID in (SELECT speciesID FROM (Hazard natural join Population) WHERE reserveID in (SELECT reserveID FROM (Hazard join Population) WHERE preyID = Population.speciesID));";
									$result = mysqli_query($conn, $sql);
								}
							else if ($_POST['Queries'] == 'IMG') {
								echo '<img src="https://upload.wikimedia.org/wikipedia/en/e/e4/Anolis_roosevelti.jpg">';
							}
							else if ($_POST['Queries'] == 'A_Like') {
								if ($_POST['Custom']){
								echo "<h4>Searched: ".$_POST['Custom']."</h4>";
								$sql = "SELECT * FROM Animal WHERE speciesID like '%".$_POST['Custom']."%' OR speciesName like '%".$_POST['Custom']."%' OR commonName Like '%".$_POST['Custom']."%' OR class Like '%".$_POST['Custom']."%';";
								$result = mysqli_query($conn, $sql);
								}
							}
							else if ($_POST['Queries'] == 'R_Like') {
								if ($_POST['Custom']){
									echo "<h4>Searched: ".$_POST['Custom']."</h4>";
									$sql = "SELECT * FROM Reserve WHERE ReserveName like '%".$_POST['Custom']."%' OR city like '%".$_POST['Custom']."%' OR reserveID like '%".$_POST['Custom']."%';";
									$result = mysqli_query($conn, $sql);
								}
								else if ($_POST['Custom'] == ''){
									echo "<h1>Please enter an animal name into Custom Query box.</h1>";
								}
							}
						}
						// Run custom Query
						else if (isset($_POST['Custom'])) {
							$sql = $_POST['Custom'];
							$result = mysqli_query($conn, $sql);
							echo "<h4>CUSTOM QUERY: ".$_POST['Custom']."</h4>";
							if (!mysqli_query($conn,$sql)) {
							  echo "SQL STATE error: ".mysqli_sqlstate($conn);
							  echo "<br>";
							  if (mysqli_error($conn)){
							  echo "Error description: ".mysqli_error($conn);
							  	}
							  }
						}

						// Fill table
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

						$result->free();
						$mysqli->close();
					?>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
