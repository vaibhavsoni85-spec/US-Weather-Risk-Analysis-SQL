-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- Query: 11_combined_hazards
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Compare combined high-condition exposure by state
-- ============================================================

-- This query identifies observations that meet at least one of
-- the four data-derived weather thresholds: unusual heat,
-- unusual cold, high rainfall or high wind.



SELECT
  state_code,
  COUNT(*) AS total_observations,

  COUNTIF(
    avg_temp_f >= 79.2
    OR avg_temp_f <= 29.4
    OR precipitation_in >= 0.78
    OR avg_wind_knots * 1.15078 >= 13.23
  ) AS hazard_observations,

  ROUND(
    COUNTIF(
      avg_temp_f >= 79.2
      OR avg_temp_f <= 29.4
      OR precipitation_in >= 0.78
      OR avg_wind_knots * 1.15078 >= 13.23
    ) * 100.0 / COUNT(*),
    2
  ) AS hazard_percentage

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  state_code
ORDER BY
  hazard_percentage DESC
LIMIT 10;