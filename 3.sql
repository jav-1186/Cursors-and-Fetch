/* Delete the tables if they already exist */
drop table  Restaurant cascade constraints;
drop table  Reviewer cascade constraints;
drop table  Rating cascade constraints;
drop table  Restaurant_Locations cascade constraints;

/* Create the schema for our tables */
create table Restaurant(rID int, name varchar2(100), address varchar2(100), cuisine varchar2(100));
create table Reviewer(vID int, name varchar2(100));
create table Rating(rID int, vID int, stars int, ratingDate date);
create table Restaurant_Locations(rID int, name varchar(30), street_Address varchar(20), city varchar(20), state varchar(3), zipcode int, cuisine varchar(50));

/* Populate the tables with our data */
insert into Restaurant values(101, 'India House Restaurant', '59 W Grand Ave Chicago, IL 60654', 'Indian');
insert into Restaurant values(102, 'Bombay Wraps', '122 N Wells St Chicago, IL 60606', 'Indian');
insert into Restaurant values(103, 'Rangoli', '2421 W North Ave Chicago, IL 60647', 'Indian');
insert into Restaurant values(104, 'Cumin', '1414 N Milwaukee Ave Chicago, IL 60622', 'Indian');
insert into Restaurant values(105, 'Shanghai Inn', '4723 N Damen Ave Chicago, IL 60625', 'Chinese');
insert into Restaurant values(106, 'MingHin Cuisine', '333 E Benton Pl Chicago, IL 60601', 'Chinese');
insert into Restaurant values(107, 'Shanghai Terrace', '108 E Superior St Chicago, IL 60611', 'Chinese');
insert into Restaurant values(108, 'Jade Court', '626 S Racine Ave Chicago, IL 60607', 'Chinese');

insert into Reviewer values(2001, 'Sarah M.');
insert into Reviewer values(2002, 'Daniel L.');
insert into Reviewer values(2003, 'B. Harris');
insert into Reviewer values(2004, 'P. Suman');
insert into Reviewer values(2005, 'Suikey S.');
insert into Reviewer values(2006, 'Elizabeth T.');
insert into Reviewer values(2007, 'Cameron J.');
insert into Reviewer values(2008, 'Vivek T.');

insert into Rating values( 101, 2001,2, DATE '2011-01-22');
insert into Rating values( 101, 2001,4, DATE '2011-01-27');
insert into Rating values( 106, 2002,4, null);
insert into Rating values( 103, 2003,2, DATE '2011-01-20');
insert into Rating values( 108, 2003,4, DATE '2011-01-12');
insert into Rating values( 108, 2003,2, DATE '2011-01-30');
insert into Rating values( 101, 2004,3, DATE '2011-01-09');
insert into Rating values( 103, 2005,3, DATE '2011-01-27');
insert into Rating values( 104, 2005,2, DATE '2011-01-22');
insert into Rating values( 108, 2005,4, null);
insert into Rating values( 107, 2006,3, DATE '2011-01-15');
insert into Rating values( 106, 2006,5, DATE '2011-01-19');
insert into Rating values( 107, 2007,5, DATE '2011-01-20');
insert into Rating values( 104, 2008,3, DATE '2011-01-02');

CREATE OR REPLACE PROCEDURE UpdateReviews
(p_resname IN Restaurant.name%TYPE, p_username IN Reviewer.name%TYPE, p_rating IN Rating.stars%TYPE, p_data IN Rating.ratingdate%TYPE)

AS
p_rID  Restaurant.rID%TYPE;
p_vID reviewer.vid%TYPE;

BEGIN

SELECT DISTINCT rID INTO p_rID FROM Restaurant WHERE Restaurant.name = p_resname;
Select DISTINCT vID INTO p_vID FROM Reviewer WHERE p_username = Reviewer.name;

INSERT INTO Rating VALUES(p_rID, p_vID, p_rating, p_data);
EXCEPTION
   WHEN no_data_found
   THEN
   INSERT INTO Reviewer VALUES (3000, p_username);
   SELECT DISTINCT rID INTO p_rID FROM Restaurant WHERE Restaurant.name = p_resname;
   Select DISTINCT vID INTO p_vID FROM Reviewer WHERE p_username = Reviewer.name;

   INSERT INTO Rating VALUES(p_rID, p_vID, p_rating, p_data);
   
END;
/

BEGIN
   UpdateReviews('Shanghai Terrace','Cameron J.', 5, DATE '2017-8-17');
   UpdateReviews('Rangoli','Vivek T.',3,DATE '2017-9-17');
   UpdateReviews('Shanghai Inn','Audrey M.',2,DATE '2017-7-8');
   UpdateReviews('Cumin','Cameron J.', 2, DATE '2017-9-17');
END;
/

