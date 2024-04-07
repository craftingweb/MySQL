-- Vitaliy Prymak Midterm

CREATE DATABASE CSC315MIDTERM;
USE CSC315MIDTERM;

CREATE TABLE Professors(
    PID INT AUTO_INCREMENT PRIMARY KEY, 
    Field VARCHAR(100) NOT NULL,
    Professor_Name VARCHAR(100) NOT NULL,
    College VARCHAR(100) NOT NULL,
    PhD_Date DATE
);

CREATE TABLE Flubs(
    FID INT AUTO_INCREMENT PRIMARY KEY,
    Content VARCHAR(100) NOT NULL,
    Inventor INT,
	FlubDate DATE,
    Purpose VARCHAR(100) NOT NULL,
    Moment VARCHAR(100) NOT NULL,
    FOREIGN KEY (Inventor) REFERENCES Professors(PID)
);

CREATE TABLE Citations(
    CITID INT AUTO_INCREMENT PRIMARY KEY, 
    PID INT,
    FID INT,
    FOREIGN KEY (PID) REFERENCES Professors(PID),
    FOREIGN KEY (FID) REFERENCES Flubs(FID)
);

CREATE TABLE Bounces(
    BID INT AUTO_INCREMENT PRIMARY KEY,
    FID INT,
    PID INT,
	BounceDate DATE,
    FOREIGN KEY (PID) REFERENCES Professors(PID),
    FOREIGN KEY (FID) REFERENCES Flubs(FID)
);

CREATE TABLE Colleagues(
    CID INT AUTO_INCREMENT PRIMARY KEY,
    PID INT,
    FOREIGN KEY (PID) REFERENCES Professors(PID)
);


-- A. Adding a new Professor
INSERT INTO Professors (Field, Professor_Name, College, PhD_Date) 
VALUES ('Economics', 'Alice Smith', 'Economics Institute', '2024-04-07');

-- B. Changing a specific Professor's Department
UPDATE Professors 
SET 
    Field = 'Computer Science'
WHERE
    Field = 'Economics';

-- C. Removing a Flub by ID
DELETE FROM Flubs WHERE FID = 1;

-- D. Show a portfolio of the Flubs by a Professor in reverse chronological order
SELECT *
FROM
    Flubs
WHERE
    Inventor = 1
ORDER BY FlubDate DESC;

-- E. Show how many Bounces and how many Citations a Flub of particular ID has
SELECT 
    Flubs.FID,
    COUNT(DISTINCT Bounces.BID) AS Bounce_Count,
    COUNT(DISTINCT Citations.CITID) AS Citation_Count
FROM
    Flubs
LEFT JOIN
    Bounces ON Flubs.FID = Bounces.FID
LEFT JOIN
    Citations ON Flubs.FID = Citations.FID
WHERE
    Flubs.FID = 1
GROUP BY Flubs.FID;

-- F. Show a portfolio of all Flubs and Bounces (the Flubs bounced) by all of a Professor's Colleagues in reverse chronological order
SELECT Bounces.*, Flubs.* 
FROM Flubs, Bounces 
WHERE Flubs.FID IN(SELECT PID FROM Colleagues WHERE CID = 1) 
AND Bounces.FID IN(SELECT PID FROM Colleagues WHERE CID = 1) 
ORDER BY Bounces.BounceDate DESC, Flubs.FlubDate DESC;
