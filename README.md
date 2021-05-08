# Final Year project - web scraper for flights

This is an Android app, written in Dart and using the Flutter framework, that allows the user to select the destination and date they would like to travel, or select a climate and see destinations in that climate.
Once this is selected it displays a list of flights from Ryanair that fit the criteria and would be a possible option for the user.
The user is then be able to select two flights and compare them side by side. 
Information such as time of arrival and departure and statistics of how often the flight is on time will be available to the user, enabling them to make the most informed decision before purchasing a flight.

The app is retrieving the data from a Google Cloud mySQL database, which is populated by a routinely run web scraper written in Python and using the Scrapy framework, which is deployed on Scrapy Cloud.
The Python script is scraping this website: https://ryanair.flight-status.info

In the future I will likely add more airlines than just Ryanair, as well as more features, to improve the user experience.

## Compiling and running
If you would like to actually run this app on your own Android device, simply download the apk file which can be found in the APK folder and open it on your smartphone.

In order to view the code, clone this repository and open it in an IDE of your choosing.
### The Python script 
This is running on Scrapy Cloud, however if you would like to run it your local machine follow these steps: 

1. Open Terminal and navigate to 'FYP_SkyScraper/Python Scripts/tutorial/ZYTE/tutorial/spiders/'
2. Execute: Python ryanair_flights.py

### The Flutter Code 
To run the app on your device:
1. Download the apk file from the APK folder onto your smartphone
2. Open it

To run the Flutter app from the Android studio:
1. Open Android Studio
2. Click File > Open
3. Navigate to where the cloned repository is on the pop up, you will see a little Android icon next to any Android projects
4. Open the file with the Android symbol next to it
5. To run it you can:
    a. Plug your Android device (which needs to be set to developer mode) in and press the green play button at the top to run the app.
    b. Create a virtual device in Android Studio by clicking on the phone icon with the android symbol, pressing 'create virtual device'
       Then once it is created, you can press the new play button next to the virtual device to run the app.
