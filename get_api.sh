#! /bin/bash

source .env
# City coordinates: Ho Chi Minh City
# Go to https://www.latlong.net/ to get city coordinates
latitude=10.776530
longitude=106.700977

curl -s "https://api.openweathermap.org/data/2.5/forecast?lat=${latitude}&lon=${longitude}&appid=${API_KEY}&units=metric"