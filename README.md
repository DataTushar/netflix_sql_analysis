# 🌟 Netflix Movies & TV Shows Data Analysis (SQL)  
![netflix logo](https://github.com/DataTushar/netflix_sql_analysis/blob/main/logo.png)

## 🔍 Project Overview  
This project is a **comprehensive SQL-based analysis** of Netflix's content library, aiming to extract meaningful insights regarding content distribution, trends, and categorization. Using structured SQL queries, we analyze factors such as content type, ratings, release years, country-wise distribution, genre categorization, and more.  

---
## 📚 Dataset Information  
The dataset used in this project is sourced from **Kaggle** and contains metadata about movies and TV shows available on Netflix. The dataset includes the following attributes:

| Column Name  | Description |
|-------------|------------|
| `show_id`    | Unique ID for each movie/TV show |
| `type`       | Movie or TV Show |
| `title`      | Name of the movie/TV show |
| `director`   | Director's name |
| `cast`       | Lead actors and supporting cast |
| `country`    | Country of production |
| `date_added` | Date added to Netflix |
| `release_year` | Original release year |
| `rating`     | Age rating (e.g., PG, R, TV-MA) |
| `duration`   | Duration (in minutes for movies, seasons for TV shows) |
| `listed_in`  | Genre category |
| `description` | Short summary of the content |

---
## 💪 Objectives of the Project  
The key goals of this SQL analysis project include:

- ✅ **Analyzing Content Type Distribution** (Movies vs. TV Shows)
- ✅ **Identifying the Most Common Ratings**
- ✅ **Exploring Country-wise Content Distribution**
- ✅ **Determining the Longest Movie**
- ✅ **Finding Content Added in the Last 5 Years**
- ✅ **Filtering Content by Specific Directors and Actors**
- ✅ **Categorizing Content Based on Keywords**

---
## 📊 Key Business Questions & SQL Analysis  
Below are the **15 key business questions** answered in this analysis with SQL queries:

### 1. Count the Number of Movies vs. TV Shows  
```sql
SELECT type, COUNT(show_id)
FROM netflix 
GROUP BY type;
```

### 2. Find the Most Common Rating for Movies and TV Shows  
```sql
WITH commonshow AS (
    SELECT type, rating, COUNT(*) AS count,
           RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS rank
    FROM netflix 
    GROUP BY type, rating
)
SELECT type, rating FROM commonshow WHERE rank = 1;
```

### 3. List All Movies Released in a Specific Year (e.g., 2020)  
```sql
SELECT * FROM netflix WHERE type='Movie' AND release_year=2020;
```

### 4. Find the Top 5 Countries with the Most Content on Netflix  
```sql
WITH cte AS (
    SELECT country, COUNT(*) AS count
    FROM netflix
    GROUP BY country
    ORDER BY count DESC
)
SELECT country FROM cte WHERE country IS NOT NULL LIMIT 5;
```

### 5. Identify the Longest Movie  
```sql
SELECT title, CAST(TRIM(BOTH 'min' FROM duration) AS INT) AS max_duration
FROM netflix WHERE type='Movie' AND duration IS NOT NULL
ORDER BY max_duration DESC LIMIT 1;
```

### 6. Find Content Added in the Last 5 Years  
```sql
WITH cte AS (
    SELECT title, CAST(RIGHT(date_added, 4) AS INT) AS date FROM netflix
)
SELECT * FROM cte WHERE date IN (2017, 2018, 2019, 2020, 2021) ORDER BY date;
```

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'  
```sql
SELECT * FROM netflix WHERE director LIKE '%Rajiv Chilaka%';
```

### 8. List All TV Shows with More Than 5 Seasons  
```sql
SELECT *, SPLIT_PART(duration, ' ', 1)::NUMERIC AS season_count
FROM netflix WHERE type='TV Show'
AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5
ORDER BY season_count DESC;
```

### 9. Count the Number of Content Items in Each Genre  
```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(show_id)
FROM netflix
GROUP BY genre;
```

### 10. Find Each Year and the Average Number of Content Releases in India  
```sql
SELECT EXTRACT(YEAR FROM date_added::DATE) AS date,
       COUNT(show_id) AS content_count,
       COUNT(show_id)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country='India')::NUMERIC AS average
FROM netflix
WHERE country='India'
GROUP BY date;
```

### 11. List All Movies that are Documentaries  
```sql
SELECT * FROM netflix WHERE listed_in LIKE '%Documentaries%';
```

### 12. Find All Content Without a Director  
```sql
SELECT * FROM netflix WHERE director IS NULL;
```

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years  
```sql
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
ORDER BY release_year DESC;
```

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India  
```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor, COUNT(*) AS movie_count
FROM netflix
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;
```

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords  
```sql
WITH cte AS (
    SELECT *,
           CASE WHEN description ILIKE '%violence%' OR description ILIKE '%kill%'
                THEN 'Bad Film'
                ELSE 'Good Film' END AS label
    FROM netflix
)
SELECT label, COUNT(*) FROM cte GROUP BY label;
```

---
## 💡 Conclusion  
This project successfully demonstrates **how SQL can be leveraged for data-driven decision-making** in the entertainment industry. By analyzing Netflix’s content, we gain valuable insights into content trends, audience preferences, and content distribution. 

If you liked this project, don't forget to ⭐ star the repository!

