-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 07a_heat_threshold
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Calculate the threshold for unusually warm weather
-- ============================================================

-- This query calculates the 90th percentile of daily average
-- temperatures. Observations at or above this value represent
-- approximately the warmest 10% of the dataset.




SELECT
  APPROX_QUANTILES(avg_temp_f, 100)[OFFSET(90)]
    AS heat_threshold_f
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`;







-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 07b_heat_states
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Identify states with the highest proportion of
--          unusually warm observations
-- ============================================================

-- This query applies the 79.2°F threshold calculated in Query
-- 07a. It counts unusually warm observations for each state
-- and calculates their percentage of all state observations.




SELECT
  state_code,
  COUNT(*) AS total_observations,
  COUNTIF(avg_temp_f >= 79.2) AS heat_observations,

  ROUND(
    COUNTIF(avg_temp_f >= 79.2) * 100.0 / COUNT(*),
    2
  ) AS heat_percentage

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  state_code
ORDER BY
  heat_percentage DESC
LIMIT 10;
















