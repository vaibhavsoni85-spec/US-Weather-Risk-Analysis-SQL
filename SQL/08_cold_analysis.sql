-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 08a_cold_threshold
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Calculate the threshold for unusually cold weather
-- ============================================================

-- This query calculates the 10th percentile of daily average
-- temperatures. Observations at or below this value represent
-- approximately the coldest 10% of the dataset.



SELECT
  APPROX_QUANTILES(avg_temp_f, 100)[OFFSET(10)]
    AS cold_threshold_f
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`;





-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 08b_cold_states
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Identify states with the highest proportion of
--          unusually cold observations
-- ============================================================

-- This query applies the 29.4°F threshold calculated in Query
-- 08a. It counts unusually cold observations for each state
-- and calculates their percentage of all state observations.




SELECT
  state_code,
  COUNT(*) AS total_observations,
  COUNTIF(avg_temp_f <= 29.4) AS cold_observations,

  ROUND(
    COUNTIF(avg_temp_f <= 29.4) * 100.0 / COUNT(*),
    2
  ) AS cold_percentage

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  state_code
ORDER BY
  cold_percentage DESC
LIMIT 10;