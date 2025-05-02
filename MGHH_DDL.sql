-- IMPORTANT NOTE!!!
-- You only need to run these DROP commands if you want to drop the tables and start over from a blank database!
-- For example, if you created the tables as described in class with the small number of horses and now you need to create the full dataset
-- OR if you are working on the project and think you have done something to mess up the database, DROP and recreate the tables to get a fresh start/
-- If you run the drop command for a table that does not exist you will get an error message - no big deal, just move on
-- *********************************************************************************************************************
-- 
-- The first time you run this code you either:
-- 1. Just need to drop horses, customers, medications, and orders (if you have been following along)
-- 2. You don't need to drop anything if you have not preivously created any tables
--
-- *********************************************************************************************

DROP TABLE CourseCustomer; 
DROP TABLE Courses; 
DROP TABLE Topics;
DROP TABLE WorkerBarn;
DROP TABLE WorkerCert;
DROP TABLE certifications;
DROP TABLE Workers;
DROP TABLE HorseRaces;
DROP TABLE Races;
DROP TABLE Orders;
DROP TABLE Medications;
DROP TABLE Horses;
DROP TABLE Stables;
DROP TABLE Barns;
DROP TABLE Customers;


--First create customers, because they do not reference anything
CREATE TABLE customers (
 username varchar(50) CONSTRAINT pk_customers PRIMARY KEY,
 Fname    varchar(50) CONSTRAINT nn_fname NOT NULL,
 Lname    varchar(50) CONSTRAINT nn_lname NOT NULL,
 Phone    varchar(14) CONSTRAINT nn_Phone NOT NULL
);

--Then barns, which also do not reference anything, but we must have barns to have stables
--and we must have stables (and customers) to have horses. Remember, it matters what order you create the tables when things reference one another!

CREATE TABLE barns (
 BarnID varchar(20) CONSTRAINT pk_barns PRIMARY KEY,
 Description varchar(50),
 capacity integer
);

CREATE TABLE stables (
 FKBarnID varchar(20),
 StableID integer,
 Status varchar(50),
 CONSTRAINT fk_stable_barn FOREIGN KEY (FKBarnID) REFERENCES barns (BarnID),
 CONSTRAINT pk_stables PRIMARY KEY (FKBarnID, StableID)
);

CREATE TABLE horses (
 Name   varchar(50) CONSTRAINT pk_horse PRIMARY KEY,
 Color  varchar(50) DEFAULT 'UNK' CONSTRAINT chk_color CHECK (color IN
 ('Black','White','Brown','Grey','Red','Yellow', 'UNK')),
 Spots  varchar(3) DEFAULT 'UNK',
 Sex    varchar(1) CONSTRAINT nn_sex NOT NULL,
 Weight integer,
 owner varchar(50),
 FKBarn varchar(20) CONSTRAINT nn_fkbarn NOT NULL,
 FKStable integer CONSTRAINT nn_fkstable NOT NULL,
 CONSTRAINT unq_barn_stable UNIQUE (FKBarn, FKStable),
 CONSTRAINT fk_horse_stable FOREIGN KEY (FKStable, FKBarn) REFERENCES stables (StableID, FKBarnID),
 CONSTRAINT chk_weight CHECK (weight >= 800 AND weight <=2200),
 CONSTRAINT chk_sex CHECK (sex IN ('M','F')),
 CONSTRAINT fk_cust FOREIGN KEY (owner) REFERENCES customers (username) ON DELETE CASCADE
);

--Medications do not depend on anything, but of course medications must exist in order to be ordered for horses!
CREATE TABLE medications (
 medcode varchar(50) CONSTRAINT pk_medications PRIMARY KEY,
 medname varchar(50) CONSTRAINT nn_medname NOT NULL,
 classification varchar(50) CONSTRAINT nn_classification NOT NULL,
 cost    float(32) CONSTRAINT chk_cost CHECK (cost between 1 and 200),
 QoH     integer,
 QoO     integer,
 CONSTRAINT chk_qty CHECK ((QoH + QoO) BETWEEN 10 AND 100)
);

CREATE TABLE orders (
 RxNum integer CONSTRAINT pk_orders PRIMARY KEY,
 ORD_Medcode varchar (50),
 ORD_Horsename varchar(50),
 Dose integer DEFAULT 1,
 Frequency integer DEFAULT 2,
 CONSTRAINT fk_meds FOREIGN KEY (ORD_Medcode) REFERENCES medications (medcode),
 CONSTRAINT fk_horses FOREIGN KEY (ORD_Horsename) REFERENCES horses (name) ON DELETE CASCADE
);

--Races do not reference anything, but they must exist in order for horses to participate in races
CREATE TABLE races (
 RaceID varchar(5) CONSTRAINT pk_races PRIMARY KEY,
 RaceName varchar(100),
 TrackName varchar(100),
 Location varchar(100)
);

CREATE TABLE HorseRaces (
 FKRaceID varchar(5),
 FKHorseName varchar(50),
 year integer,
 place varchar(50),
 CONSTRAINT fk_HRRaces FOREIGN KEY (FKRaceID) REFERENCES races (RaceID),
 CONSTRAINT fk_HRHorses FOREIGN KEY (FKHorseName) REFERENCES horses (Name),
 CONSTRAINT pk_horse_races PRIMARY KEY (FKRaceID, FKHorseName, year)
);

--Workers (also called employees, but I have some similarly names tables in the database for other examples during class)
--only refer to themselves in this unary relationship

CREATE TABLE Workers (
 EmpID integer PRIMARY KEY,
 Name varchar(100),
 Phone varchar(10),
 title varchar(100),
 salary integer,
 HireDate DATE,  
 TerminationDate DATE,
 DOB DATE,
 supervisor integer,
 CONSTRAINT fkWorkersSup FOREIGN KEY (supervisor) REFERENCES Workers (EmpID)
);

CREATE TABLE certifications (
 CertID varchar(5) CONSTRAINT pk_certifications PRIMARY KEY,
 CertName varchar(100),
 YearsValid integer
);


CREATE TABLE WorkerCert (
 FKCertID varchar(5),
 FKEmpID integer,
 DateObtained DATE,
 CONSTRAINT pk_WorkerCert PRIMARY KEY (FKCertID, FKEmpID),
 CONSTRAINT fk_wc_Certs FOREIGN KEY (FKCertID) REFERENCES Certifications (CertID),
 CONSTRAINT fk_wc_workers  FOREIGN KEY (FKEmpID) REFERENCES Workers (EmpID)
);

CREATE TABLE WorkerBarn (
 FKEmpID integer,
 FKBarnID varchar(20),
 CONSTRAINT pk_workerbarn PRIMARY KEY (FKEmpID, FKBarnID),
 CONSTRAINT fk_wb_Workers FOREIGN KEY (FKEmpID) REFERENCES Workers (EmpID),
 CONSTRAINT fk_wb_Barns  FOREIGN KEY (FKBarnID) REFERENCES Barns (BarnID)
);

CREATE TABLE Topics (
 TopicCode varchar(100) CONSTRAINT pkTopics PRIMARY KEY,
 CourseName varchar(255),
 PreReq varchar(100),
 CONSTRAINT fk_Topics FOREIGN KEY (prereq) REFERENCES topics (TopicCode)
);
 

CREATE TABLE Courses (
 CourseID varchar(100) CONSTRAINT pk_classes PRIMARY KEY,
 FKTopicCode varchar(100),
 FKEmpID INTEGER,
 Term varchar(20),
 year integer,
 StartDate DATE,
 EndDate DATE,
 Days varchar(50),
 StartTime varchar(10),
 EndTime varchar(10),
 SizeLimit INTEGER,
 Cost INTEGER,
 CONSTRAINT fk_classes_Topics FOREIGN KEY (FKTopicCode) REFERENCES topics (TopicCode),
 CONSTRAINT fk_classes_workers FOREIGN KEY (FKEmpID) REFERENCES workers (EmpID)
);


CREATE TABLE CourseCustomer (
 FKUsername varchar(50),
 FKCourseID varchar(100),
 CONSTRAINT pk_CourseCustomer PRIMARY KEY (FKUsername, FKCourseID),
 CONSTRAINT fk_CC_Customer FOREIGN KEY (FKUsername) REFERENCES Customers (username),
 CONSTRAINT fk_CC_Course FOREIGN KEY (FKCourseID) REFERENCES Courses (CourseID)
);

