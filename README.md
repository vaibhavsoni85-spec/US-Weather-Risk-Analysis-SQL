# U.S. Weather SQL Analysis

**Author:** Vaibhav Soni  
**Tools:** Google BigQuery | Standard SQL  
**Analysis period:** 2019–2024

## Project Overview

This project analyzes daily weather-station observations across the 50 U.S. states from 2019 through 2024 using Google BigQuery and Standard SQL.

The analysis compares the frequency of unusually warm, unusually cold, high-precipitation, and high-wind observations. It also creates a combined high-condition exposure indicator to identify states that may require deeper preparedness analysis.

> \*\*Interpretation note:\*\* This is a station-observation screening analysis, not a complete disaster-risk model. It does not measure population exposure, infrastructure vulnerability, event severity, or financial loss.

📄 [View the One-Page Executive Summary](Documentation/US_Weather_Risk_Executive_Summary.pdf)

## Business Questions

1. How did national weather averages vary between 2019 and 2024?
2. Which states recorded the highest frequency of unusually warm observations?
3. Which states recorded the highest frequency of unusually cold observations?
4. Which states recorded the highest frequency of heavy-precipitation observations?
5. Which states recorded the highest frequency of high-wind observations?
6. Which states had the highest combined frequency across the four weather conditions?

## Data Source

* **Source:** NOAA Global Surface Summary of the Day (GSOD)
* **BigQuery tables:**

  * `bigquery-public-data.noaa\_gsod.gsod\*`
  * `bigquery-public-data.noaa\_gsod.stations`
* **Analysis period:** 1 January 2019 to 31 December 2024
* **Geographic scope:** 50 U.S. states
* **Excluded geographic codes:** District of Columbia, Puerto Rico, and U.S. Virgin Islands
* **Unit of analysis:** One weather-station observation for one date

The project queries the public NOAA dataset directly in BigQuery. No raw source data is redistributed in this repository.

## Tools and SQL Techniques

* Google BigQuery Sandbox
* BigQuery Standard SQL
* Wildcard tables and `\_TABLE\_SUFFIX`
* `INNER JOIN`
* `SAFE\_CAST` and `NULLIF`
* Common aggregate functions
* `COUNTIF` and `COUNT(DISTINCT ...)`
* `APPROX\_QUANTILES`
* `SAFE\_DIVIDE`
* Reusable BigQuery views
* Data-quality and anomaly checks

## Analysis Workflow

|Stage|Queries|Purpose|
|-|-|-|
|Source validation|`01a`–`01f`|Confirm yearly coverage, U.S. rows, stations, and geographic codes|
|Data transformation|`02\_create\_view`|Create a reusable analytical view and handle source sentinel values|
|View validation|`03`–`05`|Validate coverage, missing values, and duplicate station-date records|
|Annual analysis|`06`|Summarize annual average temperature, precipitation, and wind|
|Anomaly investigation|`06a`–`06b`|Investigate suspicious maximum-temperature records|
|Condition analysis|`07a`–`10b`|Calculate thresholds and compare states|
|Combined analysis|`11`|Measure observations meeting at least one defined condition|

## Analytical View

The project creates the following reusable view:

```sql
`portfolio-project-508812.us\_extreme\_weather\_analysis.vw\_weather`
```

The view:

* Combines yearly NOAA GSOD tables.
* Joins weather observations to station metadata.
* Creates a valid calendar date.
* Creates a combined station identifier.
* Converts measurement fields to numeric values.
* Replaces known missing-value sentinel codes with `NULL`.
* Restricts the analysis to 2019–2024 and the 50 U.S. states.

## Validation Results

|Validation measure|Result|
|-|-:|
|Total station observations|5,638,214|
|First date|2019-01-01|
|Last date|2024-12-31|
|States|50|
|Stations|2,768|
|Duplicate station-date rows|0|

### Missing-Value Assessment

|Measure|Missing rows|Missing percentage|Decision|
|-|-:|-:|-|
|Average temperature|0|0.00%|Included|
|Maximum temperature|5,797|0.10%|Used only for diagnostic review|
|Minimum temperature|2,006|0.04%|Used only for diagnostic review|
|Precipitation|500,506|8.88%|Included with valid-observation denominator|
|Snow depth|5,571,627|98.82%|Excluded from primary analysis|
|Average wind|364,948|6.47%|Included with valid-observation denominator|
|Wind gust|2,629,445|46.64%|Excluded from primary analysis|

## Data Quality Decisions

### Temperature anomalies

Initial annual maximum-temperature results ranged from 123.1°F to 132.8°F. Record-level investigation identified 234 suspicious high-temperature observations across 28 stations and 14 states, representing approximately 0.0042% of the final rows.

The broader dataset was retained, but raw annual maximum and minimum temperatures were removed from the primary findings. Annual averages and percentile-based thresholds were used because they are less sensitive to isolated anomalies.

### Incomplete variables

Snow depth and wind gust were excluded from primary state comparisons because their missing percentages were too high to support consistent analysis.

### Rain threshold correction

The original precipitation percentile included zero-rain observations and returned 0.14 inches. The threshold was recalculated using positive precipitation observations only, producing a more meaningful heavy-rain threshold of 0.78 inches.

## Threshold Methodology

|Condition|Analytical rule|Reasoning|
|-|-|-|
|Unusually warm|`avg\_temp\_f >= 79.2`|Estimated 90th percentile of valid daily average temperature|
|Unusually cold|`avg\_temp\_f <= 29.4`|Estimated 10th percentile of valid daily average temperature|
|Heavy precipitation|`precipitation\_in >= 0.78`|Estimated 90th percentile of positive precipitation observations|
|High wind|`avg\_wind\_knots >= 11.5`|Estimated 90th percentile of valid average-wind observations|

The high-wind threshold of 11.5 knots is approximately 13.23 miles per hour.

The heat and cold thresholds use opposite tails of the same national temperature distribution. These are dataset-relative analytical thresholds, not official weather-warning thresholds. `APPROX\_QUANTILES` provides estimated percentile values, and ties at a threshold mean the qualifying share may not equal exactly 10%.

## Key Findings

### Annual weather averages

|Year|Average temperature °F|Average precipitation in|Average wind knots|
|-:|-:|-:|-:|
|2019|54.55|0.07|6.44|
|2020|55.30|0.07|6.44|
|2021|55.41|0.06|6.30|
|2022|54.51|0.06|6.70|
|2023|55.76|0.06|6.27|
|2024|56.46|0.07|6.46|

The six-year period provides descriptive annual context but is not long enough to establish a climate trend.

### State leaders

|Condition|Highest qualifying percentage|Highest qualifying count among displayed leaders|
|-|-|-|
|Unusually warm|Florida — 35.15%|Texas — 136,148|
|Unusually cold|North Dakota — 32.65%|Alaska — 126,200|
|Heavy precipitation|Arkansas — 5.51%|Florida — 8,427|
|High wind|North Dakota — 24.67%|Alaska — 76,561|
|Combined conditions|North Dakota — 47.53%|Texas — 187,161|

Counts and percentages answer different questions. Counts show the number of qualifying station observations, while percentages show how frequently a condition occurred relative to the observations available for a state.

## Combined High-Condition Exposure Indicator

An observation qualifies when at least one of the following is true:

```sql
avg\_temp\_f >= 79.2
OR avg\_temp\_f <= 29.4
OR precipitation\_in >= 0.78
OR avg\_wind\_knots >= 11.5
```

The `OR` logic counts a station-date row once even when it meets more than one condition.

|Rank|State|Total observations|Qualifying observations|Percentage|
|-:|-|-:|-:|-:|
|1|North Dakota|94,490|44,911|47.53%|
|2|Alaska|411,474|179,595|43.65%|
|3|Texas|440,937|187,161|42.45%|
|4|Florida|239,009|99,378|41.58%|
|5|South Dakota|57,694|23,558|40.83%|
|6|Louisiana|120,965|47,755|39.48%|
|7|Montana|87,214|33,568|38.49%|
|8|Kansas|94,997|36,029|37.93%|
|9|Wyoming|75,866|28,440|37.49%|
|10|Minnesota|213,383|77,922|36.52%|

## Recommendations

1. **Long-term monitoring:** Extend the analysis beyond six years and use consistent-station or geographic weighting before evaluating long-term climate patterns.
2. **Heat preparedness:** Conduct deeper heat analysis for Florida, Texas, Louisiana, and Arizona using population vulnerability, cooling access, urban heat, and health data.
3. **Cold preparedness:** Assess winter readiness in North Dakota, Alaska, Minnesota, and Wyoming using infrastructure, outage, and emergency-response data.
4. **Rain and flood preparedness:** Evaluate drainage and flood readiness in Arkansas, Alabama, Mississippi, Louisiana, and Florida using terrain, flood-zone, drainage, and event-duration data.
5. **Wind resilience:** Assess wind resilience in North Dakota, South Dakota, Kansas, Alaska, and Montana using gust measurements, official thresholds, and infrastructure-design data.
6. **Multi-condition screening:** Prioritize North Dakota, Alaska, Texas, and Florida for deeper analysis that incorporates population, assets, vulnerability, event severity, and historical losses.
7. **Data governance:** Automate checks for sentinel values, implausible temperatures, duplicate station-date keys, annual row-count changes, and missingness.

## Limitations

* Station observations are not weighted by population or geographic area.
* Station density and reporting coverage vary between states.
* Multiple stations can contribute observations for the same state and date.
* The six-year period is insufficient for a strong long-term climate-trend conclusion.
* Percentile thresholds are relative to this dataset and period, not official warning standards.
* The combined indicator measures frequency, not severity or complete risk.
* Population, infrastructure, vulnerability, and financial-loss data are not included.
* Snow depth and wind-gust variables were excluded because of high missingness.

## Repository Structure

```text
US-Extreme-Weather-SQL-Analysis/
├── README.md
├── SQL/
├── Documentation/
│   └── US\_Extreme\_Weather\_Risk\_Analysis\_Professional\_Case\_Study.pdf
├── Screenshots/
├── Data-Dictionary.md
├── Data-Source-and-License.md
└── LICENSE
```

## Project Deliverables

* Documented Standard SQL queries
* Reusable BigQuery analytical view
* Source and view validation queries
* Data-quality and anomaly investigation
* State-level heat, cold, precipitation, and wind analysis
* Combined high-condition exposure analysis
* Professional PDF case study
* Selected BigQuery result screenshots

## Author

**Vaibhav Soni**



