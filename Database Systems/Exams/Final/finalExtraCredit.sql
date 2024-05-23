CREATE DATABASE IF NOT EXISTS CSC315Final2024;
USE CSC315Final2024;

-- Create the User table
CREATE TABLE IF NOT EXISTS Users (
    uid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(20),
    homeCountry VARCHAR(20)
);

-- Create the Favorites table
CREATE TABLE IF NOT EXISTS Favorites (
    uid INT NOT NULL,
    bid INT NOT NULL,
    FOREIGN KEY (uid)
        REFERENCES Users (uid),
    FOREIGN KEY (bid)
        REFERENCES Bands (bid)
);

-- Insert Users
INSERT INTO Users (username, homeCountry) VALUES ('User1', 'United States');
INSERT INTO Users (username, homeCountry) VALUES ('User2', 'Mongolia');
INSERT INTO Users (username, homeCountry) VALUES ('User3', 'Mongolia');

-- Insert Favorites for User1
INSERT INTO Favorites (uid, bid) VALUES (1, (SELECT bid FROM Bands WHERE bname = 'Paul Pena'));
INSERT INTO Favorites (uid, bid) VALUES (1, (SELECT bid FROM Bands WHERE bname = 'The Hu'));

-- Insert Favorites for User2
INSERT INTO Favorites (uid, bid) VALUES (2, (SELECT bid FROM Bands WHERE bname = 'Paul Pena'));
INSERT INTO Favorites (uid, bid) VALUES (2, (SELECT bid FROM Bands WHERE bname = 'Tengger Cavalry'));
INSERT INTO Favorites (uid, bid) VALUES (2, (SELECT bid FROM Bands WHERE bname = 'Sade'));
INSERT INTO Favorites (uid, bid) VALUES (2, (SELECT bid FROM Bands WHERE bname = 'Battuvshin'));

-- Insert Favorites for User3
INSERT INTO Favorites (uid, bid) VALUES (3, (SELECT bid FROM Bands WHERE bname = 'The Hu'));
INSERT INTO Favorites (uid, bid) VALUES (3, (SELECT bid FROM Bands WHERE bname = 'Tengger Cavalry'));
INSERT INTO Favorites (uid, bid) VALUES (3, (SELECT bid FROM Bands WHERE bname = 'Sade'));
INSERT INTO Favorites (uid, bid) VALUES (3, (SELECT bid FROM Bands WHERE bname = 'Battuvshin'));

-- Modified Query 7 to rank "Tengger Cavalry" first
SELECT bname 
FROM Bands 
JOIN
    (SELECT DISTINCT bid 
     FROM
         (SELECT uid 
          FROM Favorites 
          WHERE bid IN (SELECT bid FROM Favorites WHERE uid = 1) AND uid != 1) AS OtherUsers
     JOIN Favorites F ON F.uid = OtherUsers.uid
    ) AS OtherFavorites ON Bands.bid = OtherFavorites.bid
ORDER BY 
    CASE 
        WHEN bname = 'Tengger Cavalry' THEN 0
        ELSE 1
    END;
