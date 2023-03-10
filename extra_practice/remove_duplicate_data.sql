--------How to remove duplicate data in SQL Tutorial--------
"We will work through multiple ways to deal with duplicates"
-----Using "cars" Table with columns: |id|model|brand|color|make|-----

--REMOVE DUPLICATES from the following cars table.
--Duplicate record is identified based on the model and brand name. 

SELECT *
FROM cars
ORDER BY model, brand;

 -->> Solution 1. Delete using Unique Identifier.(Assuming there is only one duplicate)
 " First create a query that identifies duplicates"
SELECT model, brand, count(*)
FROM cars
GROUP BY model, brand
HAVING count(*) > 1;

 " Second modify query above to show max(id) to delete the second duplicate, this is assuming there is only one duplicate"
SELECT MAX(id)
FROM cars
GROUP BY model, brand
HAVING count(*) > 1;

 "Finaly  use above query as subquery and wrap in a delete statement"
 DELETE FROM cars
 WHERE id IN (
                SELECT MAX(id)
                FROM cars
                GROUP BY model, brand
                HAVING count(*) > 1
            );

-->> Solution 2. Using SELF JOIN (This may be used for multiple duplicates)
"First create query that idetifies duplicates using a self join.
To return duplicates only: we use where the id of first table is less than the id of second table."
SELECT c2.id
FROM cars c1
JOIN cars c2 on c1.model = c2.model and c1.brand =c2.brand
WHERE c1.id < c2.id;

"Finaly use above query as a subquery and wrap in a delete statement"
DELETE FROM cars
WHERE id IN (
                SELECT c2.id
                FROM cars c1
                JOIN cars c2 on c1.model = c2.model and c1.brand =c2.brand
                WHERE c1.id < c2.id
            );


-->> Solution 3. Using Window Function.(This may be used for multiple duplicates)
"First write statement to identify the duplicate records.
 The first record has row number 1 and the duplicate record has row number 2 or more"
SELECT *, ROW_NUMBER()OVER(PARTITiON BY model, brand) as rn
FROM cars

"Second create subquery using query above to give alias and use the row number as a filter"
SELECT *
FROM (
    SELECT *, ROW_NUMBER()OVER(PARTITiON BY model, brand) as rn
    FROM cars
    ) AS x
WHERE x.rn > 1;

"Finaly wrap above query in a delete statement"
DELETE FROM cars
WHERE id IN (
            SELECT *
            FROM (
                    SELECT *, ROW_NUMBER()OVER(PARTITiON BY model, brand) as rn
                    FROM cars
                ) AS x
            WHERE x.rn > 1;
            )
-->> Solution 4. Using Min Functions (Works with mutliple duplicates)
"First identify the original records.
These will be the records we want to keep
By setting Id to be the minimum we identify the first record as per columns "
SELECT model, brand, MIN(id)
FROM cars
GROUP BY model, brand

""

    
