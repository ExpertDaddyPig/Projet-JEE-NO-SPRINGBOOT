CREATE DATABASE IF NOT EXISTS rhdatabase;

USE rhdatabase;

CREATE TABLE
    IF NOT EXISTS Departements (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        departement_name VARCHAR(50),
        employees VARCHAR(200)
    );

CREATE TABLE
    IF NOT EXISTS Employees (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        departement_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        gender VARCHAR(50),
        registration_number VARCHAR(10),
        projects VARCHAR(200),
        job_name VARCHAR(100),
        rank INT,
        age INT,
        CONSTRAINT fk_departement_id FOREIGN KEY (departement_id) REFERENCES Departements (id),
        CONSTRAINT check_rank CHECK (
            rank IN (1, 2, 3, 4, 5)
        )
    );

CREATE TABLE
    IF NOT EXISTS Projects (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        project_name VARCHAR(50),
        project_state VARCHAR(50) NOT NULL,
        employees VARCHAR(200),
        CONSTRAINT check_state CHECK (
            project_state IN ('in process', 'finished', 'canceled')
        )
    );

CREATE TABLE
    IF NOT EXISTS Payslips (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        month INT,
        salary INT,
        primes INT,
        deductions INT,
        CONSTRAINT fk_employe_id FOREIGN KEY (id) REFERENCES Employees (id)
    );