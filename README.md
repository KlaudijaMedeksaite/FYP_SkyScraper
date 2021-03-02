# FYP_SkyScraper
Final Year project - web scraper for flights

This will be an Android app, written in Dart, that will allow the user to select the destination and date they would like to travel. 
Once this is selected it will display a list of flights and airlines that would fit the criteria. 
The user will then be able to select two (or more, in the future) flights and compare them side by side. 
Information such as time of arrival and departure, terminal numbers and statistics of when the flight was on time will be available to the user, enabling them to make the most informed decision.
The app will be getting the information from a cloud mySQL database, which will be populated by a routinely run web scraper written in Python, also deployed on the cloud.
The Python script will be scraping a website (https://ryanair.flight-status.info) using scrapy to begin with.
Once everything is up and running I will add more airlines than just Ryanair, as well as more features, improving the user experience.
