DROP TABLE IF EXISTS houses;
DROP TABLE IF EXISTS owners;
DROP TABLE IF EXISTS transactions;

DROP SEQUENCE IF EXISTS owner_id_seq;
DROP SEQUENCE IF EXISTS transac_id_seq;


CREATE SEQUENCE owner_id_seq START 1;

CREATE TABLE owners (
    owner_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    occupation VARCHAR(50),
    age INT,
    median_salary INT
);

CREATE OR REPLACE FUNCTION generate_owner_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.owner_id := 'o' || nextval('owner_id_seq');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_owner_id
BEFORE INSERT ON owners
FOR EACH ROW
EXECUTE FUNCTION generate_owner_id();

CREATE TABLE houses (
    id SERIAL PRIMARY KEY,
    address VARCHAR(50),
    city VARCHAR(20),
    state VARCHAR(20),
    zip_code VARCHAR(4),
    price INT NOT NULL,
    owner_id VARCHAR(10),
    mortgage INT,
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
);


CREATE SEQUENCE transac_id_seq START 1;
CREATE TYPE transaction_status AS ENUM ('in_progress', 'completed', 'cancelled');

CREATE TABLE transactions (
	transac_id VARCHAR(10) PRIMARY KEY,
	seller VARCHAR(50),
	status VARCHAR(50),
	buyer_id VARCHAR,
	transac_date DATE,
	FOREIGN KEY (buyer_id) REFERENCES owners (owner_id)
);

CREATE OR REPLACE FUNCTION generate_transac_id()
RETURNS TRIGGER AS $$
BEGIN
	NEW.transac_id :='t' || nextval('transac_id_seq') :: VARCHAR;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_transac_id
BEFORE INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION generate_transac_id();


INSERT INTO owners (name, occupation, age, median_salary) VALUES
('John Mike', 'Lawyer', 35, 82000),
('Kevin Rock', 'IT Expert', 39, 71000),
('Louis Micheal', 'Data Scientist', 24, 93000),
('Jack Swash', 'Nurse', 45, 80000),
('Alice Brown', 'Doctor', 55, 84000),
('Jane Johnson', 'Nurse', 28, 90000),
('Mik Bronson', 'Retired', 67, 67000),
('Lewis Sales', 'Product Manager', 35, 55000),
('Micheal Brown', 'Dentist', 70, 80000),
('Scott Foster', 'DB Admin', 35, 45000),
('Kent Carter', 'Producer', 55, 67000),
('Mike Upton', 'Actor', 32, 89000),
('Jason Kidd', 'Director', 25, 43000),
('Edna Lambert', 'Housewife', 51,65000),
('Leo Fraser', 'Policeman', 34, 30000);

INSERT INTO houses (address, city, state, zip_code, price, owner_id, mortgage) VALUES
('145 Maple Street', 'Smalltown', 'ST', '1234', 250000, 'o1', 1000),
('456 Oak Avenue', 'Bigcity', 'BC', '5678', 450000, 'o2', 3000),
('789 Pine Road', 'Middletown', 'MT', '9101', 320000, 'o3', 0),
('101 Birch Lane', 'Townsville', 'TS', '2345', 300000, 'o4', 200000),
('202 Cedar Street', 'Villagetown', 'VT', '6789', 400000, 'o5', 35000),
('303 Spruce Drive', 'Hamletburg', 'HB', '3456', 350000, 'o6', 15400),
('404 Elm Street', 'Cityplace', 'CP', '7890', 500000, 'o7', 25000),
('505 Ash Avenue', 'Boroughville', 'BV', '4567', 375000, 'o8', 4500),
('11 Rodeo Lane', 'Cityplace', 'MT', '9101', 250000, 'o9', 100),
('501 Foxglove Drive', 'Bigcity', 'WS', '3136', 51000, 'o11', 2800),
('94 Cedar Avenue', 'Hamletburg', 'VT', '6789', 75000, 'o12', 6900),
('52 Berry Avenue', 'Bronx', 'BC', '5678', 90000, 'o10', 8300),
('416 Orange Street', 'Alabama', 'BV', '4567', 261000, 'o15', 1700),
('131 White Birch', 'Bronx', 'WS', '3136', 65000, 'o13', 3570),
('971 Jackson Lane', 'Smalltown', 'WS', '3136', 105000, 'o14', 5500);

INSERT INTO transactions (seller, status, buyer_id, transac_date) VALUES
('Robert Kent', 'completed', 'o3', '2015-05-24'),
('Jane Jackson', 'completed', 'o2', '2015-02-01'),
('Miles Rivera', 'cancelled', 'o6', '2015-01-05'),
('Robert Kent', 'in_progress', 'o1', '2015-01-16'),
('Mike Evans', 'completed', 'o4', '2015-06-09'),
('Greg Georges', 'completed', 'o5', '2015-08-13'),	
('Robert Kent', 'cancelled', 'o7', '2015-05-24'),
('Miles Rivera', 'completed', 'o10', '2016-11-07'),	
('Jane Jackson', 'completed', 'o9', '2016-02-15'),
('Robert Kent', 'completed', 'o8', '2015-07-21'),	
('Greg Georges', 'in_progress', 'o15', '2017-01-03'),
('Greg Georges', 'in_progress', 'o11', '2017-08-07'),
('Miles Rivera', 'cancelled', 'o14', '2017-03-19'),
('Jane Jackson', 'completed', 'o13', '2017-01-03'),
('Robert Kent', 'in_progress', 'o12', '2017-12-26');
