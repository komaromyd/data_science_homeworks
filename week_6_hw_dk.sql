
--1.	Show all customers whose last names start with T. Order them by first name from A-Z.
SELECT customer_id, last_name, first_name
FROM customer
WHERE  last_name LIKE 'T%'
ORDER BY first_name;

 customer_id | last_name | first_name
-------------+-----------+------------
         485 | Tobias    | Clyde
          17 | Thompson  | Donna
          10 | Taylor    | Dorothy
         513 | Tubbs     | Duane
         434 | Tomlin    | Eddie
         514 | Troutman  | Franklin
         486 | Talbert   | Glen
         265 | Terry     | Jennie
         395 | Turpin    | Johnny
          67 | Torres    | Kelly
         327 | Thrasher  | Larry
         542 | Tirado    | Lonnie
          44 | Turner    | Marie
         128 | Tucker    | Marjorie
         583 | Thorn     | Marshall
          12 | Thomas    | Nancy
         311 | Trout     | Paul
         584 | Teel      | Salvador
         386 | Tan       | Todd
         370 | Truong    | Wayne
(20 rows)


--2.	Show all rentals returned from 5/28/2005 to 6/1/2005

SELECT rental_id, rental_date 
FROM rental 
WHERE rental_date BETWEEN '2005-05-28' and '2005-06-01' 
ORDER BY rental_date 
LIMIT 10;
 rental_id |     rental_date
-----------+---------------------
       487 | 2005-05-28 00:00:30
       488 | 2005-05-28 00:07:50
       489 | 2005-05-28 00:09:12
       490 | 2005-05-28 00:09:56
       491 | 2005-05-28 00:13:35
       492 | 2005-05-28 00:24:58
       493 | 2005-05-28 00:34:11
       494 | 2005-05-28 00:39:31
       495 | 2005-05-28 00:40:48
       496 | 2005-05-28 00:43:41
(10 rows)

SELECT rental_id, rental_date 
FROM rental 
WHERE rental_date BETWEEN '2005-05-28' and '2005-06-01' 
ORDER BY rental_date DESC
LIMIT 10;
rental_id |     rental_date
-----------+---------------------
      1157 | 2005-05-31 22:47:45
      1156 | 2005-05-31 22:37:34
      1155 | 2005-05-31 22:17:11
      1154 | 2005-05-31 21:42:09
      1153 | 2005-05-31 21:36:44
      1152 | 2005-05-31 21:32:17
      1151 | 2005-05-31 21:29:00
      1150 | 2005-05-31 21:20:09
      1149 | 2005-05-31 21:03:17
      1148 | 2005-05-31 20:38:40

-- 3.	How would you determine which movies are rented the most?
SELECT film.title, count(film.title) as rent_number    -- selecting only the required field and the corresponding count
FROM film                                              -- join first the film table to the inventory table (no direct connection between film and rentals)
    INNER JOIN inventory
            on film.film_id=inventory.film_id           --film_id is the join column
    INNER JOIN rental                                   -- join next the merged tables with the rental table on the inventory ID
            on inventory.inventory_id=rental.inventory_id
    GROUP BY film.title                       -- In the join table we have all rental events, most films will have more than one rental event. In order to get the number of rental events per film, we want first to group these events per film... 
    ORDER BY count(film.title) DESC            -- ... then display the counts of rental event per film. Finally, we order teh table by rent_number in order to see which were rented the most
    LIMIT 20;                

         title        | rent_number
---------------------+-------------
 Bucket Brotherhood  |          34
 Rocketeer Mother    |          33
 Scalawag Duck       |          32
 Grit Clockwork      |          32
 Ridgemont Submarine |          32
 Forward Temple      |          32
 Juggler Hardly      |          32
 Hobbit Alien        |          31
 Apache Divine       |          31
 Goodfellas Salute   |          31
 Rush Goodfellas     |          31
 Robbers Joon        |          31
 Zorro Ark           |          31
 Network Peak        |          31
 Wife Turn           |          31
 Timberland Sky      |          31
 Butterfly Chocolat  |          30
 Witches Panic       |          30
 Cat Coneheads       |          30
 Rugrats Shakespeare |          30

 Q4
 -- Show how much each customer spent on movies (for all time) . Order them from least to most.

SELECT customer.first_name, customer.last_name, sum(payment.amount) -- selecting only the name and the corresponding sum of payments
FROM customer                               
    INNER JOIN payment
            ON customer.customer_id=payment.customer_id             -- join the customer table and the payment table on the customer ID
    GROUP BY (customer.customer_id)                                  -- group all payments by customer so that the payments from the same customer are in the same group 
    ORDER BY sum(payment.amount)                                     -- order them by the payment sum
    LIMIT 20;   

 first_name |  last_name  |  sum
------------+-------------+-------
 Brian      | Wyman       | 27.93
 Leona      | Obrien      | 32.90
 Caroline   | Bowman      | 37.87
 Anthony    | Schwab      | 47.85
 Tiffany    | Jordan      | 49.88
 Kirk       | Stclair     | 50.83
 Bobbie     | Craig       | 52.81
 Jo         | Fowler      | 54.85
 Penny      | Neal        | 56.84
 Johnny     | Turpin      | 57.81
 Sheila     | Wells       | 57.86
 Katherine  | Rivera      | 57.87
 Mattie     | Hoffman     | 58.80
 Annie      | Russell     | 58.82
 Jill       | Hawkins     | 58.83
 Lauren     | Hudson      | 59.83
 Anita      | Morales     | 59.86
 Scott      | Shelley     | 60.82
 Tony       | Carranza    | 62.81
 Nelson     | Christenson | 62.84

             
Q5
-- 5.Which actor was in the most movies in 2006 (based on this dataset)? 
-- Be sure to alias the actor name and count as a more descriptive name. 
-- Order the results from most to least

SELECT actor.first_name as actor_first_name, actor.last_name as actor_last_name, count(film.film_id) as number_movies_played_in_2006  
FROM actor                              
    LEFT JOIN film_actor
            on actor.actor_id=film_actor.actor_id 
    LEFT JOIN film                   
            on film_actor.film_id=film.film_id          --actor/film is a many-to-many relationship so we have to connect the two tables via a actor-to-film table
    WHERE film.release_year = 2006                      -- film release year is specified
    GROUP BY actor.actor_id                             -- we end up with a table containing movie-acor pairings. we want to group the join table by actor as we  want to know the number of pairings belonging to one actor..
    ORDER BY count(film.film_id) DESC                   -- and display the nr of films belonging to one actor; and display the nrs obtained in descending order
    LIMIT 20;                
 
actor_first_name | actor_last_name | number_movies_played_in_2006
------------------+-----------------+------------------------------
 Gina             | Degeneres       |                           42
 Walter           | Torn            |                           41
 Mary             | Keitel          |                           40
 Matthew          | Carrey          |                           39
 Sandra           | Kilmer          |                           37
 Scarlett         | Damon           |                           36
 Val              | Bolger          |                           35
 Groucho          | Dunst           |                           35
 Vivien           | Basinger        |                           35
 Angela           | Witherspoon     |                           35
 Henry            | Berry           |                           35
 Uma              | Wood            |                           35
 Kirsten          | Akroyd          |                           34
 Angela           | Hudson          |                           34
 Sidney           | Crowe           |                           34
 Warren           | Nolte           |                           34
 Jayne            | Nolte           |                           34
 Reese            | West            |                           33
 Rip              | Crawford        |                           33
 Renee            | Ball            |                           33


-- Explain plan for Question 5

EXPLAIN ANALYZE 
SELECT actor.first_name as actor_first_name, actor.last_name as actor_last_name, count(film.film_id) as number_movies_played_in_2006  
FROM actor                              
    LEFT JOIN film_actor
            on actor.actor_id=film_actor.actor_id 
    LEFT JOIN film                   
            on film_actor.film_id=film.film_id         
    WHERE film.release_year = 2006                      
    GROUP BY actor.actor_id                             
    ORDER BY count(film.film_id) DESC                   
    LIMIT 20;                
 
                                                               QUERY PLAN                                               
-----------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=257.27..257.32 rows=20 width=25) (actual time=8.158..8.162 rows=20 loops=1)
   ->  Sort  (cost=257.27..257.77 rows=200 width=25) (actual time=8.157..8.160 rows=20 loops=1)
         Sort Key: (count(film.film_id)) DESC
         Sort Method: top-N heapsort  Memory: 27kB
         ->  HashAggregate  (cost=249.94..251.94 rows=200 width=25) (actual time=6.801..6.832 rows=200 loops=1)
               Group Key: actor.actor_id
               Batches: 1  Memory Usage: 64kB
               ->  Hash Join  (cost=85.50..218.08 rows=6372 width=21) (actual time=2.850..5.879 rows=5462 loops=1)
                     Hash Cond: (film_actor.film_id = film.film_id)
                     ->  Hash Join  (cost=6.50..122.30 rows=6372 width=19) (actual time=0.850..2.820 rows=5462 loops=1)
                           Hash Cond: (film_actor.actor_id = actor.actor_id)
                           ->  Seq Scan on film_actor  (cost=0.00..98.72 rows=6372 width=4) (actual time=0.065..0.617 rows=5462 loops=1)
                           ->  Hash  (cost=4.00..4.00 rows=200 width=17) (actual time=0.737..0.737 rows=200 loops=1)
                                 Buckets: 1024  Batches: 1  Memory Usage: 18kB
                                 ->  Seq Scan on actor  (cost=0.00..4.00 rows=200 width=17) (actual time=0.073..0.684 rows=200 loops=1)
                     ->  Hash  (cost=66.50..66.50 rows=1000 width=4) (actual time=1.554..1.554 rows=1000 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 44kB
                           ->  Seq Scan on film  (cost=0.00..66.50 rows=1000 width=4) (actual time=0.034..1.387 rows=1000 loops=1)
                                 Filter: ((release_year)::integer = 2006)
 Planning Time: 21.006 ms
 Execution Time: 11.371 ms
(21 rows)



 -- 6. 	Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one. 
  -- EXPLAIN plan for Question 4
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer.first_name, customer.last_name, sum(payment.amount) 
FROM customer
     INNER JOIN payment
            ON customer.customer_id=payment.customer_id             -- join the customer table and the payment table on the customer ID
     GROUP BY (customer.customer_id)                                  -- group all payments by customer so that the payments from the same customer are in the same group
    ORDER BY sum(payment.amount)                                     -- order them by the payment sum
    LIMIT 20;
 
                                                             QUERY PLAN                                                
--------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=435.12..435.17 rows=20 width=49) (actual time=15.309..15.313 rows=20 loops=1)
   Buffers: shared hit=127
   ->  Sort  (cost=435.12..436.62 rows=599 width=49) (actual time=15.308..15.310 rows=20 loops=1)
         Sort Key: (sum(payment.amount))
         Sort Method: top-N heapsort  Memory: 27kB
         Buffers: shared hit=127
         ->  HashAggregate  (cost=411.69..419.18 rows=599 width=49) (actual time=14.930..15.084 rows=599 loops=1)                       -- the grouping was the 4th operation. It started at 14.93 ms and ended at 15.084 ms
               Group Key: customer.customer_id
               Batches: 1  Memory Usage: 553kB
               Buffers: shared hit=124
               ->  Hash Join  (cost=22.48..333.98 rows=15542 width=23) (actual time=1.262..11.015 rows=14596 loops=1)                   -- the third loop took almost 10 ms. it consisted of joining the two tables
                     Hash Cond: (payment.customer_id = customer.customer_id)                        
                     Buffers: shared hit=124
                     ->  Seq Scan on payment  (cost=0.00..270.42 rows=15542 width=8) (actual time=0.765..3.476 rows=14596 loops=1)     -- second loop started at 0.765 ms, ended at 3.476 ms, went through all rows of the payment table once
                           Buffers: shared hit=115
                     ->  Hash  (cost=14.99..14.99 rows=599 width=17) (actual time=0.416..0.417 rows=599 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 39kB                                                                -- amount of memory used in the 1st loop
                           Buffers: shared hit=9
                           ->  Seq Scan on customer  (cost=0.00..14.99 rows=599 width=17) (actual time=0.060..0.257 rows=599 loops=1)  --!! The explain plan starts from here, with looping over the customer table. Looping starts at 0.06 ms and ends at 0.257 ms
                                 Buffers: shared hit=9
 Planning:
   Buffers: shared hit=152
 Planning Time: 22.570 ms
 Execution Time: 16.487 ms
(24 rows)



 --7.	What is the average rental rate per genre?


SELECT category.name as Genre, avg(payment.amount/(DATE_PART('day', rental.return_date::timestamp - rental.rental_date::timestamp) * 24 + 
              DATE_PART('hour', rental.return_date::timestamp - rental.rental_date::timestamp))) as Average_rental_rate_$_per_hour
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id
    LEFT JOIN payment
        ON rental.rental_id= payment.rental_id
    WHERE rental.return_date IS NOT NULL
    GROUP BY (category.name)
    ORDER BY category.name;

        genre    | average_rental_rate_$_per_hour
-------------+--------------------------------
 Action      |           0.041968325473151796
 Animation   |            0.04471185485444778
 Children    |           0.043422722524443055
 Classics    |           0.045049155227834564
 Comedy      |            0.04958687654660155
 Documentary |            0.04228654490627973
 Drama       |           0.050822870816310296
 Family      |            0.04200452185319123
 Foreign     |            0.04540718349409183
 Games       |            0.04649508238115097
 Horror      |           0.048864016209484086
 Music       |            0.04465374153482791
 New         |           0.052888667336306726
 Sci-Fi      |           0.046140906311267646
 Sports      |           0.047346703729297314
 Travel      |            0.05014408204882893


-- more simple:
SELECT category.name as Genre, avg(film.rental_rate) as avg_rental_rate        -- we want to show the average renatl rate of each film (later on, we'll group the result by category)
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id               -- as with Q5 we want to join the category and film table through a many-to-many table
GROUP BY category.name                                      -- as we want to know the average rental rate per category, we group the table by category
ORDER BY category.name
;

   genre    |        avg_rental_rate
-------------+--------------------
 Action      | 2.6462500000000000
 Animation   | 2.8081818181818182
 Children    | 2.8900000000000000
 Classics    | 2.7443859649122807
 Comedy      | 3.1624137931034483
 Documentary | 2.6664705882352941
 Drama       | 3.0222580645161290
 Family      | 2.7581159420289855
 Foreign     | 3.0995890410958904
 Games       | 3.2522950819672131
 Horror      | 3.0257142857142857
 Music       | 2.9507843137254902
 New         | 3.1169841269841270
 Sci-Fi      | 3.2195081967213115
 Sports      | 3.1251351351351351
 Travel      | 3.2356140350877193
(16 rows)

-- Q8 	How many films were returned late? Early? On time?

SELECT r.rental_id, f.title, f.rental_duration*24 as rental_hours_official,                                             -- number of "contracted" (official) rental hours defined
       DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) * 24 +                                     -- the real rental hours are calculated as a difference of return and rental datenumber of previously agreed rental hours defined
              DATE_PART('hour', r.return_date::timestamp - r.rental_date::timestamp) as rental_hours_real,
       CASE WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) * 24 + 
              DATE_PART('hour', r.return_date::timestamp - r.rental_date::timestamp)< f.rental_duration*24 THEN 'Early' -- if the real rental hours are less than the official ->early return
            WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) * 24 + 
              DATE_PART('hour', r.return_date::timestamp - r.rental_date::timestamp) > f.rental_duration*24 THEN 'Late' -- if the real rental hours are more than the official ->late return
            ELSE 'On time' END
            as on_time                                                                                                  -- else on time
FROM film as f                                                                                                          -- connect film table to inventory table first
    LEFT JOIN inventory as i
        ON f.film_id=i.film_id
    LEFT JOIN rental as r 
        ON i.inventory_id=r.inventory_id                                                                                 -- connect  inventory table to rental table
ORDER BY r.rental_id
limit 20;

 rental_id |       title        | rental_hours_official | rental_hours_real | on_time
-----------+--------------------+-----------------------+-------------------+---------
         1 | Blanket Beverly    |                   168 |                47 | Early
         2 | Freaky Pocus       |                   168 |                92 | Early
         3 | Graduate Lord      |                   168 |               191 | Late
         4 | Love Suicides      |                   144 |               218 | Late
         5 | Idols Snatchers    |                   120 |               197 | Late
         6 | Mystic Truman      |                   120 |                50 | Early
         7 | Swarm Gold         |                    96 |               117 | Late
         8 | Lawless Vision     |                   144 |                72 | Early
         9 | Matrix Snowman     |                   144 |                72 | Early
        10 | Hanging Deep       |                   120 |               166 | Late
        11 | Whale Bikini       |                    96 |               212 | Late
        12 | Games Bowfinger    |                   168 |               125 | Early
        13 | King Evolution     |                    72 |               124 | Late
        14 | Monterey Labyrinth |                   144 |                26 | Early
        15 | Pelican Comforts   |                    96 |               218 | Late
        16 | Boogie Amelie      |                   144 |                27 | Early
        17 | Contact Anonymous  |                   168 |                47 | Early
        18 | Roman Punk         |                   168 |               149 | Early
        19 | Hollow Jeopardy    |                   168 |               148 | Early
        20 | Scissorhands Slums |                   120 |                48 | Early



-- same but with day accuracy instead of hour accuracy

SELECT r.rental_id, f.title, f.rental_duration as rental_days_official,                                             
       DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) as rental_days_real,                                       
       CASE WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) < f.rental_duration THEN 'Early' 
            WHEN  DATE_PART('day', r.return_date::timestamp - r.rental_date::timestamp) > f.rental_duration THEN 'Late' 
            ELSE 'On time' END
            as on_time                                                                                                   
FROM film as f                                                                                                           
    LEFT JOIN inventory as i
        ON f.film_id=i.film_id
    LEFT JOIN rental as r 
        ON i.inventory_id=r.inventory_id                                                                                               
ORDER BY r.rental_id
limit 20;

 rental_id |       title        | rental_days_official | rental_days_real | on_time
-----------+--------------------+----------------------+------------------+---------
         1 | Blanket Beverly    |                    7 |                1 | Early
         2 | Freaky Pocus       |                    7 |                3 | Early
         3 | Graduate Lord      |                    7 |                7 | On time
         4 | Love Suicides      |                    6 |                9 | Late
         5 | Idols Snatchers    |                    5 |                8 | Late
         6 | Mystic Truman      |                    5 |                2 | Early
         7 | Swarm Gold         |                    4 |                4 | On time
         8 | Lawless Vision     |                    6 |                3 | Early
         9 | Matrix Snowman     |                    6 |                3 | Early
        10 | Hanging Deep       |                    5 |                6 | Late
        11 | Whale Bikini       |                    4 |                8 | Late
        12 | Games Bowfinger    |                    7 |                5 | Early
        13 | King Evolution     |                    3 |                5 | Late
        14 | Monterey Labyrinth |                    6 |                1 | Early
        15 | Pelican Comforts   |                    4 |                9 | Late
        16 | Boogie Amelie      |                    6 |                1 | Early
        17 | Contact Anonymous  |                    7 |                1 | Early
        18 | Roman Punk         |                    7 |                6 | Early
        19 | Hollow Jeopardy    |                    7 |                6 | Early
        20 | Scissorhands Slums |                    5 |                2 | Early
    

-- Q9.	What categories are the most rented and what are their total sales?
SELECT category.name AS Genre, COUNT(rental.rental_id) AS number_of_rentals, SUM(payment.amount) AS total_sales   -- we need the number of rentals and the sum of payments...
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id
    LEFT JOIN payment
        ON rental.rental_id= payment.rental_id              -- in order to join the catgeories to the sales and teh number of rentals, we must connect the catgeory table to the film table , then to the inventory table (4-fold join)
    GROUP BY (category.name)                                -- ... grouped by category
    ORDER BY category.name;


       genre    | number_of_rentals | total_sales
-------------+-------------------+-------------
 Action      |              1013 |     3951.84
 Animation   |              1065 |     4245.31
 Children    |               861 |     3309.39
 Classics    |               860 |     3353.38
 Comedy      |               851 |     4002.48
 Documentary |               937 |     3749.65
 Drama       |               953 |     4118.46
 Family      |               988 |     3830.15
 Foreign     |               953 |     3934.47
 Games       |               884 |     3922.18
 Horror      |               773 |     3401.27
 Music       |               750 |     3071.52
 New         |               864 |     3966.38
 Sci-Fi      |               998 |     4336.01
 Sports      |              1081 |     4892.19
 Travel      |               765 |     3227.36

 -- Bonus: How many films were rented each month? Group them by category and month. 

-- version 1
SELECT   
CASE WHEN DATE_PART('month', rental.rental_date)=1 THEN 'January'           -- creating a new column for months' name 
     WHEN DATE_PART('month', rental.rental_date)=2 THEN 'February' 
     WHEN DATE_PART('month', rental.rental_date)=3 THEN 'March'
     WHEN DATE_PART('month', rental.rental_date)=4 THEN 'April'
     WHEN DATE_PART('month', rental.rental_date)=5 THEN 'May'
     WHEN DATE_PART('month', rental.rental_date)=6 THEN 'June'
     WHEN DATE_PART('month', rental.rental_date)=7 THEN 'July'
     WHEN DATE_PART('month', rental.rental_date)=8 THEN 'August'
     WHEN DATE_PART('month', rental.rental_date)=9 THEN 'September'
     WHEN DATE_PART('month', rental.rental_date)=10 THEN 'October'
     WHEN DATE_PART('month', rental.rental_date)=11 THEN 'November'
     WHEN DATE_PART('month', rental.rental_date)=12 THEN 'December'
            ELSE 'No date given' END
            as month_name, 
    count(inventory.film_id) as nr_films_rented                         -- count the number of films that meet the following requirements
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id               --- joining the tables from category to rental
GROUP BY month_name                                                 -- grouping the results by month
order by count(inventory.film_id);


month_name   | nr_films_rented
---------------+-----------------
 No date given |               1
 February      |             182
 May           |            1156
 June          |            2311
 August        |            5686
 July          |            6709


SELECT   
CASE WHEN DATE_PART('month', rental.rental_date)=1 THEN 'January'
     WHEN DATE_PART('month', rental.rental_date)=2 THEN 'February' 
     WHEN DATE_PART('month', rental.rental_date)=3 THEN 'March'
     WHEN DATE_PART('month', rental.rental_date)=4 THEN 'April'
     WHEN DATE_PART('month', rental.rental_date)=5 THEN 'May'
     WHEN DATE_PART('month', rental.rental_date)=6 THEN 'June'
     WHEN DATE_PART('month', rental.rental_date)=7 THEN 'July'
     WHEN DATE_PART('month', rental.rental_date)=8 THEN 'August'
     WHEN DATE_PART('month', rental.rental_date)=9 THEN 'September'
     WHEN DATE_PART('month', rental.rental_date)=10 THEN 'October'
     WHEN DATE_PART('month', rental.rental_date)=11 THEN 'November'
     WHEN DATE_PART('month', rental.rental_date)=12 THEN 'December'
            ELSE 'No date given' END
            as month_name,
    count(inventory.film_id) as nr_films_rented, category.name as Genre
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id
GROUP BY category.name, month_name                                  -- do the same as above but first group by genre, then month name
ORDER by category.name                                              -- order by genre, the numbers per month appear in the second column
limit 18
;

  month_name   | nr_films_rented |    genre
---------------+-----------------+-------------
 August        |             384 | Action
 February      |              17 | Action
 July          |             464 | Action
 June          |             160 | Action
 May           |              87 | Action
 No date given |               0 | Action
 August        |             408 | Animation
 February      |              21 | Animation
 July          |             489 | Animation
 June          |             174 | Animation
 May           |              74 | Animation
 No date given |               0 | Animation
 August        |             332 | Children
 February      |               6 | Children
 July          |             406 | Children
 June          |             130 | Children
 May           |              71 | Children
 No date given |               0 | Children
 

 SELECT   
CASE WHEN DATE_PART('month', rental.rental_date)=1 THEN 'January'
     WHEN DATE_PART('month', rental.rental_date)=2 THEN 'February' 
     WHEN DATE_PART('month', rental.rental_date)=3 THEN 'March'
     WHEN DATE_PART('month', rental.rental_date)=4 THEN 'April'
     WHEN DATE_PART('month', rental.rental_date)=5 THEN 'May'
     WHEN DATE_PART('month', rental.rental_date)=6 THEN 'June'
     WHEN DATE_PART('month', rental.rental_date)=7 THEN 'July'
     WHEN DATE_PART('month', rental.rental_date)=8 THEN 'August'
     WHEN DATE_PART('month', rental.rental_date)=9 THEN 'September'
     WHEN DATE_PART('month', rental.rental_date)=10 THEN 'October'
     WHEN DATE_PART('month', rental.rental_date)=11 THEN 'November'
     WHEN DATE_PART('month', rental.rental_date)=12 THEN 'December'
            ELSE 'No date given' END
            as month_name,
    count(inventory.film_id) as nr_films_rented, category.name as Genre
FROM category
    LEFT JOIN film_category
        ON category.category_id=film_category.category_id
    LEFT JOIN film
        ON film_category.film_id=film.film_id
    LEFT JOIN inventory
        ON film.film_id=inventory.film_id 
    LEFT JOIN rental                   
        ON inventory.inventory_id=rental.inventory_id
GROUP BY category.name, month_name                           -- do the same as above but first group by genre, then month name
ORDER by month_name                                         -- order by month name, the numbers per genre appear in the second column
limit 32;

 month_name   | nr_films_rented |    genre
---------------+-----------------+-------------
 August        |             384 | Action
 August        |             408 | Animation
 August        |             332 | Children
 August        |             348 | Classics
 August        |             342 | Comedy
 August        |             369 | Documentary
 August        |             353 | Drama
 August        |             384 | Family
 August        |             377 | Foreign
 August        |             352 | Games
 August        |             299 | Horror
 August        |             277 | Music
 August        |             346 | New
 August        |             385 | Sci-Fi
 August        |             432 | Sports
 August        |             298 | Travel
 February      |              17 | Action
 February      |              21 | Animation
 February      |               6 | Children
 February      |               9 | Classics
 February      |               9 | Comedy
 February      |               6 | Documentary
 February      |               7 | Drama
 February      |              13 | Family
 February      |              11 | Foreign
 February      |              14 | Games
 February      |              12 | Horror
 February      |              11 | Music
 February      |              13 | New
 February      |               8 | Sci-Fi
 February      |              15 | Sports
 February      |              10 | Travel
 