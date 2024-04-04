-- Vitaliy Prymak Lab2
CREATE DATABASE CSC315Lab2;
USE CSC315Lab2;

CREATE TABLE Suppliers (
    sid INT,
    sname VARCHAR(100),
    address VARCHAR(200),
    PRIMARY KEY (sid)
);

  INSERT INTO Suppliers VALUES
  (1, 'Apple Inc.', 'One Apple Park Way'),
  (2, 'Google', 'Infinity Loop'),
  (3, 'Microsoft Corporation', 'One Microsoft Way'),
  (4, 'Acme Widget Suppliers', '1600 Amphitheatre Parkway');

CREATE TABLE Parts (
    pid INT,
    pname VARCHAR(100),
    color VARCHAR(100),
    PRIMARY KEY (pid)
);


  INSERT INTO Parts (pid, pname, color) VALUES
  (1, 'CPU Cooler', 'Green'),
  (2, 'GPU', 'Red'),
  (3, 'Motherboard', 'Green'),
  (4, 'Power Supply', 'Red'),
  (5, 'Case', 'Red');

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost INT,
    FOREIGN KEY (sid)
        REFERENCES Suppliers (sid),
    FOREIGN KEY (pid)
        REFERENCES Parts (pid)
);

  INSERT INTO Catalog (sid, pid, cost) VALUES
  (1, 1, 150),
  (2, 2, 200),
  (3, 3, 70),
  (4, 4, 20),
  (2, 5, 175),
  (2, 1, 235);

-- 1. Find the pnames of parts for which there is some supplier.
SELECT DISTINCT
    P.pname
FROM
    parts P,
    Catalog C
WHERE
    P.pid = C.pid;

-- 2. Find the snames of suppliers who supply every part.
SELECT 
    sname
FROM
    Suppliers;
 
-- 3. Find the snames of suppliers who supply every red part.
SELECT 
    Suppliers.sname
FROM
    ((Suppliers
    INNER JOIN Catalog ON Suppliers.sid = Catalog.sid)
    INNER JOIN Parts ON Catalog.pid = Parts.pid)
WHERE
    Parts.color = 'red';

-- 4 Find the pnames of parts supplied by Acme Widget Suppliers and no one else.
SELECT 
    P.pname
FROM
    Parts P
        INNER JOIN
    Catalog C ON C.pid = P.pid
        INNER JOIN
    Suppliers S ON C.sid = S.sid
WHERE
    S.sname = 'Acme Widget Suppliers';

-- 5 Find the sids of suppliers who charge more for some part than the average cost of that part (averaged over all the suppliers who supply that part).

SELECT 
    S.sname Supplier,
    AVG(c.cost) averageCost,
    MAX(c.cost) supplierCost,
    P.pname,
    P.pid
FROM
    Parts P
        INNER JOIN
    Catalog C ON P.pid = C.pid
        INNER JOIN
    Suppliers S ON S.sid = C.sid
GROUP BY C.pid;	


-- For each part, ﬁnd the sname of the supplier who charges the most for that part.


SELECT 
    S.sname AS Supplier, P.pname AS pname, MAX(cost)
FROM
    Suppliers S
        INNER JOIN
    Catalog C ON S.sid = C.sid
        INNER JOIN
    Parts P ON P.pid = C.pid
GROUP BY S.sname

-- 7 Find the sids of suppliers who supply only red parts.
SELECT DISTINCT
    C.sid AS sid
FROM
    Catalog C
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            Parts P
        WHERE
            P.pid = C.pid AND P.color <> 'Red')

-- 8 Find the sids of suppliers who supply a red part and a green part.
SELECT DISTINCT
    C.sid
FROM
    Catalog C,
    Parts P
WHERE
    C.pid = P.pid AND P.color = 'Red'
 SELECT DISTINCT
    C1.sid
FROM
    Catalog C1,
    Parts P1
WHERE
    C1.pid = P1.pid AND P1.color = 'Green'

-- Find the sids of suppliers who supply a red part or a green part.
SELECT DISTINCT
    C.sid
FROM
    Catalog C,
    Parts P
WHERE
    C.pid = P.pid AND P.color = 'Red' 
UNION SELECT DISTINCT
    C1.sid
FROM
    Catalog C1,
    Parts P1
WHERE
    C1.pid = P1.pid AND P1.color = 'Green'

-- For every supplier that only supplies green parts, print the name of the supplier and the total number of parts that she supplies.


SELECT 
    COUNT(DISTINCT (C.pid)) NumParts, S.sname, C.pid, P.pname
FROM
    Catalog C
        INNER JOIN
    Parts P ON C.pid = P.pid
        INNER JOIN
    Suppliers S ON C.sid = S.sid
WHERE
    P.color = 'green'


-- 11 For every supplier that supplies a green part and a red part, print the name and price of the most expensive part that she supplies.
SELECT 
    S.sname AS sname, MAX(C.cost) AS most$$$
FROM
    Suppliers S,
    Parts P,
    Catalog C
WHERE
    P.pid = C.pid AND C.sid = S.sid
