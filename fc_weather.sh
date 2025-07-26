#! /bin/bash

response=$(./get_api.sh)

if [ $? -ne 0 ] || [ -z "$response" ]; then
    echo "ERROR: Failed to fetch weather data. Please check your internet connection or API key."
    exit 1
fi

csv_file="forecast_report.csv"

# Get city
city=$(echo "$response" | jq -r ".city.name")

# Get dates
dates=$(echo "$response" | jq -r '.list[] | .dt_txt | split(" ")[0]' | sort | uniq)

# Get average temeprature in the next 5 days
avg_temp_5d=$(echo "$response" | jq -r '.list[] | "\(.dt_txt | split(" ")[0]) \(.main.temp)"' | \
awk '{
  sum[$1] += $2;
  count[$1]++;
}
END {
  for (day in sum) {
    avg_temp=sum[day]/count[day];
    printf "%.1f\n", avg_temp;
  }
}' | sort)

# Get rain forecast in the next 5 days
rain_fc=$(echo "$response" | jq -r '.list[] | "\(.dt_txt | split(" ")[0]) \(.weather[0].id)"' | \
awk '{
  date = $1;
  code = substr($2, 1, 1);
  count[date,code]++;
  dates[date] = 1;
  codes[code] = 1;
}
END {
  for (d in dates) {
    hasRain = 0;
    for (c in codes) {
      if ((d, c) in count && c >= 3 && c <= 5) {
        hasRain = 1;
        break;
      }
    }
    if (hasRain) {
      printf("Possible rain\n");
    } else {
      printf("No rain\n");
    }
  }
}' | sort)

# Get max temeprature in the next 5 days
max_temp=$(echo "$response" | jq -r '.list[] | "\(.dt_txt | split(" ")[0]) \(.main.temp_max)"' | \
awk '{
  date = $1;
  temp = $2 + 0;
  if (temp > max_temp[date]) {
    max_temp[date] = temp;
  }
}
END {
  for (d in max_temp) {
    printf "%.1f\n",max_temp[d];
  }
}' | sort)

# Get min temeprature in the next 5 days
min_temp=$(echo "$response" | jq -r '.list[] | "\(.dt_txt | split(" ")[0]) \(.main.temp_min)"' | \
awk '{
  date = $1;
  temp = $2 + 0;
  if(!(date in min_temp) || min_temp[date] > temp){
    min_temp[date] = temp;
  }
}
END {
  for (d in min_temp) {
    printf "%.1f\n", min_temp[d];
  }
}' | sort)

# Paste 5 data columns
record=$(paste -d ',' <(echo "$dates") <(echo "$avg_temp_5d") <(echo "$rain_fc") <(echo "$min_temp") <(echo "$max_temp"))

# Print forecast result by ASCII format
echo "City: $city"
echo "┌────────────┬─────────────┬───────────────────┬─────────────┬─────────────┐"
echo "│    Date    │ Avg Temp °C │  Rain Forecast    │ Min Temp °C │ Max Temp °C │"
echo "├────────────┼─────────────┼───────────────────┼─────────────┼─────────────┤"

while IFS=',' read -r date avg rain min max; do
  printf "│ %-10s │ %11s │ %-17s │ %11s │ %11s │\n" "$date" "$avg" "$rain" "$min" "$max"
done <<< "$record"

echo "└────────────┴─────────────┴───────────────────┴─────────────┴─────────────┘"

# Request the record permission to csv file
echo -n "Do you want to record this weather to '$csv_file'? (y/n): "
read -r confirm
if [[ "$confirm" != "y" ]]; then
  exit 0
fi

# Save forecast reports to csv file
while IFS= read -r row; do
  row_date=$(echo "$row" | cut -d "," -f1)

  found=false
  while IFS=',' read -r col1 _; do
    if [ "$row_date" = "$col1" ]; then
      found=true
      break
    fi
  done < $csv_file

  if [ "$found" = false ]; then
    echo $row >> $csv_file
  fi
done <<< "$record"

echo "The forecast weather of the next 5 days has been recorded to '$csv_file'"