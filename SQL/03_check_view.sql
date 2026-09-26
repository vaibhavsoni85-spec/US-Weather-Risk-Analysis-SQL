-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 03_check_view.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Validate the final analytical view
-- ============================================================

-- This query checks:
-- 1. Total number of station observations.
-- 2. First and last measurement dates.
-- 3. Number of states represented.
-- 4. Number of distinct weather stations.


SELECT
  COUNT(*) AS total_rows,
  MIN(weather_date) AS first_date,
  MAX(weather_date) AS last_date,
  COUNT(DISTINCT state_code) AS states,
  COUNT(DISTINCT station_id) AS stations
FROM
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`;