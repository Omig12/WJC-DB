/* Drop database if it already exists */
Drop Database if exists WJC;

/* Create it from scratch */
create Database WJC;
use WJC;

/* Clear tables */
drop Table if exists Animal;
drop Table if exists Hazard;
drop Table if exists Reserves;
drop Table if exists Population;
drop Table if exists Transfer;

/* Schema Definitions with referential integrity */
create Table Animal (speciesID int, speciesName  varchar(30) not null, class text not null, primary key (speciesID), unique(speciesID, speciesName));

create Table Hazard (speciesID int references Animal(speciesID) on update cascade, preyID int, primary key (speciesID, preyID));

create Table Reserves (reserveID int, reserveName varchar(30), city text, primary key (reserveID, reserveName));

create Table Population (speciesID int references Animal(speciesID) on update cascade, reserveID int references Reserves(reserveID) on update cascade, Population int, primary key (speciesID, reserveID));

create Table Transfer (reserveID int references Population(reserveID) on update cascade, speciesID int references Population(speciesID) on update cascade, Amount int references Population(population), destinationID int references Reserves(reserveID), transfer_Date timestamp, primary key (reserveID, destinationID, Amount, speciesID, transfer_date));


/* Data source: http://www.fws.gov/caribbean/es/endangered-animals.html */
/* Data source: http://www.puertorico.com/reserves/ */
/* Data source: */


/* Animal (SpeciesID, SpeciesName, Class) */

insert into Animal values (1, 'Eleutherodactylus juanariveroi', 'Amphibians');
insert into Animal values (2, 'Eleutherodactylus coqui', 'Amphibians');
insert into Animal values (3, 'Anolis roosevelti', 'Reptiles');
insert into Animal values (4, 'Epicrates inornatus', 'Reptiles');
insert into Animal values (5, 'Eretmochelys imbricata', 'Reptiles');
insert into Animal values (6, 'Sphaerodactylus micropithecus', 'Reptiles');
insert into Animal values (7, 'Accipiter striatus venator', 'Birds');
insert into Animal values (8, 'Amazona vittata', 'Birds');
insert into Animal values (9, 'Buteo platypterus brunnescens', 'Birds');
insert into Animal values (10, 'Caprimulgus noctitherus', 'Birds');
insert into Animal values (11, 'Columba inornata wetmorei', 'Birds');
insert into Animal values (12, 'Trichechus manatus', 'Mammals');

/* Reserves (reserveID, reserveName) */

insert into Reserves values (01, 'El Yunque', 'Rio Grande');
insert into Reserves values (02, 'Aguirre Forest Reserve', 'Salinas');
insert into Reserves values (03, 'Tortuguero Lagoon Reserve', 'Vega Baja');
insert into Reserves values (04, 'Toro Negro Forestry Reserve',  'Jayuya');
insert into Reserves values (05, 'Rio Abajo Forest Reserve', 'Utuado');
insert into Reserves values (06, 'Punta Guaniquilla Reserve', 'Cabo Rojo');
insert into Reserves values (07, 'Punta Ballena Reserve', 'Guanica');
insert into Reserves values (08, 'Maricao Forest Reserve', 'Maricao');
insert into Reserves values (09, 'Boqueron Forest Bird Refuge', 'Cabo Rojo');
insert into Reserves values (010, 'Humacao Natural Reserve', 'Humacao');
insert into Reserves values (011, 'Cambalache Forest Reserve', 'Arecibo');

/* Population (SpeciesID, reserveID, population) */

insert into Population values (1, 01, 100);
insert into Population values (1, 02, 100);
insert into Population values (2, 01, 100);
insert into Population values (2, 03, 100);
insert into Population values (3, 04, 100);
insert into Population values (3, 01, 100);
insert into Population values (4, 01, 100);

/* Hazard (speciesID, preyID) */

insert into Hazard values (1, 1);
insert into Hazard values (1, 2);		
insert into Hazard values (1, 3);
insert into Hazard values (2, 1);
insert into Hazard values (2, 2);
insert into Hazard values (2, 3);
insert into Hazard values (3, 1);
insert into Hazard values (3, 3);
insert into Hazard values (5, 1);
insert into Hazard values (5, 2);

/* Transfer(ReserveID, speciesID, Amount, DestinationID, transfer_Date) */

insert into Transfer values (02, 1, 3, 04, NULL);
insert into Transfer values (01, 3, 20, 02, NUll);
insert into Transfer values (01, 3, 5, 01, NUll);

/* Triggers */
delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Transfers_BINS` BEFORE INSERT ON `Transfer` 
FOR EACH ROW
BEGIN	
	IF NEW.transfer_Date = NULL 
	THEN
  		set NEW.transfer_Date := NOW();
  	END IF;
END;//
delimiter ;

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Transfers_AINS` AFTER INSERT ON `Transfer` 
FOR EACH ROW
BEGIN	
	IF NEW.Amount > 0 
	THEN
  		UPDATE Population
  			SET population = (population - NEW.Amount)
  			WHERE Population.reserveID = New.reserveID and speciesID = New.speciesID;
  		UPDATE Population
  			SET population = (population + NEW.Amount)
  			WHERE Population.reserveID = New.destinationID and speciesID = New.speciesID;
  	END IF;
END;//
delimiter ;

/* Sample queries */

select * from (((Animal natural join Population) natural join Reserves) natural join Hazard) natural join Animal as A;

select Animal.speciesName as Predator, Prey.speciesName as Prey from (Hazard natural join Animal), Animal as Prey where preyID = Prey.speciesID; 

Select reserveName from Reserves where reserveID in (Select reserveID From Population where speciesID in (SELECT speciesID FROM Animal where speciesName = 'Eleutherodactylus coqui') and population < 250);