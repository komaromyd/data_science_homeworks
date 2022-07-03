
 

-- Q1. Create a new column called “status” in the rental table (yes, add a permanent column) that uses a case statement to indicate if a film was returned late, early, or on time. 
ALTER TABLE rental
ADD COLUMN status text;

UPDATE rental as r
SET  status = 
            CASE 
                WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) < f.rental_duration THEN 'Early' 
                WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) > f.rental_duration THEN 'Late' 
                ELSE 'On time' 
                END                                                                                                   
FROM film as f, inventory as i
WHERE f.film_id=i.film_id AND i.inventory_id=r.inventory_id; 

--Q2. Show the total payment amounts for people who live in Kansas City or Saint Louis. 
SELECT 
  customer.first_name, customer.last_name, city.city, customer.customer_id, sum(payment.amount)
  from city
    full join address
        on city.city_id = address.city_id
    full join customer
        on address.address_id=customer.address_id
    full join payment 
        on customer.customer_id=payment.customer_id
    where city.city in ('Kansas City', 'Saint Louis')
    group by (customer.customer_id, city.city) ;


  first_name | last_name |    city     | customer_id |  sum
------------+-----------+-------------+-------------+-------
 Joan       | Cooper    | Saint Louis |          62 | 78.79
 Thomas     | Grigsby   | Kansas City |         308 | 81.81

--Q3 How many films are in each category? Why do you think there is a table for category and a table for film category?

SELECT c.category_id, c.name, COUNT(f.film_id) AS nr_films_per_cat
FROM category AS c
LEFT JOIN film_category AS fc 
    ON c.category_id=fc.category_id
LEFT JOIN film AS f
    ON fc.film_id=f.film_id
GROUP BY c.category_id
ORDER BY c.category_id;

 category_id |    name     | nr_films_per_cat
-------------+-------------+------------------
           1 | Action      |               64
           2 | Animation   |               66
           3 | Children    |               60
           4 | Classics    |               57
           5 | Comedy      |               58
           6 | Documentary |               68
           7 | Drama       |               62
           8 | Family      |               69
           9 | Foreign     |               73
          10 | Games       |               61
          11 | Horror      |               56
          12 | Music       |               51
          13 | New         |               63
          14 | Sci-Fi      |               61
          15 | Sports      |               74
          16 | Travel      |               57

-- 4.	Show a roster for the staff that includes their email, address, city, and country (not ids)
select staff.first_name, staff.last_name, staff.email, address.address, city.city, country.country
from staff
left join address
    on staff.address_id=address.address_id
left join city
    on address.city_id=city.city_id
left join country
    on city.country_id=country.country_id;

    first_name | last_name |            email             |       address        |    city    |  country
------------+-----------+------------------------------+----------------------+------------+-----------
 Mike       | Hillyer   | Mike.Hillyer@sakilastaff.com | 23 Workhaven Lane    | Lethbridge | Canada
 Jon        | Stephens  | Jon.Stephens@sakilastaff.com | 1411 Lillydale Drive | Woodridge  | Australia

-- 5.	Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005
select film.film_id, film.title, film.length
from film 
left join inventory 
    on film.film_id=inventory.film_id
left join rental
    on inventory.inventory_id=rental.inventory_id
where rental.return_date between '2005-05-15' and '2005-05-31'
group by (film.film_id)
order by (film.film_id)
limit 20;
film_id |        title         | length
---------+----------------------+--------
       8 | Airport Pollock      |     54
      15 | Alien Center         |     46
      18 | Alter Victory        |     57
      19 | Amadeus Holy         |    113
      21 | American Circus      |    129
      30 | Anything Savannah    |     82
      31 | Apache Divine        |     92
      40 | Army Flintstones     |    148
      43 | Atlantis Cause       |    170
      45 | Attraction Newton    |     83
      48 | Backlash Undefeated  |    118
      50 | Baked Cleopatra      |    182
      52 | Ballroom Mockingbird |    173
      54 | Banger Pinocchio     |    113
      58 | Beach Heartbreakers  |    122
      68 | Betrayed Rear        |    122
      73 | Bingo Talented       |    150
      80 | Blanket Beverly      |    148
      81 | Blindness Gun        |    103
      83 | Blues Instinct       |     50
-- 6.	Write a subquery to show which movies are rented below the average price for all movies

-- First we'll see whether rental rate and payment amount are the same
select film.film_id, film.title, round(avg(film.rental_rate),2) as avg_rate, round(avg(payment.amount),2) as avg_amount
from film
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id
    LEFT JOIN payment
        ON rental.rental_id= payment.rental_id
        group by film.film_id
        order by film.film_id
        limit 20;
        film_id |            title            | avg_rate | avg_amount
---------+-----------------------------+----------+------------
       1 | Academy Dinosaur            |     0.99 |       1.61
       2 | Ace Goldfinger              |     4.99 |       7.56
       3 | Adaptation Holes            |     2.99 |       3.17
       4 | Affair Prejudice            |     2.99 |       3.99
       5 | African Egg                 |     2.99 |       4.35
       6 | Agent Truman                |     2.99 |       5.88
       7 | Airplane Sierra             |     4.99 |       5.52
       8 | Airport Pollock             |     4.99 |       5.79
       9 | Alabama Devil               |     2.99 |       5.99
      10 | Aladdin Calendar            |     4.99 |       5.73
      11 | Alamo Videotape             |     0.99 |       1.40
      12 | Alaska Phantom              |     0.99 |       1.64
      13 | Ali Forever                 |     4.99 |       6.10
      14 | Alice Fantasia              |     0.99 |
      15 | Alien Center                |     2.99 |       4.24
      16 | Alley Evolution             |     2.99 |       3.61
      17 | Alone Trip                  |     0.99 |       3.64
      18 | Alter Victory               |     0.99 |       1.54
      19 | Amadeus Holy                |     0.99 |       1.64
      20 | Amelie Hellfighters         |     4.99 |       6.79

      -- nope

select film_id, title, film.rental_rate
from film
where film.rental_rate <
(select avg(film.rental_rate) from film)
;
film_id |          title          | rental_rate
---------+-------------------------+-------------
       1 | Academy Dinosaur        |        0.99
      11 | Alamo Videotape         |        0.99
      12 | Alaska Phantom          |        0.99
     213 | Date Speed              |        0.99
      14 | Alice Fantasia          |        0.99
      17 | Alone Trip              |        0.99
      18 | Alter Victory           |        0.99
      19 | Amadeus Holy            |        0.99
      23 | Anaconda Confessions    |        0.99
      26 | Annie Identity          |        0.99
      27 | Anonymous Human         |        0.99
      34 | Arabia Dogma            |        0.99
      36 | Argonauts Town          |        0.99
      38 | Ark Ridgemont           |        0.99
      39 | Armageddon Lost         |        0.99
      40 | Army Flintstones        |        0.99
      41 | Arsenic Independence    |        0.99
      52 | Ballroom Mockingbird    |        0.99
      54 | Banger Pinocchio        |        0.99
      63 | Bedazzled Married       |        0.99
      64 | Beethoven Exorcist      |        0.99
      66 | Beneath Rush            |        0.99
      76 | Birdcage Casper         |        0.99
      79 | Blade Polish            |        0.99
      82 | Blood Argonauts         |        0.99
      85 | Bonnie Holocaust        |        0.99
      87 | Boondock Ballroom       |        0.99
      89 | Borrowers Bedazzled     |        0.99

--Q7.	Write a join statement to show which movies are rented below the average price for all movies.

-- Q8.Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.
-- Explain plan on Q6:
EXPLAIN (ANALYZE, BUFFERS)
select film_id, title, rental_rate from film
where rental_rate < 
    (SELECT avg(rental_rate) from film);

                                                            QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
 Seq Scan on film  (cost=66.51..133.01 rows=333 width=25) (actual time=0.376..0.590 rows=341 loops=1)
   Filter: (rental_rate < $0)
   Rows Removed by Filter: 659
   Buffers: shared hit=108
   InitPlan 1 (returns $0)
     ->  Aggregate  (cost=66.50..66.51 rows=1 width=32) (actual time=0.354..0.355 rows=1 loops=1)
           Buffers: shared hit=54
           ->  Seq Scan on film film_1  (cost=0.00..64.00 rows=1000 width=6) (actual time=0.006..0.154 rows=1000 loops=1)
                 Buffers: shared hit=54
 Planning Time: 0.161 ms
 Execution Time: 0.640 ms


 -- Q9.	With a window function, write a query that shows the film, its duration, and what percentile the duration fits into. 
 select count(*) from film;
  count
-------
  1000
(1 row)
-- from now on, we know that the overall number of films is 1000. Hence, instead of 100*count(length)/count(*) we can write 0.1*count(length).
-- This is important because I cannot convince postgresql to calculate 100*count(length)/count(*) in floats, no matter how hard I try
 with t2 AS 
    (SELECT length, 
            SUM(0.1*COUNT(length)) OVER(ORDER BY length ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS percentile
    FROM film AS f
    GROUP BY length
    ORDER BY length) 
SELECT f.title, f.length, t2.percentile FROM film AS f
LEFT JOIN t2
    ON f.length=t2.length
ORDER BY title;

            title            | length | percentile
-----------------------------+--------+------------
 Academy Dinosaur            |     86 |       30.4
 Ace Goldfinger              |     48 |        2.3
 Adaptation Holes            |     50 |        3.7
 Affair Prejudice            |    117 |       52.0
 African Egg                 |    130 |       61.4
 Agent Truman                |    169 |       87.6
 Airplane Sierra             |     62 |       12.0
 Airport Pollock             |     54 |        6.6
 Alabama Devil               |    114 |       50.4
 Aladdin Calendar            |     63 |       12.9
 Alamo Videotape             |    126 |       58.9
 Alaska Phantom              |    136 |       65.6
 Ali Forever                 |    150 |       75.8
 Alice Fantasia              |     94 |       35.4
 Alien Center                |     46 |        0.5
 Alley Evolution             |    180 |       96.1
 Alone Trip                  |     82 |       26.3
 Alter Victory               |     57 |        8.0
 Amadeus Holy                |    113 |       49.4
 Amelie Hellfighters         |     79 |       24.3
 American Circus             |    129 |       60.8
 Amistad Midsummer           |     85 |       29.9
 Anaconda Confessions        |     92 |       34.2
 Analyze Hoosiers            |    181 |       97.1
 Angels Life                 |     74 |       20.8
 Annie Identity              |     86 |       30.4
 Anonymous Human             |    179 |       95.4
 Anthem Luke                 |     91 |       33.1
 Antitrust Tomatoes          |    168 |       87.0
 Anything Savannah           |     82 |       26.3
 Apache Divine               |     92 |       34.2
 Apocalypse Flamingos        |    119 |       53.4
 Apollo Teen                 |    153 |       78.3
 Arabia Dogma                |     62 |       12.0
 Arachnophobia Rollercoaster |    147 |       73.7
 Argonauts Town              |    127 |       59.4
 Arizona Bang                |    121 |       55.1
 Ark Ridgemont               |     68 |       16.0

-- 10. The difference between set-based and procedural programming:
-- Procedural programming, e.g. Python: requires the description of how you want to get the results, with the aid of loops, conditionals etc.
-- Procedural programming requires more CPU time.
-- Set-based programming: only requires you to determine WHAT you would liek to achieve. Uses less CPU time.
-- (But behind SQL there is a procedural programming language, i.e. it was written in C)