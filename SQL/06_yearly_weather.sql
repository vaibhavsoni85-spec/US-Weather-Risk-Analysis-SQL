-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 06_yearly_weather.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Summarize major weather measurements by year
-- ============================================================


SELECT
  EXTRACT(YEAR FROM weather_date) AS weather_year,
  ROUND(AVG(avg_temp_f), 2) AS avg_temp_f,
  ROUND(MAX(max_temp_f), 2) AS highest_temp_f,
  ROUND(MIN(min_temp_f), 2) AS lowest_temp_f,
  ROUND(AVG(precipitation_in), 2) AS avg_precipitation_in,
  ROUND(AVG(avg_wind_knots), 2) AS avg_wind_knots
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
GROUP BY
  weather_year
ORDER BY
  weather_year;