-- ============================================================
-- Project: U.S. Extreme Weather Risk Analysis
-- File: 01_source_validation.sql
-- Author: Vaibhav Soni
-- Platform: Google BigQuery
-- Analysis period: 2019–2024
-- Purpose: Validate the source data before creating the view
-- ============================================================


-- ------------------------------------------------------------
-- Query 01a: Preview joined weather and station records
-- Purpose: Confirm that the weather and station tables join
-- correctly and inspect the available fields.
-- ------------------------------------------------------------


SELECT
  w.year,
  w.mo,
  w.da,
  w.stn,
  w.wban,
  s.name AS station_name,
  s.state,
  s.country
FROM
  `bigquery-public-data.noaa_gsod.gsod2019` AS w
INNER JOIN
  `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE
  s.country = 'US'
  AND s.state IS NOT NULL
LIMIT 20;



-- ------------------------------------------------------------
-- Query 01b: Count U.S. weather observations
-- Purpose: Confirm the approximate source-data volume.
-- Validation result: 938,470 rows in the initial check.
-- ------------------------------------------------------------

SELECT
  COUNT(*) AS us_weather_rows
FROM `bigquery-public-data.noaa_gsod.gsod2019` AS w
INNER JOIN `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE s.country = 'US'
  AND s.state IS NOT NULL;



-- ------------------------------------------------------------
-- Query 01c: Count distinct weather stations
-- Purpose: Confirm the number of stations represented.
-- Validation result: 2,689 stations in the initial check.
-- ------------------------------------------------------------

SELECT
  COUNT(
    DISTINCT CONCAT(w.stn, '-', w.wban)
  ) AS weather_stations
FROM
  `bigquery-public-data.noaa_gsod.gsod2019` AS w
INNER JOIN
  `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE
  s.country = 'US'
  AND s.state IS NOT NULL;



-- ------------------------------------------------------------
-- Query 01d: Count geographic codes
-- Purpose: Determine how many state and territory codes exist.
-- Validation result: 53 geographic codes.
-- ------------------------------------------------------------

SELECT
  COUNT(DISTINCT s.state) AS states_covered
FROM
  `bigquery-public-data.noaa_gsod.gsod2019` AS w
INNER JOIN
  `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE
  s.country = 'US'
  AND s.state IS NOT NULL;


-- ------------------------------------------------------------
-- Query 01e: List geographic codes
-- Purpose: Inspect the codes and identify non-state areas.
-- Finding: The source includes DC, PR, and VI in addition
-- to the 50 U.S. states.
-- ------------------------------------------------------------

SELECT DISTINCT
  s.state
FROM
  `bigquery-public-data.noaa_gsod.gsod2019` AS w
INNER JOIN
  `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE
  s.country = 'US'
  AND s.state IS NOT NULL
ORDER BY
  s.state;


-- ------------------------------------------------------------
-- Query 01f: Validate annual row counts
-- Purpose: Check whether reporting volume is reasonably
-- consistent across the selected years after applying the
-- final 50-state geographic scope.
-- ------------------------------------------------------------

SELECT
  CAST(w.year AS INT64) AS measurement_year,
  COUNT(*) AS row_count
FROM
  `bigquery-public-data.noaa_gsod.gsod*` AS w
INNER JOIN
  `bigquery-public-data.noaa_gsod.stations` AS s
  ON w.stn = s.usaf
  AND w.wban = s.wban
WHERE
  _TABLE_SUFFIX BETWEEN '2019' AND '2024'
  AND s.country = 'US'
  AND s.state IS NOT NULL
  AND s.state NOT IN ('DC', 'PR', 'VI')
GROUP BY
  measurement_year
ORDER BY
  measurement_year;