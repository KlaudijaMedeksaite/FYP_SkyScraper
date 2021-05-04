# test

from datetime import date

flightDay = date.today().weekday()

if(flightDay == 0):
    flightDay = "Monday"
elif(flightDay == 1):
    flightDay = "Tuesday"
elif(flightDay == 2):
    flightDay = "Wednesday"
elif(flightDay == 3):
    flightDay = "Thursday"
elif(flightDay == 4):
    flightDay = "Friday"
elif(flightDay == 5):
    flightDay = "Saturday"
elif(flightDay == 6):
    flightDay = "Sunday"

print(flightDay)
