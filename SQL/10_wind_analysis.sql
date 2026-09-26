-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 10a_wind_threshold
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Calculate the unusually high wind threshold in mph
-- ============================================================

-- This query calculates the 90th percentile of valid average
-- wind-speed observations. Because the source records wind in
-- knots, the result is converted to miles per hour for easier
-- business interpretation.




SELECT
  ROUND(
    APPROX_QUANTILES(avg_wind_knots, 100)[OFFSET(90)]
      * 1.15078,
    2
  ) AS wind_threshold_mph
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
WHERE
  avg_wind_knots IS NOT NULL;





-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 10b_wind_states
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Identify states with the highest proportion of
--          unusually windy observations
-- ============================================================

-- This query converts each valid wind-speed observation from
-- knots to mph and applies the 13.23 mph threshold calculated
-- in Query 10a.



SELECT
  state_code,
  13.23 AS wind_threshold_mph,
  COUNTIF(avg_wind_knots IS NOT NULL) AS valid_observations,

  COUNTIF(
    avg_wind_knots * 1.15078 >= 13.23
  ) AS high_wind_observations,

  ROUND(
    COUNTIF(avg_wind_knots * 1.15078 >= 13.23) * 100.0
    / COUNTIF(avg_wind_knots IS NOT NULL),
    2
  ) AS high_wind_percentage

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  state_code
ORDER BY
  high_wind_percentage DESC
LIMIT 10;