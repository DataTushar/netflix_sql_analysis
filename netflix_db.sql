--NETFLIX ANALYSIS PROJECT 

CREATE TABLE NETFLIX 
(
   show_id VARCHAR(10),
   type VARCHAR(7),
   title VARCHAR(150),
   director VARCHAR (250),
   casts VARCHAR (800),
   country  VARCHAR(150),
   date_added VARCHAR(25),
   release_year INT,
   rating VARCHAR(10),
   duration VARCHAR(15),
   listed_in VARCHAR(100),
   description VARCHAR(300)

);
ALTER TABLE netflix
ALTER COLUMN show_id TYPE VARCHAR(15);

SELECT * FROM NETFLIX;

--15 BUSINESS PROBLEMS
1. Count the Number of Movies vs TV Shows
select
   type,
   count(show_id)
   from netflix 
   group by 
   type;



2. Find the Most Common Rating for Movies and TV Shows
with commonshow as (

 select type,rating,count(*),
 rank()over(partition by type order by count(*) desc ) as rank
 from netflix 
 group by type,rating
 order by 1 ,3 desc
)
select type,rating from commonshow where rank = 1;
 

3. List All Movies Released in a Specific Year (e.g., 2020)
 select * from netflix where type='Movie' and release_year=2020;
  
4. Find the Top 5 Countries with the Most Content on Netflix 
 with cte as (  
    select country, count(*)
    from netflix
	
	group by country
	order by 2 desc
 )
 select country from cte  where country is not null 
 limit 5;
5. Identify the Longest Movie
   
   select title,cast(trim(both'min' from duration) as int) as max_duration from netflix where type='Movie' and duration is not null
   order by 2 desc limit 1 ;
  
6. Find Content Added in the Last 5 Years
 with cte as ( 
  select title,cast(right(date_added,4)as int) as date from netflix
  )
  select * from cte where date in(2017,2018,2019,2020,2021)
  order by date ;

  
7. 
Find All Movies/TV Shows by Director 'Rajiv Chilaka'
   select * from netflix where Director like '%Rajiv Chilaka%'
   
8. List All TV Shows with More Than 5 Seasons
  
	select *, split_part(duration,' ',1)::numeric as season_count from netflix where type='TV Show'
	and split_part(duration,' ',1)::numeric > 5 order by season_count desc ;

   
    
9. Count the Number of Content Items in Each Genre
  select 
		 UNNEST(STRING_TO_ARRAY(listed_in,',')),
         count(show_id)
         
		 from netflix
		 group by 1;
     
10.Find each year and the average numbers of content release in India on netflix.
    -- select * from netflix
	select extract(year from date_added::date) as date,
	count(show_id),
	count(show_id)::numeric/(select count(*) from netflix where country='India')::numeric as average
	from netflix
	where country='India'
	group by 1 
	
11. List All Movies that are Documentaries
    
	select * from netflix where listed_in like '%Documentaries%'
	
12. Find All Content Without a Director

    select * from netflix where director is null
	
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

    select * from netflix where casts ilike '%salman khan%' and relase_year in ()order by release_year desc
	
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

    select  UNNEST(STRING_TO_ARRAY(casts,',')),count(*) from netflix group by 1 order by 2 desc limit 10

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
   with cte as (
	select *, 
	case when description ilike '%violence%' or description ilike '%kill%'
	then 'bad film'
	else 'good film' end label
	from netflix 
)
select label,count(*) from cte group by label;
