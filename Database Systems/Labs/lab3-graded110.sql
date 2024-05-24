-- Create the database
CREATE DATABASE lab3;

-- Use the database
USE lab3;

-- Create an application user
CREATE USER 'it'@'localhost' IDENTIFIED BY 'password';

-- Grant necessary permissions to the user
GRANT ALL PRIVILEGES ON lab3.* TO 'it'@'localhost';

-- Create the table
CREATE TABLE table1(
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255) NOT NULL,
    date_added DATE NOT NULL
);

-- Grant permission for user access to the table
GRANT SELECT, INSERT, UPDATE, DELETE ON lab3.table1 TO 'it'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;
