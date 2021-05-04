# Python script to update airport table
import mysql.connector
from mysql.connector.constants import ClientFlag

config = {
    'user': 'root',
    'password': '12345',
    'host': '34.123.203.246'
}


def readAirports():
    lines = ""
    # connect to db
    cnxn = mysql.connector.connect(**config)
    cursor = cnxn.cursor()
    config['database'] = 'flightDB'

    sql_select_Query = "USE flightDB; select * from airports"

    cursor.execute(sql_select_Query, multi=True)
    records = cursor.fetchall()
    print("Total number of rows in table: ", cursor.rowcount)

    print("\nPrinting each row")
    for row in records:
        print("Code = ", row[0], )
        print("City = ", row[1])
        print("Country  = ", row[2], "\n")


def updateAirports():
    # connect to db
    cnxn = mysql.connector.connect(**config)
    cursor = cnxn.cursor()
    config['database'] = 'flightDB'

    # vars
    airportCode = ""
    city = ""
    country = ""
    extra = ""
    count = 0

    # parsing list
    with open('airports_db.txt') as airport_file:
        print("reading airports txt file")
        for line in airport_file:

            count = count + 1
            airportCode, country, city, climate = line.split(',', 3)

            airportCode = airportCode.strip()
            country = country.strip()
            city = city.strip()
            climate = climate.strip()

            print("\nCode: " + airportCode + "\nCountry: " + country +
                  "\nCity: " + city + "\nClimate: " + climate)

            airportInfo = [airportCode, country, city, climate]

            print("about to query")
            cursor.execute("USE flightDB", "")
            query = "REPLACE INTO airports (code, country, city, climate) VALUES (%s, %s, %s, %s)"
            cursor.execute(query, airportInfo)
            print("query exectuted " + str(count))
            print("committing to db")
            cnxn.commit()  # this commits changes to the database


if __name__ == "__main__":
    updateAirports()
