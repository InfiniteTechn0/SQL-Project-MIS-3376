-- part 2

1. 

INSERT INTO customers (username, fname, lname, phone)
VALUES ('2264151', 'Michael', 'Tran', '(713) 543-6709');

2.

UPDATE horses
SET owner = '2264151'
WHERE name = 'Flash';

3.

-- intro to racing in summer 2024
INSERT INTO CourseCustomer (FKUsername, FKCourseID)
VALUES ('2264151', 'Sum24Race1-1');

-- intro to jumping in fall 2024
INSERT INTO CourseCustomer (FKUsername, FKCourseID)
VALUES ('2264151', 'Fall24Jump1-1');

-- part 3

1.

SELECT Name, Title, Salary
FROM Workers
WHERE Salary > 100000;

2.

SELECT *
FROM horses
WHERE weight >= 1800
AND Female;

3.

SELECT Name, Title
FROM Workers
WHERE Title LIKE 'Director%';

4.

SELECT * FROM horses
WHERE name LIKE '_r%';

5.

SELECT Name, Title
FROM Workers
WHERE TerminationDate IS NOT NULL

-- part 4

1.

SELECT Title, COUNT(*)
FROM Workers
GROUP BY Title
ORDER BY Title;

2.

SELECT Sex, ROUND(AVG(Weight), 1)
FROM horses
GROUP BY Sex;

3.

SELECT Color, COUNT(*) AS Count
FROM horses
GROUP BY Color
ORDER BY Count DESC;

4.

SELECT Color, Sex, COUNT(*)
FROM horses
GROUP BY Color, Sex
ORDER BY Color, Sex;

5.

SELECT Color, COUNT(*) AS COUNT
FROM horses
WHERE Sex = 'F' AND Spots IS NOT NULL
GROUP BY Color
ORDER BY COUNT DESC;

6.

SELECT Title, COUNT(*)
FROM workers
WHERE TerminationDate IS NULL
GROUP BY Title
ORDER BY Title;

7.

SELECT FKBarnID, COUNT(*) AS MaintCount
FROM stables
WHERE Status = 'Maintenance'
GROUP BY FKBarnID;

8.

SELECT Lname, COUNT(*) AS COUNT
FROM Customers
GROUP BY Lname
HAVING COUNT(*) >= 2
ORDER BY COUNT DESC;

9.

SELECT Title,
	ROUND(AVG(salary), 0) AS AVGSALSRY,
	MIN(salary) AS MINSALARY,
	MAX(salary) AS MAXSALARY,
	COUNT(*) AS EMPLOYEES
FROM Workers
GROUP BY Title
ORDER BY AVG(salary) DESC;

10.

SELECT COUNT(*) AS TotalHorses,
       COUNT(owner) AS OwnedHorses
FROM horses;

-- part 5

1.

SELECT name, fname, lname, phone
FROM horses
JOIN customers ON owner = username
WHERE sex = 'F' AND phone LIKE '(615)%'
ORDER BY name;	

2.

SELECT Coursename, name, Term, Year
FROM Courses
JOIN Topics ON FKTopicCode = TopicCode
JOIN workers ON FKEmpID = EmpID
WHERE Term = 'Summer' AND Year = '2024';

3.

SELECT Username, Fname, Lname, COUNT(*) AS COUNT
FROM Customers
JOIN horses ON username = owner
GROUP BY username, fname, lname
HAVING COUNT(*) >4
ORDER BY COUNT DESC;	

4.

SELECT CertName, name, title
FROM certifications
LEFT JOIN WorkerCert ON CertID = FKCertID
LEFT JOIN Workers ON FKEmpID = EmpID;

5.                                                                 ---------------------------------------------------

WITH OrgChart AS (
    SELECT EmpID, Name, Title, 0 AS Level
    FROM Workers
    WHERE Supervisor IS NULL AND TerminationDate IS NULL
    
    UNION ALL
    
    SELECT EmpID, Name, Title, Level + 1
    FROM Workers
    JOIN OrgChart ON Supervisor = EmpID
    WHERE TerminationDate IS NULL
)
SELECT LPAD(' ', Level*4) || Name AS Employee, Title
FROM OrgChart
ORDER BY Level, Name;

6.

SELECT name AS horsename, medname, dose, frequency
FROM Orders
JOIN horses ON ord_horsename = name
JOIN Medications ON ord_medcode = medcode
WHERE classification = 'Dewormer'
ORDER BY medname, name;

7.

SELECT DISTINCT w.Name
FROM Workers w
JOIN Courses c ON w.EmpID = c.FKEmpID
JOIN WorkerBarn wb ON w.EmpID = wb.FKEmpID;

-- part 6

1.

SELECT name, spots, color, owner
FROM horses
WHERE color = 'Red' AND spots = 'Yes';

2.

SELECT name, spots, color, owner
FROM horses
WHERE color = 'Red'
INTERSECT
select name, spots, color, owner
FROM horses
WHERE spots = 'Yes';

3.

SELECT name, spots, color, owner
FROM horses
WHERE color = 'Red' AND name IN (SELECT name FROM horses WHERE spots = 'Yes');

4.x

SELECT DISTINCT name
FROM workers
JOIN courses ON EmpID = FKEmpID
WHERE EmpID NOT IN (SELECT FKEmpID FROM WorkerCert WHERE FKCertID = 'TEA');

5.

SELECT DISTINCT name
FROM workers
JOIN courses ON EmpID = FKEmpID
MINUS
SELECT name
FROM workers
JOIN WorkerCert ON EmpID = FKEmpID
WHERE FKCertID = 'TEA';

6.

SELECT username, fname, lname, phone
FROM Customers
WHERE username NOT IN (SELECT FKUsername FROM CourseCustomer);

7.

SELECT username, fname, lname, phone
FROM Customers
LEFT JOIN CourseCustomer ON username = FKUsername
WHERE FKUsername IS NULL;

8.

SELECT username
FROM Customers
MINUS
SELECT FKUsername
FROM CourseCustomer;

-- part 7

1.

SELECT Name, 
	SUBSTR(Name, INSTR(Name, ' ') +1) || ', ' ||
	SUBSTR(Name, 1, INSTR(Name, ' ') -1) AS FormattedName
FROM Workers
WHERE Title = 'Ranch Hand';

2.

SELECT SUBSTR(Phone, 2, 3) AS AreaCode, COUNT(*)
FROM customers
GROUP BY SUBSTR(Phone, 2, 3)
ORDER BY COUNT(*) DESC;

3.

SELECT name, 
	'(' || SUBSTR(Phone, 1, 3) || ') ' ||
	SUBSTR(Phone, 4, 3) || '-' ||
	SUBSTR(Phone, 7, 4) AS FormattedPhone
FROM Workers;

4.

SELECT SUBSTR(Location, INSTR(Location, ', ') + 2) AS State, COUNT(*) AS Count
FROM Races
GROUP BY SUBSTR(Location, INSTR(Location, ', ') + 2);

5.

SELECT fname, lname,
	'(***) ***-' || SUBSTR(Phone, LENGTH(Phone) - 3) AS Mask
FROM Customers
WHERE lname LIKE 'A%' OR lname LIKE 'R%';

-- part 8 (Extra Credit)

1.

SELECT Description, ROUND(AVG(WorkerCount), 2) AS AvgWorkers
FROM barns
LEFT JOIN (
SELECT FKBarnID, COUNT(DISTINCT FKEmpID) AS WorkerCount
	FROM WorkerBarn
	GROUP BY FKBarnID
)
ON BarnID = FKBarnID
GROUP BY Description
ORDER BY AvgWorkers DESC;

2.                                                  ----------------------------------

WITH OrgChart AS (
	SELECT EmpID, Name, Title, 0 AS Level
	FROM Workers
    WHERE Supervisor IS NULL AND TerminationDate IS NULL
    
    UNION ALL
    
    SELECT w.EmpID, w.Name, w.Title, o.Level + 1
    FROM Workers w
    JOIN OrgChart o ON w.Supervisor = o.EmpID
    WHERE w.TerminationDate IS NULL
)
SELECT LPAD(' ', Level*2) || Name AS Employee, Title
FROM OrgChart
ORDER BY Level, Name;

3.

SELECT EmpID, Name, 
       TO_CHAR(HireDate, 'MM/DD/YYYY') AS HiredOn,
       TRUNC(MONTHS_BETWEEN(SYSDATE, HireDate)/12) AS YearsEmployed
FROM Workers
WHERE TerminationDate IS NULL
ORDER BY YearsEmployed DESC;

4.

SELECT CourseID, CourseName,
       Name AS Instructor,
       Title AS InstructorTitle,
       COUNT(FKUsername) AS Enrollment,
       ROUND(COUNT(FKUsername) * 100.0 / SizeLimit, 1) || '%' AS PercentFull
FROM Courses
JOIN Topics ON FKTopicCode = TopicCode
JOIN Workers ON FKEmpID = EmpID
LEFT JOIN CourseCustomer ON CourseID = FKCourseID
GROUP BY CourseID, CourseName, Name, Title, SizeLimit
ORDER BY CourseID;

5.

SELECT name AS Horse,
       fname || ' ' || lname AS Owner,
       year, place,
       RaceName
FROM HorseRaces
JOIN horses ON FKHorseName = name
JOIN races ON FKRaceID = RaceID
LEFT JOIN customers ON owner = username
WHERE place IN (1, 2, 3) AND year = 2021
ORDER BY RaceName, place;

6.

SELECT username, fname, lname, COUNT(*) AS TopFinishes
FROM customers
JOIN horses ON username = owner
JOIN HorseRaces ON name = FKHorseName
WHERE place <= 10 AND place IS NOT NULL
GROUP BY username, fname, lname
ORDER BY TopFinishes DESC;










