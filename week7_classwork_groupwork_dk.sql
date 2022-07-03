-- Classwork Week 7:Describe 5-10 different modes how data can be dirty.
-- 1. date format is not yyyy-mm-dd 
-- 2. there are whitespaces at the first position of some of the index names which are hard to see
-- 3. instead of integer values (1,2,3) there are strings in the db (one, two, three)
-- 4. there are different data types in the same columns
-- 5. duplicate data: the same data in different tables of the database
-- 6. instead of setting up a relation between two data and store them in different tables, they are crammed in the same table, making the table redundant and long
-- 7. missing data


-- Write a subquery that finds the film_id, title, and replacement_cost for each film 
-- where the replacement_cost is greater than the average. 
select film_id, title, replacement_cost
from film 
where replacement_cost >
(select avg(replacement_cost) from film)
order by film_id
limit (20);
 film_id |            title            | replacement_cost
---------+-----------------------------+------------------
       1 | Academy Dinosaur            |            20.99
       4 | Affair Prejudice            |            26.99
       5 | African Egg                 |            22.99
       7 | Airplane Sierra             |            28.99
       9 | Alabama Devil               |            21.99
      10 | Aladdin Calendar            |            24.99
      12 | Alaska Phantom              |            22.99
      13 | Ali Forever                 |            21.99
      14 | Alice Fantasia              |            23.99
      16 | Alley Evolution             |            23.99
      18 | Alter Victory               |            27.99
      19 | Amadeus Holy                |            20.99
      20 | Amelie Hellfighters         |            23.99
      24 | Analyze Hoosiers            |            19.99
      30 | Anything Savannah           |            27.99
      34 | Arabia Dogma                |            29.99
      35 | Arachnophobia Rollercoaster |            24.99
      37 | Arizona Bang                |            28.99
      38 | Ark Ridgemont               |            25.99
      40 | Army Flintstones            |            22.99


-- Look at the DVD rental data model, and identify two relationships clearly. Is it correct? Does it make sense?

-- One-to-one: film.film_id and film.title: every film has exactly one ID and one title
-- one-to-many: inventory to rental: one copy of a film  has one inventory_id but several rentals can belong to this inventory_id
-- many-to-many: film_id and actor_id: one actor can play in multiple films and one film has multiple actors

-- Create a table in the default postgres database (called “postgres”) called either “cats” or “dogs”. 
-- Include at least three columns in your create statement. 
CREATE TABLE cats (
            id int, -- integer
            name varchar(50),
            breed varchar(50), 
            gender varchar (6),
            dateofbirth TIMESTAMP 
            );
insert into cats (name, breed, gender, dateofbirth) values ('Butternut', 'ragdoll', 'female', '2018-06-24');