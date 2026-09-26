-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 06a_check_high_temp.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Inspect unusually high maximum-temperature records
-- ============================================================


SELECT
  weather_date,
  state_code,
  station_id,
  station_name,
  max_temp_f
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
WHERE
  max_temp_f >= 120
ORDER BY
  max_temp_f DESC,
  weather_date
LIMIT 100;