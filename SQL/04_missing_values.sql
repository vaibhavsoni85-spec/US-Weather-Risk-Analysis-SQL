-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 04_missing_values.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Measure missing values in important weather fields
-- ============================================================


SELECT
  COUNT(*) AS total_rows,
  COUNTIF(avg_temp_f IS NULL) AS missing_avg_temp,
  COUNTIF(max_temp_f IS NULL) AS missing_max_temp,
  COUNTIF(min_temp_f IS NULL) AS missing_min_temp,
  COUNTIF(precipitation_in IS NULL) AS missing_precipitation,
  COUNTIF(snow_depth_in IS NULL) AS missing_snow_depth,
  COUNTIF(avg_wind_knots IS NULL) AS missing_avg_wind,
  COUNTIF(wind_gust_knots IS NULL) AS missing_wind_gust
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`;