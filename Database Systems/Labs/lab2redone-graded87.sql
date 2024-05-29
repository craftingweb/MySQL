-- Part A

CREATE DATABASE CSC315Lab2;
USE CSC315Lab2;


CREATE TABLE Suppliers (
    sid INTEGER PRIMARY KEY,
    sname VARCHAR(50),
    address VARCHAR(100)
);

INSERT INTO Suppliers (sid, sname, address) VALUES
(1, 'Acme Widget Suppliers', '123 Main St'),
(2, 'Widget World', '456 Elm St'),
(3, 'Gizmo Galaxy', '789 Oak St'),
(4, 'Techtronics', '101 Pine St');


CREATE TABLE Parts (
    pid INTEGER PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

INSERT INTO Parts (pid, pname, color) VALUES
(1, 'Widget A', 'Red'),
(2, 'Widget B', 'Blue'),
(3, 'Gizmo X', 'Green'),
(4, 'Tech Part 1', 'Red');


CREATE TABLE Catalog (
    sid INTEGER,
    pid INTEGER,
    cost REAL,
    FOREIGN KEY (sid) REFERENCES Suppliers(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Catalog (sid, pid, cost) VALUES
(1, 1, 10.50),
(1, 2, 12.75),
(1, 3, 8.25),
(2, 1, 9.75),
(2, 3, 7.50),
(3, 2, 11.25),
(3, 3, 9.00),
(4, 1, 11.00),
(4, 2, 13.25),
(4, 3, 8.75);

-- Part B

-- Query 1

SELECT DISTINCT pname FROM Parts WHERE pid IN (SELECT DISTINCT pid FROM Catalog);

-- Query 2

SELECT sname FROM Suppliers WHERE NOT EXISTS (
    SELECT pid FROM Parts
    WHERE NOT EXISTS (
        SELECT * FROM Catalog
        WHERE Suppliers.sid = Catalog.sid AND Parts.pid = Catalog.pid
    )
);

-- Query 3

SELECT DISTINCT sname FROM Suppliers WHERE NOT EXISTS (
    SELECT pid FROM Parts WHERE color = 'Red' AND NOT EXISTS (
        SELECT * FROM Catalog
        WHERE Suppliers.sid = Catalog.sid AND Parts.pid = Catalog.pid
    )
);

-- Query 4

SELECT pname FROM Parts WHERE pid IN (
    SELECT pid FROM Catalog WHERE sid = (
        SELECT sid FROM Suppliers WHERE sname = 'Acme Widget Suppliers'
    )
    GROUP BY pid HAVING COUNT(DISTINCT sid) = 1
);

-- Query 5

SELECT DISTINCT sid FROM Catalog WHERE cost > (
    SELECT AVG(cost) FROM Catalog AS C WHERE Catalog.pid = C.pid
);

-- Query 6

SELECT p.pname, s.sname FROM Catalog AS c
JOIN Parts AS p ON c.pid = p.pid
JOIN Suppliers AS s ON c.sid = s.sid
WHERE (c.pid, c.cost) IN (
    SELECT pid, MAX(cost) FROM Catalog GROUP BY pid
);

-- Query 7

SELECT sid 
FROM Catalog 
WHERE pid IN (
    SELECT pid FROM Parts WHERE color = 'Red'
) 
GROUP BY sid 
HAVING COUNT(DISTINCT pid) = 1;


-- Query 8

SELECT sid FROM Catalog WHERE pid IN (
    SELECT pid FROM Parts WHERE color = 'Red'
) AND sid IN (
    SELECT sid FROM Catalog WHERE pid IN (
        SELECT pid FROM Parts WHERE color = 'Green'
    )
);

-- Query 9

SELECT DISTINCT sid FROM Catalog WHERE pid IN (
    SELECT pid FROM Parts WHERE color = 'Red'
) OR pid IN (
    SELECT pid FROM Parts WHERE color = 'Green'
);

-- Query 10

SELECT s.sname, COUNT(c.pid) AS total_parts
FROM Catalog c
JOIN Suppliers s ON c.sid = s.sid
WHERE s.sid NOT IN (
    SELECT sid FROM Catalog WHERE pid IN (
        SELECT pid FROM Parts WHERE color != 'Green'
    )
)
GROUP BY s.sname;

-- Query 11

SELECT s.sname, MAX(c.cost) AS max_price
FROM Catalog c
JOIN Suppliers s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE p.color IN ('Green', 'Red')
GROUP BY s.sname;

DROP DATABASE CSC315Lab2;
