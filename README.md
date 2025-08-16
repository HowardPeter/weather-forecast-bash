# Weather Forecast Bash Project

A collection of bash scripts for fetching and displaying weather information for Ho Chi Minh City using the OpenWeatherMap API.

## Features

- **Current Weather**: Get real-time weather data including temperature, humidity, wind speed, and description
- **5-Day Forecast**: Display weather forecast with average, minimum, and maximum temperatures plus rain predictions
- **Rain Warnings**: Send email alerts for potential rain today and tomorrow
- **CSV Logging**: Automatically save weather data to CSV files for record keeping
- **Automated Scheduling**: Cron job support for regular weather updates

## Prerequisites

- Bash shell
- `curl` command
- `jq` JSON processor
- `mail` command (for email notifications)
- OpenWeatherMap API key

## Setup

1. **Install required dependencies:**
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install curl jq mailutils

   # On CentOS/RHEL
   sudo yum install curl jq mailx
   ```

2. **Get OpenWeatherMap API key:**
   - Sign up at [OpenWeatherMap](https://openweathermap.org/api)
   - Get your free API key
   - Update the `.env` file with your API key

3. **Configure location:**
   - The scripts are currently set for Ho Chi Minh City (latitude: 10.776530, longitude: 106.700977)
   - To change location, update the coordinates in `current_weather.sh` and `get_city.sh`
   - Find coordinates at [LatLong.net](https://www.latlong.net/)

## How to Use This Project

### 1. Current Weather Information
Get current weather conditions:
```bash
./current_weather.sh
```
**Output:**
- Displays current temperature, humidity, wind speed, and weather description
- Saves data to `today_weather.csv` file

### 2. 5-Day Weather Forecast
Get detailed 5-day weather forecast:
```bash
./fc_weather.sh
```
**Output:**
- Shows a formatted table with daily average, minimum, and maximum temperatures
- Indicates rain forecast for each day
- Saves forecast data to `forecast_report.csv`

### 3. Rain Warning Alerts
Send email notifications for potential rain:
```bash
./send_rain_warning.sh
```
**Output:**
- Checks for rain today and tomorrow
- Sends formatted email alerts with time ranges and descriptions
- Requires email configuration in the script

### 4. Automated Weather Updates
Set up automatic weather data collection:
```bash
# Install the cron job
crontab cronjob.txt
```
This runs the current weather script daily at 12:00 PM.

## File Structure

```
weather-forecast/
├── current_weather.sh      # Get current weather data
├── fc_weather.sh          # 5-day weather forecast
├── get_city.sh           # Fetch weather data from API
├── send_rain_warning.sh  # Email rain alerts
├── .env                  # API key configuration
├── cronjob.txt          # Cron job configuration
├── today_weather.csv    # Current weather log
└── forecast_report.csv  # Forecast data log
```

## Configuration

### Environment Variables
Edit `.env` file:
```bash
API_KEY="your_openweathermap_api_key_here"
```

### Email Configuration
Update email address in `send_rain_warning.sh`:
```bash
email="your-email@example.com"
```

### Location Settings
Update coordinates in `current_weather.sh` and `get_city.sh`:
```bash
latitude=your_latitude
longitude=your_longitude
```

## ⚠️ Troubleshooting: `cannot execute: required file not found`

When cloning this project on **Windows** and running scripts in **WSL/Linux**, you may see:
```bash
bash: ./fc_weather.sh: cannot execute: required file not found
```

### How to fix:

1. Ensure the scripts have executable permissions:
```bash
chmod +x get_api.sh current_weather.sh fc_weather.sh send_rain_warning.sh
```
2. Convert line endings to LF:
```bash
sed -i 's/\r$//' get_api.sh current_weather.sh fc_weather.sh send_rain_warning.sh
```
3. Run scripts again.

## Output Examples

### Current Weather
```
City           : Ho Chi Minh City
Temperature    : 28.5 °C
Humidity       : 75%
Wind speed     : 3.2 km/h
Description    : scattered clouds
Local time     : 2024-01-15 14:30:25 UTC+07
```

### 5-Day Forecast
```
City: Ho Chi Minh City
┌────────────┬─────────────┬───────────────────┬─────────────┬─────────────┐
│    Date    │ Avg Temp °C │  Rain Forecast    │ Min Temp °C │ Max Temp °C │
├────────────┼─────────────┼───────────────────┼─────────────┼─────────────┤
│ 2024-01-15 │        28.5 │ No rain           │        25.2 │        31.8 │
│ 2024-01-16 │        27.8 │ Possible rain     │        24.5 │        30.2 │
└────────────┴─────────────┴───────────────────┴─────────────┴─────────────┘
```

## License

This project is open source and available under the MIT License.