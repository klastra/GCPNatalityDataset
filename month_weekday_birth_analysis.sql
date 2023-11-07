-- Query 1: Total number of births per weekday. This can help us find out if there's a preference for giving birth on a particular day. 
-- Results: Most births on Tuesday, Wednesday, and Thursday

SELECT CASE WHEN wday = 1 THEN "Sunday" 
WHEN wday = 2 THEN "Monday" 
WHEN wday = 3 THEN "Tuesday" 
WHEN wday = 4 THEN "Wednesday" 
WHEN wday = 5 THEN "Thursday" 
WHEN wday = 6 THEN "Friday" 
WHEN wday = 7 THEN "Saturday" END AS wday, COUNT(*) as total_births, FROM bigquery-public-data.samples.natality WHERE wday IS NOT NULL GROUP BY wday ORDER BY total_births DESC


-- Query 2: Total number of births for each month. This will reveal if there are any seasonal trends in birth rates. 
-- Results: Most common months for women to give birth were: August, July, September

SELECT month, COUNT(*) as total_births, FROM bigquery-public-data.samples.natality WHERE month IS NOT NULL GROUP BY month ORDER BY total_births DESC


-- Query 3: Rank each combination of MONTH, mother's race, and the total number of births. Get the top 3.
-- Another way that I would approach the inclusion of the race_description column is by creating a look up table for mother_race, and the corresponding race description (i.e. 1 - White). With this way, I could use INNER JOIN with the lookup table to get the race description rather than using CASE WHEN statements.

SELECT *,  

CASE WHEN mother_race = 1 THEN "White" 
WHEN mother_race = 2 THEN "Black" 
WHEN mother_race = 3 THEN "American Indian" 
WHEN mother_race = 4 THEN "Chinese" 
WHEN mother_race = 5 THEN "Japanese" 
WHEN mother_race = 6 THEN "Hawaiian" 
WHEN mother_race = 7 THEN "Filipino" 
WHEN mother_race = 9 THEN "Unknown/Other" 
WHEN mother_race = 18 THEN "Asian Indian" 
WHEN mother_race = 28 THEN "Korean" 
WHEN mother_race = 39 THEN "Samoan" 
WHEN mother_race = 48 THEN "Vietnamese"
ELSE "Unknown Race" 
END AS race_description 

FROM

(SELECT n.month, n.mother_race, COUNT(*) as total_births, RANK() OVER(PARTITION BY mother_race ORDER BY COUNT(n.source_year) DESC) as month_race_rnk FROM bigquery-public-data.samples.natality n WHERE n.source_year IS NOT NULL AND mother_race IS NOT NULL GROUP BY n.month, n.mother_race) AS x 

WHERE x.month_race_rnk < 4 ORDER BY mother_race


-- Query 4: Rank each combination of WEEKDAY, mother's race, and the total number of births. Get the top 3.
SELECT *,  

CASE WHEN mother_race = 1 THEN "White" 
WHEN mother_race = 2 THEN "Black" 
WHEN mother_race = 3 THEN "American Indian" 
WHEN mother_race = 4 THEN "Chinese" 
WHEN mother_race = 5 THEN "Japanese" 
WHEN mother_race = 6 THEN "Hawaiian" 
WHEN mother_race = 7 THEN "Filipino" 
WHEN mother_race = 9 THEN "Unknown/Other" 
WHEN mother_race = 18 THEN "Asian Indian" 
WHEN mother_race = 28 THEN "Korean" 
WHEN mother_race = 39 THEN "Samoan" 
WHEN mother_race = 48 THEN "Vietnamese"
ELSE "Unknown Race" 
END AS race_description 

FROM

(SELECT n.wday, n.mother_race, COUNT(*) as total_births, RANK() OVER(PARTITION BY mother_race ORDER BY COUNT(n.source_year) DESC) as wday_race_rnk FROM bigquery-public-data.samples.natality n WHERE n.source_year IS NOT NULL AND mother_race IS NOT NULL AND wday IS NOT NULL GROUP BY n.wday, n.mother_race) AS x 

WHERE x.wday_race_rnk < 4 ORDER BY mother_race

-- Query 5: Total number of births on each weekday
SELECT wday, COUNT(*) as total_births, RANK() over(partition by wday ORDER BY COUNT(*)) AS rnk FROM bigquery-public-data.samples.natality WHERE wday IS NOT NULL GROUP BY wday ORDER BY total_births DESC

-- Query 6: Get how many samples there are per mother's race
SELECT mother_race, COUNT(*) as total_births FROM bigquery-public-data.samples.natality GROUP BY mother_race ORDER BY total_births DESC