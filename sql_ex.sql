
-- 1. Find the model number, speed AND hard drive capacity for ALL the PCs WITH prices below $500.Result set: model, speed, hd.
SELECT model, speed, hd 
FROM PC
WHERE price < 500

-- 2. List ALL printer makers. Result set: maker.

SELECT DISTINCT maker AS Maker
FROM Product
WHERE TYPE = 'Printer';

-- 3. Find the model number, RAM AND screen size of the laptops WITH prices over $1000.

SELECT model, ram, screen 
FROM Laptop
WHERE price > 1000

-- 4. Find ALL records FROM the Printer table containing data about color printers.
SELECT *
FROM Printer
WHERE color = 'y'

-- 5. Find the model number, speed AND hard drive capacity of PCs cheaper than $600 HAVING a 12x OR a 24x CD drive.
SELECT model, speed, hd
FROM PC
WHERE (cd = '12x' OR cd = '24x') AND price < 600

-- 6. For each maker producing laptops WITH a hard drive capacity of 10 Gb OR higher, find the speed of such laptops. Result set: maker, speed.
SELECT DISTINCT Product.maker, Laptop.speed
FROM Product LEFT JOIN Laptop 
ON Laptop.model = Product.model
WHERE hd >= 10

-- 7. Find out the models AND prices for ALL the products (of any TYPE) produced BY maker B.
SELECT PC.model, price 
FROM PC 
JOIN Product 
ON Product.model=PC.model 
WHERE maker ='B'
Union
SELECT Laptop.model, price 
FROM Laptop 
JOIN Product 
ON Product.model = Laptop.model 
WHERE maker = 'B'
Union
SELECT Printer.model, price 
FROM Printer 
JOIN Product 
ON Product.model = Printer.model 
WHERE maker = 'B'

-- 8. Find the makers producing PCs but NOT laptops.
SELECT maker 
FROM Product
WHERE TYPE IN ('PC')
EXCEPT
SELECT maker 
FROM Product 
WHERE TYPE IN ('Laptop')

SELECT DISTINCT maker
FROM Product
WHERE TYPE = 'PC'
AND maker NOT IN (
	SELECT DISTINCT maker
	FROM Product
	WHERE TYPE = 'Laptop'
)

-- 9. Find the makers of PCs WITH a processor speed of 450 MHz OR more. Result set: maker.
SELECT maker AS Maker
FROM Product LEFT JOIN PC 
ON Product.model = PC.model
WHERE PC.speed >= 450
GROUP BY maker

-- 10. Find the printer models HAVING the highest price. Result set: model, price.
SELECT model, price
FROM Printer
WHERE price = (
	SELECT MAX(price) 
	FROM Printer
)

-- 11. Find out the average speed of PCs.
SELECT AVG(speed)
FROM PC

-- 12. Find out the average speed of the laptops priced over $1000.
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000

-- 13. Find out the average speed of the PCs produced BY maker A.
SELECT AVG(PC.speed)
FROM Product LEFT JOIN PC 
ON PC.model = Product.model
WHERE Product.maker = 'A'
-- 14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT cl.class, sh.name, cl.country
FROM Ships AS sh, Classes AS cl
WHERE sh.class = cl.class
AND numGuns >= 10
-- 15. Get hard drive capacities that are identical for two OR more PCs. Result set: hd.
SELECT hd
FROM PC
GROUP BY hd
HAVING COUNT(hd) >= 2
-- 16. Get pairs of PC models WITH identical speeds AND the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but NOT (j, i). 
-- Result set: model WITH the bigger number, model WITH the smaller number, speed, AND RAM.
SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram
FROM PC AS pc1 JOIN PC AS pc2
ON pc1.speed = pc2.speed 
AND pc1.ram = pc2.ram
WHERE pc1.model > pc2.model
-- 17. Get the laptop models that have a speed smaller than the speed of any PC. Result set: TYPE, model, speed.
SELECT DISTINCT pr.TYPE AS Type, l.model AS Model, l.speed
FROM Product AS pr JOIN Laptop AS l
ON pr.model = l.model
WHERE l.speed < ALL (
	SELECT speed
	FROM PC
)
-- 18. Find the makers of the cheapest color printers.Result set: maker, price.
SELECT DISTINCT Product.maker, Printer.price 
FROM Product JOIN Printer 
ON Product.model = Printer.model 
WHERE Printer.color = 'y' 
AND Printer.price = (
	SELECT MIN(price)
	FROM Printer
	WHERE color = 'y'
)

-- 19. For each maker HAVING models IN the Laptop table, find out the average screen size of the laptops he produces. Result set: maker, average screen size.
SELECT pr.maker, AVG(l.screen)
FROM Product AS pr 
JOIN Laptop AS l 
ON pr.model= l.model
GROUP BY pr.maker

-- 20. Find the makers producing at least three DISTINCT models of PCs. Result set: maker, number of PC models.
SELECT maker, COUNT(model)
FROM Product
WHERE TYPE = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3

-- 21. Find out the maximum PC price for each maker HAVING models IN the PC table. Result set: maker, maximum price.
SELECT pr.maker, MAX(DISTINCT pc.price)
FROM Product AS pr
JOIN PC AS pc
ON pr.model= pc.model
GROUP BY pr.maker

-- 22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs WITH identical speeds. Result set: speed, average price.
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed

--23. Get the makers producing both PCs HAVING a speed of 750 MHz OR higher AND laptops WITH a speed of 750 MHz OR higher. Result set: maker
SELECT DISTINCT maker
FROM Product
WHERE maker IN (
	SELECT DISTINCT maker 
	FROM Product AS pr
	JOIN PC AS pc
	ON pr.model = pc.model
	WHERE pc.speed >= 750
)
AND maker IN (
	SELECT DISTINCT maker 
	FROM Product AS pr 
	JOIN Laptop AS l
	ON pr.model = l.model
	WHERE l.speed >= 750
)
--24. List the models of any TYPE HAVING the highest price of ALL products present IN the database.
WITH MAX
AS (
	SELECT model, price FROM PC
	UNION 
	SELECT model, price FROM Laptop
	UNION 
	SELECT model, price FROM printer
)

SELECT model FROM MAX
WHERE price = (
	SELECT MAX(price) 
	FROM MAX
)

--25. Find the printer makers also producing PCs WITH the lowest RAM capacity AND the highest processor speed of ALL PCs HAVING the lowest RAM capacity. Result set: maker.
SELECT DISTINCT maker
FROM Product JOIN PC
ON Product.model = PC.model
WHERE ram = (
	SELECT MIN(ram)
	FROM PC
)
AND speed = (
	SELECT MAX(speed)
	FROM PC
	WHERE ram = (
		SELECT MIN(ram)
		FROM PC)
	)
AND maker IN (
	SELECT maker
	FROM Product
	WHERE TYPE='Printer'
)

-- 26. Find out the average price of PCs AND laptops produced BY maker A. Result set: one overall average price for ALL items.
SELECT AVG(price)
FROM (
	SELECT price
	FROM Product JOIN PC
	ON Product.model = PC.model
	WHERE maker = 'A'
	UNION ALL
	SELECT price
	FROM Product JOIN Laptop
	ON Product.model = Laptop.model
	WHERE maker='A'
) AS AVG_price
--27. Find out the average hard disk drive capacity of PCs produced BY makers who also manufacture printers. Result set: maker, average HDD capacity.
SELECT pr.maker, AVG(pc.hd)
FROM Product AS pr JOIN PC AS pc 
ON pr.model = pc.model
WHERE maker IN (
	SELECT DISTINCT maker
	FROM Product
	WHERE TYPE='Printer'
)
GROUP BY maker

-- 28. Using Product table, find out the number of makers who produce only one model.
WITH total_count
AS (
	SELECT maker
	FROM product 
	GROUP BY maker 
	HAVING COUNT(model) = 1
)

SELECT COUNT(maker)
FROM total_count

--29. Under the assumption that receipts of money (inc) AND payouts (out) are registered NOT more than once a day for each collection point 
-- [i.e. the primary key consists of (point, date)], 
-- write a query displaying cash flow data (point, date, income, expense). Use Income_o AND Outcome_o tables.
SELECT i.point, i.date, i.inc, o.out
FROM Income_o i LEFT JOIN Outcome_o o
ON i.point = o.point
AND i.date = o.date

UNION
SELECT o.point, o.date, i.inc, o.out
FROM Outcome_o o LEFT JOIN Income_o i
ON o.point = i.point
AND o.date = i.date
-- 30. Under the assumption that receipts of money (inc) AND payouts (out) can be registered any number of times a day for each collection point 
-- [i.e. the code column IS the primary key], display a table WITH one corresponding row for each operating date of each collection point.
-- Result set: point, date, total payout per day (out), total money intake per day (inc). Missing values are considered to be NULL.
SELECT i.point, i.date, o.out, i.inc
FROM (
	SELECT point, date, sum(inc) AS inc
	FROM Income
	GROUP BY point, date
) AS i
LEFT JOIN (
	SELECT point, date, sum(out) AS out
	FROM Outcome
	GROUP BY point, date
) AS o
ON i.point = o.point
AND i.date = o.date

UNION
SELECT o.point, o.date, o.out, i.inc
FROM (
	SELECT point, date, sum(out) AS out
	FROM Outcome
	GROUP BY point, date
) AS o
LEFT JOIN (
	SELECT point, date, sum(inc) AS inc
	FROM Income
	GROUP BY point, date
) AS i
ON o.point = i.point
AND o.date = i.date

-- 31. For ship classes WITH a gun caliber of 16 IN. OR more, display the class AND the country.
SELECT class, country
FROM Classes
WHERE bore >= 16.0

-- 32. One of the characteristics of a ship IS one-half the cube of the calibre of its main guns (mw). Determine the average.
WITH total 
AS (
	SELECT country, bore, name
	FROM Classes JOIN Ships
	ON Classes.class = Ships.class
	
	UNION
	SELECT country, bore, ship
	FROM Classes JOIN Outcomes
	ON Classes.class = Outcomes.ship
)

SELECT country, cast(round(AVG(power(bore,3)*0.5),2) AS numeric(10,2)) AS weight 
FROM total
GROUP BY country

-- 33. Get the ships sunk IN the North Atlantic battle. Result set: ship.
SELECT ship
FROM Outcomes
WHERE result = 'sunk'
AND battle = 'North Atlantic'

-- 34. In accordance WITH the Washington Naval Treaty concluded IN the beginning of 1922, it was prohibited to build battle ships WITH a displacement of more than 35 thousand tons. 
-- Get the ships violating this treaty (only consider ships for which the year of launch IS known). List the names of the ships.
SELECT DISTINCT name 
FROM Classes AS cl JOIN Ships AS sh 
ON cl.class = sh.class 
WHERE launched >= 1922 
AND displacement > 35000
AND TYPE = 'bb'

-- 35. Find models IN the Product table consisting either of digits only OR Latin letters (A-Z, CASE insensitive) only. Result set: model, TYPE.
SELECT model, TYPE
FROM Product
WHERE model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^a-z]%'
OR model NOT LIKE '%[^A-Z]%'

-- 36. List the names of lead ships IN the database (including the Outcomes table).
SELECT name
FROM Ships
WHERE name IN (
	SELECT class
	FROM Classes
)

UNION
SELECT ship
FROM Outcomes
WHERE ship IN (
	SELECT class
	FROM Classes
)

-- 37. Find classes for which only one ship exists IN the database (including the Outcomes table).
WITH total_ship
AS (
	SELECT cl.class, sh.name
	Classes AS cl JOIN Ships AS sh
	ON cl.class = sh.class
	
	UNION
	SELECT cl.class, o.ship AS name
	FROM Classes AS cl JOIN Outcomes AS o
	ON cl.class = o.ship
)

SELECT class 
FROM total_ship 
GROUP BY class 
HAVING COUNT(class) = 1

-- 38. Find countries that ever had classes of both battleships (‘bb’) AND cruisers (‘bc’).
SELECT DISTINCT country
FROM Classes
WHERE TYPE = 'bb'
AND country IN (
	SELECT DISTINCT country
	FROM Classes
	WHERE TYPE = 'bc'
)

-- 39. Find the ships that "survived for future battles"; that IS, after being damaged IN a battle, they participated IN another one, which occurred later.
SELECT DISTINCT o2.ship 
FROM (
	SELECT ship, battle, result, date
	FROM Outcomes JOIN Battles
	ON Outcomes.battle = Battles.name
	WHERE result='damaged'
) AS o1 
JOIN (
	SELECT ship, battle, result, date
	FROM Outcomes JOIN Battles
	ON Outcomes.battle = Battles.name
) AS o2
ON o1.ship = o2.ship
WHERE o1.date < o2.date
-- 40. Get the makers who produce only one product type and more than one model. Output: maker, type.
SELECT DISTINCT maker, MAX(TYPE) AS TYPE
FROM Product
GROUP BY maker
HAVING COUNT(DISTINCT TYPE) = 1 
AND COUNT(model) > 1
-- 41. For each maker who has models at least in one of the tables PC, Laptop, or Printer, determine the maximum price for his products.
Output: maker; if there are NULL values among the prices for the products of a given maker, display NULL for this maker, otherwise, the maximum price.

SELECT
  pro.maker,
  NULLIF(MAX(COALESCE(pri.price, 922337203685477)), 922337203685477) as price
FROM
  product pro
  INNER JOIN
  (
    SELECT model, price FROM printer
    UNION ALL
    SELECT model, price FROM pc
    UNION ALL
    SELECT model, price FROM laptop
  ) pri 
  ON pri.model = pro.model
GROUP BY pro.maker
-- 42. Find the names of ships sunk at battles, along WITH the names of the corresponding battles.
SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk'

-- 43. Get the battles that occurred IN years when no ships were launched into water.
SELECT name
FROM Battles
WHERE year(date)
NOT IN (
	SELECT launched
	FROM Ships
	WHERE launched IS NOT NULL
)

-- 44. Find ALL ship names beginning WITH the letter R.
SELECT name
FROM Ships
WHERE name LIKE 'R%'
UNION
SELECT ship
FROM Outcomes
WHERE ship LIKE 'R%'

-- 45. Find ALL ship names consisting of three OR more words (e.g., King George V). Consider the words IN ship names to be separated BY single spaces, 
-- AND the ship names to have no leading OR trailing spaces.
SELECT name
FROM Ships
WHERE name LIKE '% % %'
UNION
SELECT ship
FROM Outcomes
WHERE ship LIKE '% % %'

-- 46. For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
SELECT ship, displacement, numGuns
FROM (
	SELECT ship, battle, 
    -- if class is null then ship
    COALESCE(class, ship) AS class
	FROM outcomes
		LEFT JOIN ships ON outcomes.ship = ships.name
	WHERE battle = 'Guadalcanal'
) t
	LEFT JOIN classes ON t.class = classes.class
-- 47. Find the countries that have lost all their ships in battles.
WITH ALL_SHIPS AS (
 SELECT ship, country from outcomes o
 JOIN classes c ON (c.class = o.ship)
 UNION
 SELECT name, country FROM ships s
 JOIN classes c ON (c.class = s.class)
),
SHIPS_PER_COUNTRY AS (
 SELECT country, COUNT(ship) count FROM ALL_SHIPS
 GROUP BY country
),
SHIPS_SUNK AS (
 SELECT ship, result FROM outcomes
 WHERE result = 'sunk'
),
SHIPS_SUNKED_PER_COUNTRY AS (
 SELECT aships.country, COUNT(ssunk.result) count FROM ALL_SHIPS aships
 JOIN SHIPS_SUNK ssunk ON (ssunk.ship = aships.ship)
 GROUP BY aships.country
)
SELECT spc.country FROM SHIPS_PER_COUNTRY spc
JOIN SHIPS_SUNKED_PER_COUNTRY sspc ON (sspc.country = spc.country)
WHERE spc.count = sspc.count
-- 48. Find the ship classes HAVING at least one ship sunk IN battles.
SELECT DISTINCT Classes.class
FROM Classes, Ships, Outcomes
WHERE Classes.class = Ships.class
AND Ships.name = Outcomes.ship
AND Outcomes.result = 'sunk'

UNION
SELECT DISTINCT class
FROM Classes, Outcomes
WHERE Classes.class = Outcomes.ship
AND Outcomes.result = 'sunk'

-- 49. Find the names of the ships HAVING a gun caliber of 16 inches (including ships IN the Outcomes table).
SELECT name
FROM Ships, Classes
WHERE Ships.class = Classes.class
AND bore = 16

UNION
SELECT ship
FROM Outcomes, Classes
WHERE Outcomes.ship = Classes.class
AND bore = 16
-- 50. Find the battles in which Kongo-class ships from the Ships table were engaged.
SELECT distinct battle
FROM Outcomes, Ships
WHERE ships.name = outcomes.ship
AND class = 'Kongo'
