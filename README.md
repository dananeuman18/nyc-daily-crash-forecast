# Forecasting NYC Motor Vehicle Collision Frequency: Multiple Seasonality, Crash Severity, and Implications for Auto Insurance Risk

ADS-506 Applied Time Series Analysis — Final Team Project
University of San Diego, M.S. in Applied Data Science

**Team:** Dana Neuman, Imelda Mendoza, Samuel Scott

---

## Dataset

**NYC Motor Vehicle Collisions – Crashes** (2012–present)
Daily police-reported collision records
Official source: [NYC Open Data](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95/about_data)

The full dataset contains more than 2.3 million crash records, one row per police-reported collision, beginning in July 2012 and updated daily. For this project, records are aggregated to daily counts through the NYC Open Data API, so the full raw file does not need to be downloaded or stored in this repository.

Daily series used in the analysis:

| Series | Description |
|---|---|
| `crashes` | Total police-reported collisions |
| `injured` / `killed` | Persons injured and killed (severity) |
| `ped_injured` | Pedestrians injured |
| `cyc_injured` | Cyclists injured |
| `mot_injured` | Motorists injured |

Contributing factor and vehicle type subseries are pulled separately by grouping on `contributing_factor_vehicle_1` and `vehicle_type_code1`.

Supporting data:
- **Weather:** NOAA daily observations, Central Park station (USW00094728) — precipitation, snowfall, temperature
- **Holidays and daylight saving time:** indicator variables created in R

---

## Problem Statement

Motor vehicle collisions contribute significantly to personal injuries, property damage, economic losses, and automobile insurance claims. Understanding and accurately forecasting collision frequency can help improve public safety planning, emergency resource allocation, and the assessment of automobile insurance risk.

Currently, historical collision records are available through the NYC Open Data Motor Vehicle Collisions dataset, which contains police-reported crash information dating back to 2012. However, daily collision frequency is influenced by multiple factors, including weekly and annual seasonal patterns, weather conditions, holidays, road-user characteristics, and changes in traffic behavior. The substantial change in collision counts following 2020 also presents a potential structural break that may affect forecasting accuracy.

The primary objective of this project is to develop and compare time-series forecasting models for daily motor vehicle collision frequency in New York City. The analysis will investigate multiple seasonal components and examine subseries based on collision severity, road-user involvement, contributing factors, and vehicle types. An additional objective is to investigate whether daylight saving time transitions are associated with changes in collision frequency using dynamic regression while controlling for weather and holiday effects.

Forecasting performance will be evaluated using a chronological training and testing framework. The primary success criterion is to outperform the seasonal naive forecasting benchmark on the test dataset, measured using Mean Absolute Error (MAE), with a Mean Absolute Scaled Error (MASE) below one as an additional performance target.

An inaccurate forecast could lead to inefficient allocation of emergency services, inadequate preparation for periods of elevated collision activity, and misleading assessments of potential automobile insurance exposure. Therefore, the project will emphasize forecasting accuracy, model reliability, and the practical interpretation of the results.

---

## Methods

All modeling follows *Forecasting: Principles and Practice* (3rd ed.) using the `fpp3` packages in R.

- **Benchmark:** Seasonal naive (weekly period)
- **Time series regression (TSLM):** trend, seasonal dummies, and Fourier terms
- **ARIMA / dynamic regression:** Fourier terms for annual seasonality, with weather, holiday, and daylight saving time regressors
- **ETS:** applied to aggregated weekly series as an additional comparison
- **Structural break:** the post-2020 level shift is handled with an indicator variable and/or a post-break training window

Models are trained on earlier years and evaluated on a held-out test period at the end of the series.

---

## Repository Structure

```
data/        Aggregated daily CSVs (crash counts, weather)
R/           Analysis scripts, numbered in run

14. References

Hyndman, R. J., & Athanasopoulos, G. (2021). Forecasting: Principles and Practice (3rd ed.). OTexts.

https://otexts.com/fpp3/


