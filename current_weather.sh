#! /bin/bash

source .env

# City coordinates: Ho Chi Minh City
# Go to https://www.latlong.net/ to get city coordinates
latitude=10.776530
longitude=106.700977
response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${API_KEY}&units=metric")

if [ $? -ne 0 ] || [ -z "$response" ]; then
    echo "ERROR: Failed to fetch weather data. Please check your internet connection or API key."
    exit 1
fi

time_zone=Asia/Ho_Chi_Minh
csv_file="today_weather.csv"

city=$(echo "$response" | jq -r ".name")

# Get temperature, weather description, humidity and wind speed
temp=$(echo "$response" | jq -r ".main.temp")
desc=$(echo "$response" | jq -r ".weather[0].description")
humidity=$(echo "$response" | jq -r ".main.humidity")
w_speed=$(echo "$response" | jq -r ".wind.speed")

local_time=$(TZ=$time_zone date '+%F %H:%M:%S UTC%Z')

printf "%-15s: %s\n" "City" "$city"
printf "%-15s: %s °C\n" "Temperature" "$temp"
printf "%-15s: %s%%\n" "Humidity" "$humidity"
printf "%-15s: %s m/s\n" "Wind speed" "$w_speed"
printf "%-15s: %s\n" "Description" "$desc"
printf "%-15s: %s\n" "Local time" "$local_time"

if [ ! -f "$csv_file" ]; then
  touch $csv_file
  # Add a UTF-8 BOM for compatibility with Excel
  echo -e '\xEF\xBB\xBF"City","Temperature (°C)","Humidity (%)","Wind Speed (m/s)","Description","Time"' > $csv_file
fi

# If the result is not null, send to csv file
if [[ "$city" != "null" || "$temp" != "null" || "$humidity" != "null" || "$w_speed" != "null" || "$desc" != "null" ]]; then
  # Request the record permission to csv file
  echo -n "Do you want to record this weather to '$csv_file'? (y/n): "
  read -r confirm
  if [[ "$confirm" != "y" ]]; then
    exit 0
  fi
  
  csvrecord=$(echo "\"$city\",\"$temp\",\"$humidity\",\"$w_speed\",\"$desc\",\"$local_time\"")
  echo $csvrecord>>$csv_file
  echo "The weather has been recorded to '$csv_file'"
fi