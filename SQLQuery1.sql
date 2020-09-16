CREATE DATABASE UniSafety;

USE UniSafety;

CREATE TABLE Uni_Community(
    UCID int NOT NULL,
    UCName varchar (30),
    UCAddress varchar (50),
    UCPhone char (10),
    UCEmail varchar (35),
    UCType varchar(10),
	CONSTRAINT UCType_CHK CHECK ( UCType IN ('Student','Staff', 'Faculty') ),
    Constraint Uni_Community_PK primary key (UCID)
    );
	-- The university students and staff

CREATE TABLE Anti_Theft_Registration (
    Registration_ID int IDENTITY(1,1) NOT NULL,
    UC_ID int NOT NULL,
    Registration_Datetime Datetime,
    Registration_Property_Type varchar(12),
    Registration_Property_SerialNo varchar (15),
	CONSTRAINT RegPropType_CHK CHECK ( Registration_Property_Type IN ('Laptop','Calculator', 'Hard Drive', 'Bike', 'Skateboard') ),
    CONSTRAINT Anti_Theft_Reg_PK PRIMARY KEY (Registration_ID,UC_ID),
    CONSTRAINT Anti_Theft_Reg_FK1 FOREIGN KEY (UC_ID) REFERENCES Uni_Community (UCID),
    );
-- The devices for which faculty/staff register so that they can be tracked.


CREATE TABLE Unit_Duty(
    DutyID int IDENTITY(1,1) NOT NULL,
    DutyType [varchar](50),
    CONSTRAINT UnitDuty_PK primary key (DutyID)
    );
	-- The duties of different units

CREATE TABLE Unit(
    UnitID int NOT NULL,
    UnitName varchar (25),
    DutyID int NOT NULL,
    CONSTRAINT Unit_PK primary key (UnitID),
    CONSTRAINT  Unit_FK foreign key (DutyID) references Unit_Duty(DutyID)
    );
	-- Unit or different divisions in the safety department

CREATE TABLE [Service](
    ServiceID int NOT NULL,
    ServiceName varchar (40),
    UnitID int NOT NULL,
    CONSTRAINT Service_PK PRIMARY KEY (ServiceID),
    CONSTRAINT Service_FK FOREIGN KEY (UnitID) REFERENCES Unit(UnitID)
    );
-- The services provided by various units/divisions of the department.

CREATE TABLE [Shift](
	Shift_Number int IDENTITY(1,1) NOT NULL,
	Shift_StartTime time,
	Shift_EndTime time,
	CONSTRAINT Shift_pk PRIMARY KEY (Shift_Number)
 );
 -- The different shifts that can be assigned to an employee

CREATE TABLE Responsibility(
	Responsibility_ID int IDENTITY(1,1) NOT NULL,
	Responsibiliyt_Type varchar(50),
	CONSTRAINT Res_pk PRIMARY KEY (Responsibility_ID)
 );
 -- Responsibilities of different employees

CREATE TABLE Employee(
	Employee_ID int IDENTITY(1,1) NOT NULL,
	Unit_ID int,
	Emp_Name varchar(30),
	Emp_BloodGroup varchar(3),
	Emp_Address varchar(50),
	Emp_Phone char(12),
	Emp_SSN char(9),
	Emp_DateHired date,
	Emp_Type char(1) NOT NULL,
	Shift_Number int,
	Emp_SupervisorID int,
	Responsibility_ID int,
	CONSTRAINT Emp_pk PRIMARY KEY (Employee_ID),
	CONSTRAINT Bgroup_chk CHECK (Emp_BloodGroup IN ('O+','O-','AB+','AB-','A+','A-','B+','B-')),
	CONSTRAINT unitemp_fk FOREIGN KEY (Unit_ID) REFERENCES Unit(UnitID),
	CONSTRAINT emptypecons CHECK (Emp_Type IN ('C','S','O')),
	CONSTRAINT emp_uniquetype UNIQUE (Employee_ID,Emp_Type),
	CONSTRAINT ShiftEmp_fk FOREIGN KEY (Shift_Number) REFERENCES [Shift](Shift_Number),
	CONSTRAINT Supervisoremp_fk FOREIGN KEY (Emp_SupervisorID) REFERENCES Employee(Employee_ID),
	CONSTRAINT Responsibilityemp_fk FOREIGN KEY (Responsibility_ID) REFERENCES Responsibility(Responsibility_ID)
 );

CREATE TABLE Civilian(
	Civilian_ID int NOT NULL,
	Emp_Type char(1) DEFAULT 'C' NOT NULL,
	JobType varchar(20),
	Civilian_Salarypm int,
	CONSTRAINT civ_pk PRIMARY KEY (Civilian_ID),
	CONSTRAINT civ_chk CHECK(Emp_Type = 'C'),
	CONSTRAINT civ_unq UNIQUE (Civilian_ID,Emp_Type),
	CONSTRAINT civ_fk FOREIGN KEY (Civilian_ID,Emp_Type) REFERENCES Employee(Employee_ID,Emp_Type)
	ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE Student(
	Std_ID int NOT NULL,
	Emp_Type char(1) DEFAULT 'S' NOT NULL,
	UC_ID int,
	Student_Wageph int,
	CONSTRAINT std_pk PRIMARY KEY (Std_ID),
	CONSTRAINT ucstd_fk FOREIGN KEY (UC_ID) REFERENCES Uni_Community(UCID),
	CONSTRAINT std_chk CHECK(Emp_Type = 'S'),
	CONSTRAINT std_unq UNIQUE (Std_ID,Emp_Type),
	CONSTRAINT std_fk FOREIGN KEY (Std_ID,Emp_Type) REFERENCES Employee(Employee_ID,Emp_Type)
	ON UPDATE CASCADE ON DELETE CASCADE
 );
 
CREATE TABLE Officer(
	Officer_ID int NOT NULL,
	Emp_Type char(1) DEFAULT 'O' NOT NULL,
	[Rank] varchar(10),
	Officer_Salarypm int,
	CONSTRAINT off_pk PRIMARY KEY (Officer_ID),
	CONSTRAINT off_chk CHECK(Emp_Type = 'O'),
	CONSTRAINT off_unq UNIQUE (Officer_ID,Emp_Type),
	CONSTRAINT off_fk FOREIGN KEY (Officer_ID,Emp_Type) REFERENCES Employee(Employee_ID,Emp_Type)
	ON UPDATE CASCADE ON DELETE CASCADE
 );

CREATE TABLE Service_Enrollment(
    Service_ID int NOT NULL,
    UC_ID int NOT NULL,
    Date_Enrolled Date,
    Emp_Incharge int NOT NULL,
    Service_Location varchar(25),
    CONSTRAINT Service_Enrollment_PK PRIMARY KEY (Service_ID,UC_ID),
    CONSTRAINT Service_Enrollment_FK1 FOREIGN KEY (Service_ID) references [Service] (ServiceID),
    CONSTRAINT Service_Enrollment_FK2 FOREIGN KEY (UC_ID) references Uni_Community (UCID),
    CONSTRAINT Service_Enrollment_FK3 FOREIGN KEY (Emp_Incharge) references Employee (Employee_ID)
);

CREATE TABLE [Notification](
	Notification_ID int identity(1,1) NOT NULL,
	Notification_Type varchar(10),
	Notification_Time DateTime,
	Notification_Details varchar(50),
	App_Officer int NOT NULL,
	CONSTRAINT notif_pk PRIMARY KEY (Notification_ID),
	CONSTRAINT notift_chk CHECK (Notification_Type IN ('Alert','Advisory')),
	CONSTRAINT notifoff_fk FOREIGN KEY (App_Officer) REFERENCES Officer( Officer_ID)
);

CREATE TABLE Incident(
	Incident_ID int IDENTITY(1,1) NOT NULL,
	Incident_Reportee varchar(30),
	Incident_Type varchar(20),
	Incident_Location varchar(40),
	Incident_Timestamp datetime,
	Incident_Status varchar(15),
	Officer_Incharge int NOT NULL,
	Incident_RequiresReport binary,
	CONSTRAINT inc_pk PRIMARY KEY (Incident_ID),
	CONSTRAINT inceoff_fk FOREIGN KEY (Officer_Incharge) REFERENCES Officer(Officer_ID)
);

CREATE TABLE Report(	
	Report_ID int IDENTITY(1,1) NOT NULL,
	Incident_ID int NOT NULL,
	Report_Details varchar(75),
	CONSTRAINT rep_pk PRIMARY KEY (Report_ID,Incident_ID),
	CONSTRAINT rep_fk FOREIGN KEY (Incident_ID) REFERENCES Incident(Incident_ID)
);


CREATE TRIGGER InsertEmpTrig 
ON Employee
AFTER INSERT,UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @emptype char(2), @empID int
	SELECT @emptype = i.Emp_Type, @empID = i.Employee_ID FROM inserted AS i
	IF(@emptype = 'C')
	INSERT INTO Civilian(Civilian_ID)VALUES (@empID)
	ELSE IF(@emptype = 'S')
	INSERT INTO Student(Std_ID) VALUES (@empID)
	ELSE
	INSERT INTO Officer(Officer_ID) VALUES (@empID)
END


 