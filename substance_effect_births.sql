-- Query 1: Average weight of newborns per state 
SELECT state, COUNT(*) as total_newborns, AVG(weight_pounds) AS avg_weight_per_state, RANK() OVER(PARTITION BY state ORDER BY AVG(weight_pounds)) AS rnk FROM bigquery-public-data.samples.natality GROUP BY state ORDER BY avg_weight_per_state DESC

-- Query 2: Average weight of newborns per state if their mother smoked 
SELECT state, cigarette_use, COUNT(*) as total_newborns, AVG(weight_pounds) AS avg_weight_per_state, ROW_NUMBER() OVER(PARTITION BY state ORDER BY AVG(weight_pounds)) AS rn FROM bigquery-public-data.samples.natality WHERE cigarette_use IS NOT NULL AND state IS NOT NULL GROUP BY state, cigarette_use ORDER BY state, avg_weight_per_state DESC

-- Query 3: Average weight of newborns per state if their mother drank 
SELECT state, alcohol_use, COUNT(*) as total_newborns, AVG(weight_pounds) AS avg_weight_per_state, ROW_NUMBER() OVER(PARTITION BY state ORDER BY AVG(weight_pounds)) AS rn FROM bigquery-public-data.samples.natality WHERE alcohol_use IS NOT NULL GROUP BY state, alcohol_use ORDER BY state, avg_weight_per_state DESC
