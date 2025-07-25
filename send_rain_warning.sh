#! /bin/bash

email="youremail@gmail.com"
time_zone=Asia/Ho_Chi_Minh
response=$(./get_city.sh)

city=$(echo "$response" | jq -r ".city.name")

today=$(TZ=$time_zone date '+%F')
tomorrow=$(TZ=$time_zone date -d "+1 day" +%F)

# Function get forecast rain time in a day
get_rain_status() {
  local date=$1
  echo "$response" | jq -r --arg date "$date" '
    .list[]
    | select(.dt_txt | startswith($date))
    | select(.weather[0].main == "Rain" or .weather[0].main == "Thunderstorm" or .weather[0].main == "Drizzle")
    | "\((.dt_txt | split(" ")[1] | split(":") | .[0] + ":" + .[1])) \(.weather[0].description)"
    ' | sort
}

today_weather=$(get_rain_status $today)
tomorrow_weather=$(get_rain_status $tomorrow)

# Print the result to ASCII format
print_ascii() {
  local weather=$1

  group_time=$(awk '{
    time = $1;
    $1 = "";
    sub(/^ /, "", $0);
    desc = $0;

    if (NR == 1) {
      prev_desc = desc;
      begin_time = time;
    }

    if (desc != prev_desc) {
      print begin_time "-" prev_time, prev_desc;
      begin_time = time;
    }

    prev_desc = desc;
    prev_time = time;
  }
  END {
    print begin_time "-" prev_time, prev_desc;
  }' <<< "$weather")

  printf "┌───────────────┬─────────────────────────────┐\n"
  printf "│     Time      │        Description          │\n"
  printf "├───────────────┼─────────────────────────────┤\n"

  while IFS= read -r line; do
    time_range=$(echo "$line" | cut -d " " -f1)
    desc=$(echo "$line" | cut -d " " -f2-)
    printf "│ %-13s │ %-27s │\n" "$time_range" "$desc"
  done <<< "$group_time"

  printf "└───────────────┴─────────────────────────────┘\n"
}

if [ -n "$today_weather" ]; then
  msg_today="WARNING: Rain possible today ($today) in $city!\n$(print_ascii "$today_weather")"
  echo -e "$msg_today"
fi

if [ -n "$tomorrow_weather" ]; then
  msg_tomorrow="WARNING: Rain possible tomorrow ($tomorrow) in $city!\n$(print_ascii "$tomorrow_weather")"
  echo -e "$msg_tomorrow"
fi

# Group email content and send mail
email_body=$(printf "%b\n%b\n" "$msg_today" "$msg_tomorrow")
echo -e "$email_body" | mail -s "☔ Weather Warning: Rain Forecast" $email