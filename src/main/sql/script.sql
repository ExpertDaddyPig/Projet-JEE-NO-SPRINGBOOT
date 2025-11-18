CREATE DATABASE IF NOT EXISTS rhdatabase;

USE rhdatabase;

DROP TABLE IF EXISTS Departements;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Payslips;

CREATE TABLE
    IF NOT EXISTS Departements (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        departement_name VARCHAR(50),
        employees VARCHAR(1000)
    );

CREATE TABLE
    IF NOT EXISTS Employees (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        departement_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        gender VARCHAR(50),
        registration_number VARCHAR(10),
        projects VARCHAR(1000),
        job_name VARCHAR(100),
        employe_rank INT,
        age INT,
        email VARCHAR(100) NOT NULL UNIQUE,
        username VARCHAR(50) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL,
        createdAt DATE,
        lastLogin DATE,
        active BOOLEAN,
        CONSTRAINT fk_departement_id FOREIGN KEY (departement_id) REFERENCES Departements (id),
        CONSTRAINT check_rank CHECK (
            employe_rank IN (1, 2, 3, 4, 5)
        )
    );

CREATE TABLE
    IF NOT EXISTS Projects (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        project_name VARCHAR(50),
        project_state VARCHAR(50) NOT NULL,
        employees VARCHAR(1000),
        CONSTRAINT check_state CHECK (
            project_state IN ('in process', 'finished', 'canceled')
        )
    );

CREATE TABLE
    IF NOT EXISTS Payslips (
        id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        employe_id INT,
        month INT,
        salary INT,
        primes INT,
        deductions INT,
        CONSTRAINT fk_employe_id FOREIGN KEY (employe_id) REFERENCES Employees (id)
    );