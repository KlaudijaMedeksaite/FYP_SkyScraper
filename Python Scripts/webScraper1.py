# File: webScraper1.py

# Not used in project, just shows different ways I was trying to figure out what way to scrape information

import requests #to make requests using URL
from bs4 import BeautifulSoup #to parse HTML
from collections import defaultdict

URLRyanair = 'https://www.ryanair.com/flights/ie/en'


page = requests.get(URLRyanair)

soup = BeautifulSoup(page.content, 'html.parser')
results = soup.find("div",{"class":"rich-text"})
Rlocations = results.find_all('li')

countryKey = ""
cityValue = ""
locDict = defaultdict(list)

# putting ryanair countries and cities into location map
for location in Rlocations:

    if "Skip" not in location.text:
    
        countryKey = location.text.strip().split("|",1)[0]
        countryKey = countryKey.replace('\xa0','')
        
        citList = (location.text.strip().split("|",1)[1])
        citList = citList.replace('\xa0','')
        
        citList = citList.split(",")
        
        for i in citList:
            cityValue = i.replace(',','')
            #creating a map of country:city
            locDict[countryKey].append(cityValue)

           
    else:
        break


value = input("Please enter departure country:\n")
 
print(f'Airport cities in ' + value + ' for Ryanair')

cities = locDict.get(value.strip())
for i in cities:
    print(i)

#Ref: https://realpython.com/beautiful-soup-web-scraper-python/#part-2-scrape-html-content-from-a-page

