-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 02_create_view.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Create a reusable cleaned weather analysis view
-- ============================================================

-- This view:
-- 1. Combines NOAA yearly weather tables from 2019–2024.
-- 2. Joins daily weather records with station information.
-- 3. Creates a valid weather date and station identifier.
-- 4. Converts measurement fields into numeric values.
-- 5. Replaces NOAA missing-value codes with NULL.
-- 6. Restricts the analysis to the 50 U.S. states.

CREATE OR REPLACE VIEW
  `portfolio-project-508812.us_extreme_weather_analysis.vw_weather`
AS

SELECT
  DATE(
    CAST(w.year AS INT64),
    CAST(w.mo AS INT64),
    CAST(w.da AS INT64)
  ) AS weather_date,

  s.state AS state_code,
  CONCAT(w.stn, '-', w.wban) AS station_id,
  s.name AS station_name,

  NULLIF(SAFE_CAST(w.temp AS FLOAT64), 9999.9) AS avg_temp_f,
  NULLIF(SAFE_CAST(w.max AS FLOAT64), 9999.9) AS max_temp_f,
  NULLIF(SAFE_CAST(w.min AS FLOAT64), 9999.9) AS min_temp_f,
  NULLIF(SAFE_CAST(w.prcp AS FLOAT64), 99.99) AS precipitation_in,
  NULLIF(SAFE_CAST(w.sndp AS FLOAT64), 999.9) AS snow_depth_in,
  NULLIF(SAFE_CAST(w.wdsp AS FLOAT64), 999.9) AS avg_wind_knots,
  NULLIF(SAFE_CAST(w.gust AS FLOAT64), 999.9) AS wind_gust_knots,
  
  w.fog,
  w.rain_drizzle,
  w.snow_ice_pellets,
  w.hail,
  w.thunder,
  w.tornado_funnel_cloud

FROM `bigquery-public-data.noaa_gsod.gsod*` AS w

INNER JOIN `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf

  AND w.wban = s.wban

WHERE
  _TABLE_SUFFIX BETWEEN '2019' AND '2024'
  AND s.country = 'US'
  AND s.state IS NOT NULL
  AND s.state NOT IN ('DC', 'PR', 'VI');