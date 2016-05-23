/* Drop database if it already exists */
Drop Database if exists WJC;

/* Create it from scratch */
create Database WJC;
use WJC;

/* Clear tables */
drop Table if exists Animal;
drop Table if exists Hazard;
drop Table if exists Reserve;
drop Table if exists Population;
drop Table if exists Transfer;

/* Schema Definitions with referential integrity */
create Table Animal (speciesID int, speciesName  varchar(30) not null, class text not null, primary key (speciesID), unique(speciesID, speciesName), CHECK (speciesID > 0));

create Table Hazard (speciesID int references Animal(speciesID) on update cascade, preyID int, primary key (speciesID, preyID), CHECK (preyID > 0));

create Table Reserve (reserveID int, reserveName varchar(30), city text, primary key (reserveID, reserveName), CHECK (reserveID > 0));

create Table Population (speciesID int references Animal(speciesID) on update cascade, reserveID int references Reserve(reserveID) on update cascade, quantity int not null, primary key (speciesID, reserveID), CHECK (quantity > 0));

create Table Transfer (reserveID int references Population(reserveID) on update cascade, speciesID int references Population(speciesID) on update cascade, amount int references Population(quantity), destinationID int references Reserve(reserveID), transfer_Date timestamp, primary key (reserveID, destinationID, amount, speciesID, transfer_date), CHECK (amount > 0));


/* Data source: http://www.fws.gov/caribbean/es/endangered-animals.html */
/* Data source: http://www.puertorico.com/reserves/ */
/* Data source: */


/* Animal (speciesID, speciesName, Class) */

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

/* Reserve (reserveID, reserveName) */

insert into Reserve values (01, 'El Yunque', 'Rio Grande');
insert into Reserve values (02, 'Aguirre Forest Reserve', 'Salinas');
insert into Reserve values (03, 'Tortuguero Lagoon Reserve', 'Vega Baja');
insert into Reserve values (04, 'Toro Negro Forestry Reserve',  'Jayuya');
insert into Reserve values (05, 'Rio Abajo Forest Reserve', 'Utuado');
insert into Reserve values (06, 'Punta Guaniquilla Reserve', 'Cabo Rojo');
insert into Reserve values (07, 'Punta Ballena Reserve', 'Guanica');
insert into Reserve values (08, 'Maricao Forest Reserve', 'Maricao');
insert into Reserve values (09, 'Boqueron Forest Bird Refuge', 'Cabo Rojo');
insert into Reserve values (010, 'Humacao Natural Reserve', 'Humacao');
insert into Reserve values (011, 'Cambalache Forest Reserve', 'Arecibo');

/* Population (SpeciesID, reserveID, quantity) */

insert into Population values (10, 08, 97);
insert into Population values (12, 02, 10);
insert into Population values (9, 09, 61);
insert into Population values (8, 08, 76);
insert into Population values (1, 07, 36);
insert into Population values (8, 05, 37);
insert into Population values (5, 05, 03);
insert into Population values (6, 05, 19);
insert into Population values (12, 08, 42);
insert into Population values (9, 11, 55);
insert into Population values (1, 01, 57);
insert into Population values (9, 12, 61);
insert into Population values (3, 07, 12);
insert into Population values (4, 08, 76);
insert into Population values (9, 05, 18);
insert into Population values (4, 01, 24);
insert into Population values (2, 11, 61);
insert into Population values (3, 10, 87);
insert into Population values (10, 3, 47);
insert into Population values (4, 6, 1);
insert into Population values (6, 4, 56);

/* Hazard (speciesID, preyID) */

insert into Hazard values (8, 2);
insert into Hazard values (2, 8);		
insert into Hazard values (9, 2);
insert into Hazard values (12, 3);
insert into Hazard values (10, 8);
insert into Hazard values (3, 9);
insert into Hazard values (7, 9);
insert into Hazard values (6, 12);
insert into Hazard values (5, 6);
insert into Hazard values (5, 2);
insert into Hazard values (12, 5);
insert into Hazard values (6, 1);   
insert into Hazard values (11, 11);
insert into Hazard values (2, 2);
insert into Hazard values (9, 10);
insert into Hazard values (8, 5);
insert into Hazard values (11, 6);
insert into Hazard values (11, 10);
insert into Hazard values (8, 6);
insert into Hazard values (8, 3);

/* Transfer(reserveID, speciesID, amount, destinationID, transfer_Date) */

insert into Transfer values (02, 1, 3, 04, '2015-11-12');
insert into Transfer values (01, 3, 20, 02, '2016-03-02');
insert into Transfer values (01, 3, 5, 01, NUll);

/* Triggers */
delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Animals_BINS` BEFORE INSERT ON `Animal` 
FOR EACH ROW
BEGIN 
  IF (NEW.speciesID > (select Max(speciesID) + 1 From Animal) OR NEW.speciesID < 0)   
  THEN
      SET NEW.speciesID := (select Max(speciesID) + 1 From Animal);
    END IF;
END;//
delimiter ;

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `Hazard_BINS` BEFORE INSERT ON `Hazard` 
FOR EACH ROW
BEGIN 
  IF (New.speciesID not in (SELECT speciesID From Animal) OR New.preyID not in (SELECT speciesID From Animal))  
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
  IF (NEW.reserveID > (select Max(reserveID) + 1 From Reserve) OR NEW.reserveID < 0)  
  THEN
      SET NEW.reserveID := (select Max(reserveID) + 1 From Reserve);
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

select Animal.speciesName as Predator, Prey.speciesName as Prey from (Hazard natural join Animal), Animal as Prey where preyID = Prey.speciesID order by Prey; 

Select reserveName, quantity from Reserve, Population where (Reserve.reserveID, Population.speciesID) in (Select P.reserveID, P.speciesID From Population P where P.speciesID in (SELECT A.speciesID FROM Animal A where speciesName = 'Eleutherodactylus coqui') and P.quantity < 250);

Select speciesName as Extra_Hazards From Animal where speciesID in (select speciesID from (Hazard natural join Population) where reserveID in (select reserveID from (Hazard join Population) where preyID = Population.speciesID));

Select speciesName as Canibals From Animal where speciesID in (Select distinct speciesID From Hazard where speciesID = preyID order by speciesID);

Select speciesName as Name, sum(quantity) as Quantity from Population natural join Animal group by speciesID;

SELECT speciesName as Not_in_Reserve from Animal where speciesID not in (select speciesID from Population);