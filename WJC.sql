/* Drop database if it already exists */
Drop Database if exists WJC;

/* Create it from scratch */
create Database WJC;
use 'WJC';

/* Clear tables */
drop Table if exists Animals;
drop Table if exists Eats;
drop Table if exists Reserves;
drop Table if exists Populations;
drop Table if exists Transfers;

/* Schema Definitions with referential integrity */
create Table Animals (speciesID int, speciesName  varchar(30) not null, class text not null, primary key (speciesID), unique(speciesID, speciesName));

create Table Eats (speciesID int references Animals(speciesID) on update cascade, preyID int, primary key (speciesID, preyID));

create Table Reserves (reserveID int, reserveName varchar(20), city text, primary key (reserveID, reserveName));

create Table Populations (speciesID int references Animals(speciesID) on update cascade, reserveID int references Reserves(reserveID) on update cascade, Population int, primary key (speciesID, reserveID));

create Table Transfers (reserveID int references Reserves(reserveID) on update cascade, speciesID int references Animals(speciesID) on update cascade, Amount int not null, destinationID int not null, primary key (reserveID, destinationID));


/* Data source: http://www.fws.gov/caribbean/es/endangered-animals.html */


/* Animals (SpeciesID, SpeciesName, Class) */

insert into Animals values (1, 'Eleutherodactylus juanariveroi', 'Amphibians');
insert into Animals values (2, 'Eleutherodactylus coqui', 'Amphibians');
insert into Animals values (3, 'Anolis roosevelti', 'Reptiles');
insert into Animals values (4, 'Epicrates inornatus', 'Reptiles');
insert into Animals values (5, 'Eretmochelys imbricata', 'Reptiles');
insert into Animals values (6, 'Sphaerodactylus micropithecus', 'Reptiles');
insert into Animals values (7, 'Accipiter striatus venator', 'Birds');
insert into Animals values (8, 'Amazona vittata', 'Birds');
insert into Animals values (9, 'Buteo platypterus brunnescens', 'Birds');
insert into Animals values (10, 'Caprimulgus noctitherus', 'Birds');
insert into Animals values (11, 'Columba inornata wetmorei', 'Birds');
insert into Animals values (12, 'Trichechus manatus', 'Mammals');

/* Reserves (reserveID, reserveName) */

insert into Reserves values (01, 'El yunque', 'Naguabo');
insert into Reserves values (02, 'El seco', 'Guanica');
insert into Reserves values (03, 'Humacao', NULL);
insert into Reserves values (04, 'Toro', NULL);

/* Populations (SpeciesID, reserveID, population) */

insert into Populations values (1, 01, 100);
insert into Populations values (1, 02, 100);
insert into Populations values (2, 01, 100);
insert into Populations values (2, 03, 100);
insert into Populations values (3, 04, 100);
insert into Populations values (3, 01, 100);
insert into Populations values (4, 01, 100);

/* Eats (speciesID, preyID) */

insert into Eats values (1, 1);
insert into Eats values (1, 2);		
insert into Eats values (1, 3);
insert into Eats values (2, 1);
insert into Eats values (2, 2);
insert into Eats values (2, 3);
insert into Eats values (3, 1);
insert into Eats values (3, 3);
insert into Eats values (1, 1);
insert into Eats values (5, 1);
insert into Eats values (5, 2);

/* Transfers(ReserveID, speciesID, Amount, DestinationID) */

insert into Transfers values (02, 1, 3, 04);
insert into Transfers values (01, 3, 20, 02);
insert into Transfers values (01, 3, 5, 01);

/* Sample queries */

select * from (((Animals natural join Populations) natural join Reserves) natural join Eats) natural join Animals as A;

select Eats.speciesID, Animals.speciesName, preyID, vaina.speciesName from (Eats natural join Animals), Animals as vaina where preyID = vaina.speciesID; 
