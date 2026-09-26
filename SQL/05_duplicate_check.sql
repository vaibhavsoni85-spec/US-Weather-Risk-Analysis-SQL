-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 05_duplicate_check.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Check for duplicate station-date observations
-- ============================================================


SELECT
  COUNT(*) AS total_rows,

  COUNT(
    DISTINCT CONCAT(
      station_id,
      '-',
      CAST(weather_date AS STRING)
    )
  ) AS unique_station_days,

  COUNT(*) -
  COUNT(
    DISTINCT CONCAT(
      station_id,
      '-',
      CAST(weather_date AS STRING)
    )
  ) AS duplicate_rows

FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`;