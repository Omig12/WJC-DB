/* Drop database if it already exists */
Drop Database if exists WJC;

/* Create it FROM scratch */
create Database WJC;
use WJC;

/* Clear tables */
drop Table if exists Animal;
drop Table if exists Hazard;
drop Table if exists Reserve;
drop Table if exists Population;
drop Table if exists Transfer;

/* Schema Definitions with referential integrity */
create Table Animal (speciesID int AUTO_INCREMENT, speciesName  varchar(30) not NULL, commonName varchar(30) not NULL, class text not NULL, primary key (speciesID), unique(speciesID, speciesName), CHECK (speciesID > 0));

create Table Hazard (speciesID int, foreign key (speciesID) references Animal(speciesID) on update cascade, preyID int, primary key (speciesID, preyID), CHECK (preyID > 0));

create Table Reserve (reserveID int, reserveName varchar(30), city text, primary key (reserveID, reserveName), CHECK (reserveID > 0));

create Table Population (speciesID int, foreign key (speciesID) references Animal(speciesID) on update cascade, reserveID int, foreign key (reserveID) references Reserve(reserveID) on update cascade, quantity int not NULL, primary key (speciesID, reserveID), CHECK (quantity > 0));

create Table Transfer (reserveID int, foreign key (reserveID) references Reserve(reserveID) on update cascade, speciesID int, foreign key (speciesID) references Animal(speciesID) on update cascade, amount int, destinationID int, foreign key (destinationID) references Reserve(reserveID), transfer_Date timestamp, primary key (reserveID, destinationID, amount, speciesID, transfer_date), CHECK (amount > 0));


/* Data source: http://www.fws.gov/caribbean/es/endangered-animals.html */
/* Data source: http://www.puertorico.com/reserves/ */
/* Data source: */


/* Animal (speciesID, speciesName, Class) */

INSERT INTO Animal VALUES (1, 'Eleutherodactylus juanariveroi', 'Coqui' , 'Amphibians');
INSERT INTO Animal VALUES (2, 'Eleutherodactylus coqui', 'Coqui' , 'Amphibians');
INSERT INTO Animal VALUES (3, 'Anolis roosevelti', 'Iguana', 'Reptiles');
INSERT INTO Animal VALUES (4, 'Epicrates inornatus', 'Puerto Rican boa' , 'Reptiles');
INSERT INTO Animal VALUES (5, 'Eretmochelys imbricata', 'Turtle' , 'Reptiles');
INSERT INTO Animal VALUES (6, 'Sphaerodactylus micropithecus', 'Monito gecko','Reptiles');
INSERT INTO Animal VALUES (7, 'Accipiter striatus venator', 'falcón de sierra/gavilán',  'Birds');
INSERT INTO Animal VALUES (8, 'Amazona vittata', 'Puerto Rican parrot/iguaca' , 'Birds');
INSERT INTO Animal VALUES (9, 'Buteo platypterus brunnescens', 'guaraguao', 'Birds');
INSERT INTO Animal VALUES (10, 'Caprimulgus noctitherus', 'Puerto Rican nightjar ', 'Birds');
INSERT INTO Animal VALUES (11, 'Columba inornata wetmorei', 'plain pigeon' , 'Birds');
INSERT INTO Animal VALUES (12, 'Trichechus manatus', 'Manati' , 'Mammals');

/* Reserve (reserveID, reserveName) */

INSERT INTO Reserve VALUES (01, 'El Yunque', 'Rio Grande');
INSERT INTO Reserve VALUES (02, 'Aguirre Forest Reserve', 'Salinas');
INSERT INTO Reserve VALUES (03, 'Tortuguero Lagoon Reserve', 'Vega Baja');
INSERT INTO Reserve VALUES (04, 'Toro Negro Forestry Reserve',  'Jayuya');
INSERT INTO Reserve VALUES (05, 'Rio Abajo Forest Reserve', 'Utuado');
INSERT INTO Reserve VALUES (06, 'Punta Guaniquilla Reserve', 'Cabo Rojo');
INSERT INTO Reserve VALUES (07, 'Punta Ballena Reserve', 'Guanica');
INSERT INTO Reserve VALUES (08, 'Maricao Forest Reserve', 'Maricao');
INSERT INTO Reserve VALUES (09, 'Boqueron Forest Bird Refuge', 'Cabo Rojo');
INSERT INTO Reserve VALUES (010, 'Humacao Natural Reserve', 'Humacao');
INSERT INTO Reserve VALUES (011, 'Cambalache Forest Reserve', 'Arecibo');

/* Population (SpeciesID, reserveID, quantity) */

INSERT INTO Population VALUES (10, 08, 97);
INSERT INTO Population VALUES (12, 02, 10);
INSERT INTO Population VALUES (9, 09, 61);
INSERT INTO Population VALUES (8, 08, 76);
INSERT INTO Population VALUES (1, 07, 36);
INSERT INTO Population VALUES (8, 05, 37);
INSERT INTO Population VALUES (5, 05, 03);
INSERT INTO Population VALUES (6, 05, 19);
INSERT INTO Population VALUES (12, 08, 42);
INSERT INTO Population VALUES (9, 11, 55);
INSERT INTO Population VALUES (1, 01, 57);
INSERT INTO Population VALUES (9, 01, 61);
INSERT INTO Population VALUES (3, 07, 12);
INSERT INTO Population VALUES (4, 08, 76);
INSERT INTO Population VALUES (9, 05, 18);
INSERT INTO Population VALUES (4, 01, 24);
INSERT INTO Population VALUES (2, 11, 61);
INSERT INTO Population VALUES (3, 10, 87);
INSERT INTO Population VALUES (10, 03, 47);
INSERT INTO Population VALUES (4, 06, 1);
INSERT INTO Population VALUES (6, 04, 56);

/* Hazard (speciesID, preyID) */

INSERT INTO Hazard VALUES (8, 2);
INSERT INTO Hazard VALUES (2, 8);		
INSERT INTO Hazard VALUES (9, 2);
INSERT INTO Hazard VALUES (12, 3);
INSERT INTO Hazard VALUES (10, 8);
INSERT INTO Hazard VALUES (3, 9);
INSERT INTO Hazard VALUES (7, 9);
INSERT INTO Hazard VALUES (6, 12);
INSERT INTO Hazard VALUES (5, 6);
INSERT INTO Hazard VALUES (5, 2);
INSERT INTO Hazard VALUES (12, 5);
INSERT INTO Hazard VALUES (6, 1);   
INSERT INTO Hazard VALUES (11, 11);
INSERT INTO Hazard VALUES (2, 2);
INSERT INTO Hazard VALUES (9, 10);
INSERT INTO Hazard VALUES (8, 5);
INSERT INTO Hazard VALUES (11, 6);
INSERT INTO Hazard VALUES (11, 10);
INSERT INTO Hazard VALUES (8, 6);
INSERT INTO Hazard VALUES (8, 3);

/* Transfer(reserveID, speciesID, amount, destinationID, transfer_Date) */

INSERT INTO Transfer VALUES (02, 1, 3, 04, '2015-11-12');
INSERT INTO Transfer VALUES (01, 3, 20, 02, '2016-03-02');
INSERT INTO Transfer VALUES (08, 4, 23, 06, NULL);
INSERT INTO Transfer VALUES (08,12, 15, 02, '2014-12-12');
INSERT INTO Transfer VALUES (01, 4, 10, 06, NULL);

/* Triggers */
delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Animals_BINS` BEFORE INSERT ON `Animal` 
FOR EACH ROW
BEGIN 
  IF (NEW.speciesID > (SELECT Max(speciesID) + 1 FROM Animal) OR NEW.speciesID < 0)   
  THEN
      SET NEW.speciesID := (SELECT Max(speciesID) + 1 FROM Animal);
    END IF;
END;//
delimiter ;

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Hazard_BINS` BEFORE INSERT ON `Hazard` 
FOR EACH ROW
BEGIN 
  IF (New.speciesID not in (SELECT speciesID FROM Animal) OR New.preyID not in (SELECT speciesID FROM Animal))  
  THEN
      SET NEW.speciesID = NULL;
      SET NEW.PreyID = NULL;
    END IF;
END;//
delimiter ;

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Reserve_BINS` BEFORE INSERT ON `Reserve` 
FOR EACH ROW
BEGIN 
  IF (NEW.reserveID > (SELECT Max(reserveID) + 1 FROM Reserve) OR NEW.reserveID < 0)  
  THEN
      SET NEW.reserveID := (SELECT Max(reserveID) + 1 FROM Reserve);
    END IF;
END;//
delimiter ;

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Population_BINS` BEFORE INSERT ON `Population` 
FOR EACH ROW
BEGIN 
  IF (NEW.quantity <= 0)  
  THEN
      SET NEW.quantity = NULL;
    END IF;
END;//
delimiter ;

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
	IF NEW.amount > 0 
	THEN
  		UPDATE Population
  			SET quantity = (quantity - NEW.amount)
  			WHERE Population.reserveID = New.reserveID and speciesID = New.speciesID;
  		UPDATE Population
  			SET quantity = (quantity + NEW.amount)
  			WHERE Population.reserveID = New.destinationID and speciesID = New.speciesID;
  	END IF;
END;//
delimiter ;

/* Sample queries */

SELECT Animal.speciesName as Predator, Prey.speciesName as Prey FROM (Hazard natural join Animal), Animal as Prey WHERE preyID = Prey.speciesID order by Prey; 

SELECT reserveName, quantity FROM Reserve, Population WHERE (Reserve.reserveID, Population.speciesID) in (SELECT P.reserveID, P.speciesID FROM Population P WHERE P.speciesID in (SELECT A.speciesID FROM Animal A WHERE speciesName = 'Eleutherodactylus coqui') and P.quantity < 250);

SELECT speciesName as Extra_Hazards FROM Animal WHERE speciesID in (SELECT speciesID FROM (Hazard natural join Population) WHERE reserveID in (SELECT reserveID FROM (Hazard join Population) WHERE preyID = Population.speciesID));

SELECT speciesName as Canibals FROM Animal WHERE speciesID in (SELECT distinct speciesID FROM Hazard WHERE speciesID = preyID order by speciesID);

SELECT speciesName as Name, sum(quantity) as Quantity FROM Population natural join Animal group by speciesID;

SELECT speciesName as Not_in_Reserve FROM Animal WHERE speciesID not in (SELECT speciesID FROM Population);

SELECT reserveID, reserveName, speciesID, speciesName, Quantity FROM (Reserve Natural Join Population) Natural Join Animal WHERE Quantity < 50;