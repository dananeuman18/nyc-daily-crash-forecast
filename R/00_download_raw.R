# download raw file from NYC Open Data

options(timeout = 3600)
dir.create("data/raw", showWarnings = FALSE)

download.file(
  url = "https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD",
  destfile = "data/raw/crashes_raw.csv"
)

