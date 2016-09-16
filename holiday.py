import requests,datetime
import simplejson as json # pip install simplejson
# if you dont want to use simple json, just uncomment the line under and remove the line over
# import json

# get current day
now = datetime.datetime.now()
year = "&year=" + str(now.year)
month = "&month=" + str(now.month)
day = "&day=" + str(now.day)

# URL for get requests
URL = "https://holidayapi.com/v1/holidays?key=3e2a217e-eb23-492c-9de4-4dd8b9b78d0f&country=NO" + year + month + day

# send get request and retrieve json
r = requests.get(URL)
js = json.loads(r.text) # Why you so slow man....

if js["status"] == 200: # Green lightm nothing went wrong
    if len(js["holidays"]) == 1: # It is a holiday
        print(js["holidays"][0]["name"]) # Display the name of the holiday
