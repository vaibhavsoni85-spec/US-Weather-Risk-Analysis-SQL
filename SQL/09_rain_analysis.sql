-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 09a_rain_threshold
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Calculate the threshold for unusually high rainfall
-- ============================================================

-- This query calculates the 90th percentile of positive daily
-- precipitation values. Dry days and zero-rainfall observations
-- are excluded so that the threshold represents unusually high
-- rainfall among days when precipitation occurred.

SELECT
  APPROX_QUANTILES(precipitation_in, 100)[OFFSET(90)]
    AS rain_threshold_in
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
WHERE
  precipitation_in > 0;








-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 09b_rain_states
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Identify states with the highest proportion of
--          high-rainfall observations
-- ============================================================

-- This query applies the 0.78-inch rainfall threshold calculated
-- in Query 09a. Missing precipitation values are excluded from
-- the percentage denominator.



SELECT
  state_code,
  COUNTIF(precipitation_in IS NOT NULL) AS valid_observations,
  COUNTIF(precipitation_in >= 0.78) AS high_rain_observations,

  ROUND(
    COUNTIF(precipitation_in >= 0.78) * 100.0
    / COUNTIF(precipitation_in IS NOT NULL),
    2
  ) AS high_rain_percentage

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  state_code
ORDER BY
  high_rain_percentage DESC
LIMIT 10;