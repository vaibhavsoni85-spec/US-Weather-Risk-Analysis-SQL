# Data Dictionary

## Project

**U.S. Extreme Weather Risk Analysis**

## Analysis View

`portfolio-project-508812.us_extreme_weather_analysis.vw_weather`

## Data Grain

Each row represents one daily weather observation for one monitoring station.

## Fields

| Field | Data type | Description |
|---|---|---|
| `weather_date` | DATE | Date of the daily weather observation. |
| `state_code` | STRING | Two-letter U.S. state abbreviation. |
| `station_id` | STRING | Combined USAF and WBAN identifiers used to identify a weather station. |
| `station_name` | STRING | Name of the weather monitoring station. |
| `avg_temp_f` | FLOAT64 | Daily average temperature in degrees Fahrenheit. |
| `max_temp_f` | FLOAT64 | Daily maximum temperature in degrees Fahrenheit. |
| `min_temp_f` | FLOAT64 | Daily minimum temperature in degrees Fahrenheit. |
| `precipitation_in` | FLOAT64 | Daily precipitation measured in inches. |
| `snow_depth_in` | FLOAT64 | Recorded snow depth measured in inches. |
| `avg_wind_knots` | FLOAT64 | Daily average wind speed measured in knots. |
| `wind_gust_knots` | FLOAT64 | Daily maximum wind-gust speed measured in knots. |
| `fog` | STRING | Indicator showing whether fog was reported. |
| `rain_drizzle` | STRING | Indicator showing whether rain or drizzle was reported. |
| `snow_ice_pellets` | STRING | Indicator showing whether snow or ice pellets were reported. |
| `hail` | STRING | Indicator showing whether hail was reported. |
| `thunder` | STRING | Indicator showing whether thunder was reported. |
| `tornado_funnel_cloud` | STRING | Indicator showing whether a tornado or funnel cloud was reported. |

## Data-Cleaning Rules

The `vw_weather` view applies the following rules:

- Combines NOAA GSOD yearly tables from 2019 through 2024.
- Joins weather observations with NOAA station information.
- Includes only the 50 U.S. states.
- Excludes District of Columbia, Puerto Rico and the U.S. Virgin Islands.
- Creates `weather_date` from the source year, month and day fields.
- Creates `station_id` by combining the USAF and WBAN identifiers.
- Converts weather measurements into numeric fields using `SAFE_CAST`.
- Replaces NOAA missing-value codes with `NULL`.

## Measurement Units

| Measurement | Unit |
|---|---|
| Temperature | Degrees Fahrenheit (°F) |
| Precipitation | Inches |
| Snow depth | Inches |
| Source wind speed | Knots |
| Reported wind-analysis threshold | Miles per hour (mph) |

Wind speed is converted using:

`1 knot = 1.15078 miles per hour`

## Analysis Thresholds

| Condition | Threshold | Method |
|---|---:|---|
| Unusually warm | `79.2°F` | 90th percentile of valid daily average temperatures |
| Unusually cold | `29.4°F` | 10th percentile of valid daily average temperatures |
| High rainfall | `0.78 inches` | 90th percentile of positive precipitation observations |
| High wind | `13.23 mph` | 90th percentile of valid average wind observations, converted from knots |

## Important Interpretation Note

The combined-hazards analysis is a high-condition exposure indicator. It identifies observations meeting at least one temperature, rainfall or wind threshold. It is not a formal risk score and does not incorporate population, financial loss, vulnerability or event severity.