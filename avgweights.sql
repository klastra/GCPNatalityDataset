-- Generate a table with the average weight of a newborn in kilograms between 1988 and 2008 and calculate a delta between the current average weight to the one exactly 20 years prior.

-- Solution 1: If current avg weight means the avg weight at 2008 - the avg weight at 1988
-- To generate a table for these queries, I would use CREATE TABLE new_table_name AS ...
SELECT AVG(weight_pounds) * 0.45359237 AS avg_kg_1988_to_2008 FROM `bigquery-public-data.samples.natality` WHERE year BETWEEN 1988 AND 2008;

WITH 
  current_avg AS 
    (
      SELECT AVG(weight_pounds) * 0.45359237 AS avg_kg_2008
      FROM `bigquery-public-data.samples.natality`
      WHERE year = 2008
    ), 

  past_avg AS 
    (
      SELECT AVG(weight_pounds) * 0.45359237 AS avg_kg_1988
      FROM `bigquery-public-data.samples.natality`
      WHERE year = 1988
    )

SELECT (x1.avg_kg_2008 - x2.avg_kg_1988) AS delta FROM current_avg x1, past_avg x2;


-- Solution 2: If current avg weight means the avg weight between (1988 and 2008) - the avg weight between (1967 and 1987)

  WITH
    from_1988_to_2008 AS
      (
        SELECT AVG(weight_pounds) * 0.45359237 AS avg_kg_1988_to_2008
        FROM `bigquery-public-data.samples.natality`
        WHERE year BETWEEN 1988 AND 2008
      ),
        
    from_1967_to_1987 AS
      (
        SELECT AVG(weight_pounds) * 0.45359237 AS from_1967_to_1987
        FROM `bigquery-public-data.samples.natality`
        WHERE year BETWEEN 1967 AND 1987
      )

  SELECT x1.avg_kg_1988_to_2008, (x1.avg_kg_1988_to_2008 - x2.from_1967_to_1987) AS delta FROM from_1988_to_2008 x1, from_1967_to_1987 x2;