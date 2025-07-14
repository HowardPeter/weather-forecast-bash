#!/bin/bash

EMAIL_TO="youremail@gmail.com"
EMAIL_SUBJECT="🌤️ BWeather report from rx_poc.log - $(date +'%Y-%m-%d')"
EMAIL_BODY="This is the recorded weather log:\n"
EMAIL_BODY+="$(cat rx_poc.log)"

echo -e "$EMAIL_BODY" | mail -s "$EMAIL_SUBJECT" "$EMAIL_TO"

if [ $? -eq 0 ]; then
    echo "The weather log was sent to $EMAIL_TO"
else
    echo "Send email failed!"
fi
