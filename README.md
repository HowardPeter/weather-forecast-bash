# Weather Forecast Accuracy Monitoring System

This project consists of a set of bash scripts that work together to monitor and analyze the accuracy of weather forecasts for Hanoi, Vietnam. The system fetches weather data, compares forecasts with actual temperatures, and generates statistical analysis of forecast accuracy.

## Components

### 1. Weather Data Collection (`rx_poc.sh`)
- Fetches current weather data and forecasts for Hanoi using wttr.in API
- Records current temperature and next day's forecast
- Logs data in tab-separated format with timestamp (year, month, day)
- Output is stored in `rx_poc.log`

### 2. Forecast Accuracy Analysis (`fc_accuracy.sh`)
- Compares yesterday's forecast with today's actual temperature
- Calculates forecast accuracy (difference between forecast and actual)
- Categorizes accuracy into ranges:
  - Excellent: ±1°C
  - Good: ±2°C
  - Fair: ±3°C
  - Poor: > ±3°C
- Logs results to `historical_fc_accuracy.tsv` in tab-separated format

### 3. Weekly Statistics (`weekly_stats.sh`)
- Analyzes the last 7 days of forecast accuracy data
- Calculates and reports:
  - Minimum absolute error
  - Maximum absolute error
- Uses `scratch.txt` as temporary storage for calculations

## Usage

1. Initial data collection:
```bash
./rx_poc.sh
```

2. Calculate forecast accuracy (run daily):
```bash
./fc_accuracy.sh
```

3. Generate weekly statistics:
```bash
./weekly_stats.sh
```

## Data Files
- `rx_poc.log`: Raw weather data and forecasts
- `historical_fc_accuracy.tsv`: Detailed forecast accuracy records
- `scratch.txt`: Temporary file for weekly statistics calculations

## Time Zone
The system is configured for Asia/Ho_Chi_Minh timezone to ensure accurate timestamp recording.

## Dependencies
- `curl`: Required for fetching weather data
- `bash`: Scripts are written for bash shell
- Internet connection to access wttr.in API