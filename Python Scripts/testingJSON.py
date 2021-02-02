import re
import json


with open('./tutorial/tutorial/spiders/flightFiles.json') as f:
    data = json.load(f)

for flight in data['Flights']:
    
    #print(flight['FlightNo'])
    print("Flight {}, departing {} at {}, and arriving in {} at {}. \nTerminal: {}.\nFlight Status:{}\n\n".format(flight['FlightNo'],flight['Origin'],flight['Departure'],flight['Destination'],flight['Arrival'],flight['Terminal'],flight['Status']))
