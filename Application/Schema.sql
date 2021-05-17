-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE Employees (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL,
    Surname TEXT NOT NULL,
    Name TEXT NOT NULL,
    Passport TEXT NOT NULL UNIQUE,
    Airport_ID UUID DEFAULT NULL,
    Schedule TEXT DEFAULT NULL,
    AccessLevel INT DEFAULT 0 NOT NULL,
    Salary REAL DEFAULT 0 NOT NULL,
    JobName TEXT DEFAULT NULL
);
CREATE TABLE Airports (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL UNIQUE,
    Address TEXT NOT NULL
);
CREATE TABLE Planes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    Name TEXT NOT NULL,
    Capacity INT NOT NULL,
    Airport_ID UUID NOT NULL,
    Model TEXT NOT NULL,
    Number TEXT NOT NULL
);
CREATE TABLE Gates (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    GateName TEXT NOT NULL,
    Airport_ID UUID NOT NULL,
    Schedule TEXT NOT NULL
);
CREATE TABLE Flights (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL UNIQUE,
    FlightNumber TEXT NOT NULL,
    FromPort_ID UUID NOT NULL,
    ToPort_ID UUID NOT NULL,
    OutputGate_ID UUID NOT NULL,
    InputGate_ID UUID NOT NULL,
    Plane_ID UUID NOT NULL,
    DepartureTime TIMESTAMP WITH TIME ZONE NOT NULL,
    FlightType TEXT NOT NULL,
    ArrivalTime TIMESTAMP WITH TIME ZONE NOT NULL
);
CREATE TABLE EmployeeFlight (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL UNIQUE,
    Employee_ID UUID NOT NULL UNIQUE,
    Flight_ID UUID NOT NULL UNIQUE,
    Payment REAL NOT NULL
);
CREATE TABLE Dispatchers (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    Emp_ID UUID NOT NULL UNIQUE,
    Port_ID UUID NOT NULL
);
ALTER TABLE Dispatchers ADD CONSTRAINT Dispatchers_fk0 FOREIGN KEY (Emp_ID) REFERENCES Employees (id) ON DELETE CASCADE;
ALTER TABLE Dispatchers ADD CONSTRAINT Dispatchers_fk1 FOREIGN KEY (Port_ID) REFERENCES Airports (id) ;
ALTER TABLE EmployeeFlight ADD CONSTRAINT EmployeeFlight_fk0 FOREIGN KEY (Employee_ID) REFERENCES Employees (id) ON DELETE CASCADE;
ALTER TABLE EmployeeFlight ADD CONSTRAINT EmployeeFlight_fk1 FOREIGN KEY (Flight_ID) REFERENCES Flights (id) ;
ALTER TABLE Employees ADD CONSTRAINT Employees_fk0 FOREIGN KEY (Airport_ID) REFERENCES Airports (id) ;
ALTER TABLE Flights ADD CONSTRAINT Flights_fk0 FOREIGN KEY (FromPort_ID) REFERENCES Airports (id) ;
ALTER TABLE Flights ADD CONSTRAINT Flights_fk1 FOREIGN KEY (ToPort_ID) REFERENCES Airports (id) ;
ALTER TABLE Flights ADD CONSTRAINT Flights_fk2 FOREIGN KEY (OutputGate_ID) REFERENCES Gates (id) ;
ALTER TABLE Flights ADD CONSTRAINT Flights_fk3 FOREIGN KEY (InputGate_ID) REFERENCES Gates (id) ;
ALTER TABLE Flights ADD CONSTRAINT Flights_fk4 FOREIGN KEY (Plane_ID) REFERENCES Planes (id) ;
ALTER TABLE Gates ADD CONSTRAINT Gates_fk0 FOREIGN KEY (Airport_ID) REFERENCES Airports (id) ;
ALTER TABLE Planes ADD CONSTRAINT Planes_fk0 FOREIGN KEY (Airport_ID) REFERENCES Airports (id) ;
