# Forecasting NYC Motor Vehicle Collision Frequency: Multiple Seasonality, Crash Severity, and Implications for Auto Insurance Risk

ADS-506 Applied Time Series Analysis — Final Team Project
University of San Diego, M.S. in Applied Data Science

**Team:** Dana Neuman, Imelda Mendoza, Samuel Scott

---

## Dataset

**NYC Motor Vehicle Collisions – Crashes** (2012–present)
Daily police-reported collision records
Official source: [NYC Open Data](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95/about_data)

The full dataset contains more than 2.3 million crash records, one row per police-reported collision, beginning in July 2012 and updated daily. The raw file is downloaded once and aggregated to daily counts in R during preprocessing. Because of its size, the raw file is not stored in this repository; it is recreated by running `R/00_download_raw.R`.

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
Contributing factor and vehicle type (vehicle 1 on each police report) are retained in the raw data for possible subseries; these fields contain many inconsistent labels and require grouping before use.

Planned supporting data:
- **Weather:** NOAA daily observations, Central Park station (USW00094728)
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
- **ARIMA / dynamic regression:** seasonal ARIMA with a weekly (period 7) seasonal component; manual and auto-selected models compared. Dynamic regression with Fourier terms and holiday/weather regressors is a planned extension.
- **ETS:** applied to aggregated weekly series as an additional comparison
- **Structural break:** crashes dropped by about half in 2020 and did not recover, so models are trained on post-2020 data only.

**Train/test split (all models):** train on 2021–2024, test on 2025.

---

## Repository Structure

```
R/
  00_download_raw.R         Downloads the raw crash file (run once)
  01_preprocessing.Rmd      Cleans raw data and builds the daily series
  02_eda.Rmd                Exploratory data analysis
  03_arima.qmd              ARIMA model
  03_ets.qmd                ETS model
  03_tslm.qmd               Time series regression model
  04_model_comparison.qmd   All models scored on the test set (planned)
  05_final_forecast.qmd     Final forecast and interpretation (planned)
data/
  nyc_daily_crashes.csv     Daily crash series (output of 01_preprocessing)
  raw/                      Raw download (not tracked by Git)
figures/                    Final figures for the report and presentation
README.md
```

## Reproducing the Analysis

1. Run `R/00_download_raw.R` with the working directory set to the project folder (Session > Set Working Directory > To Project Directory). The download is several hundred MB.
2. Run `R/01_preprocessing.Rmd` to build `data/nyc_daily_crashes.csv`.
3. Each analysis file loads the daily series with:

```r
crash_ts <- read.csv("../data/nyc_daily_crashes.csv") |>
  mutate(day = as.Date(day)) |>
  as_tsibble(index = day)
```

Required packages: `fpp3`, `data.table`

Required packages: `fpp3`, `data.table`
---

## Project History

This project originally forecast U.S. private passenger auto insurance loss ratios. Following instructor feedback, the team changed to the NYC collision dataset. The earlier insurance work is preserved on the `insurance-archive` branch.

### References

Hyndman, R. J., & Athanasopoulos, G. (2021). Forecasting: Principles and Practice (3rd ed.). OTexts.

https://otexts.com/fpp3/

## AI Use Disclosure

Claude (Anthropic) was used to help structure the repository, draft data processing code, and work through modeling steps. All code and results were reviewed and modified by the team.
