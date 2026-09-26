# Data Source and Usage Information

## Project

**U.S. Extreme Weather Risk Analysis**

## Primary Data Provider

The weather data used in this project was produced by the **National Oceanic and Atmospheric Administration (NOAA)** and is maintained through the National Centers for Environmental Information (NCEI).

Dataset:

**Global Surface Summary of the Day (GSOD)**

Official NOAA metadata:

https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc%3AC00516

## Google BigQuery Source

The NOAA data was accessed through the Google Cloud BigQuery Public Datasets program.

Weather tables:

`bigquery-public-data.noaa\_gsod.gsod\*`

Station information:

`bigquery-public-data.noaa\_gsod.stations`

Google Cloud documentation:

https://cloud.google.com/bigquery/public-data

## Analysis Scope

This project uses:

* Daily weather observations from 2019 through 2024
* Monitoring stations located in the 50 U.S. states
* NOAA weather measurements including temperature, precipitation, snow depth and wind speed
* NOAA station information including station identifiers, names and state codes

The District of Columbia, Puerto Rico and the U.S. Virgin Islands were excluded to maintain a consistent 50-state analysis scope.

## Data Usage

Information produced by the U.S. government and presented on government servers is generally in the public domain in the United States unless specifically marked otherwise. Applicable rights may differ outside the United States.

Users of the data should:

* Credit NOAA as the original data provider.
* Not claim ownership of the original NOAA data.
* Not imply that NOAA or Google endorses this project.
* Not present modified information as an official NOAA product.
* Review the official metadata and usage information before reusing the data.

Official NOAA usage and disclaimer information:

https://psl.noaa.gov/disclaimer/

## Attribution

Suggested attribution:

> Weather data used in this project was provided by the National Oceanic and Atmospheric Administration (NOAA) and accessed through the Google Cloud BigQuery Public Datasets program.

## Repository Content and License Scope

The SQL queries, documentation and analytical interpretations in this repository were created by **Vaibhav Soni**.

Any license included with this repository applies only to the original repository content created for this project. It does not transfer ownership of, or impose a new license on, the original NOAA data.

The repository does not redistribute the complete NOAA source dataset. The analysis can be reproduced by accessing the public BigQuery tables listed above.

## Disclaimer

This project was created for portfolio, educational and analytical purposes. The findings are based on historical station-level observations and should not be interpreted as official weather guidance, forecasts, emergency-management advice or an endorsement by NOAA or Google.

