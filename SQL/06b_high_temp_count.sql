-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 06b_high_temp_count.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Measure the extent of unusually high temperatures
-- ============================================================


SELECT
  COUNT(*) AS high_temp_rows,
  COUNT(DISTINCT station_id) AS stations,
  COUNT(DISTINCT state_code) AS states
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
WHERE
  max_temp_f >= 120;