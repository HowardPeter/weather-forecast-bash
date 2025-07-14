#! /bin/bash
city_name=hanoi
curl -s wttr.in/$city_name?T --output weather_report

obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*' | cut -d "(" -f1)
echo "The current Temperature of $city: $obs_temp °C"
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*' | cut -d "(" -f1)
echo "The forecasted temperature for noon tomorrow for $city : $fc_temp °C"

TZ=Asia/Ho_Chi_Minh

current_date=$(TZ=Asia/Ho_Chi_Minh date +'%d')
current_month=$(TZ=Asia/Ho_Chi_Minh date +'%m')
current_year=$(TZ=Asia/Ho_Chi_Minh date +'%Y')

record=$(echo -e "$current_year\t$current_month\t$current_date\t$obs_temp\t$fc_temp C")
echo $record>>rx_poc.log