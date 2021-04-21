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
    with open('airports.txt') as airport_file:
        print("reading airports txt file")
        for line in airport_file:
            count = count + 1
            try:
                airportCode, country = line.split(',')
            except:
                airportCode, country, extra = line.split(',')
                country = country + " " + extra

            try:
                airportCode, city = airportCode.split(')')
            except:
                airportCode, city, extra = airportCode.split(')')
                city = city + " " + extra

            airportCode = airportCode.replace('(', '')
            country = country.replace('\n', '')
            airportInfo = [airportCode, city, country]

            print("\nAirport info: ")
            print(airportInfo)
            # for putting into db
            print("about to query")
            cursor.execute("USE flightDB", "")
            query = "REPLACE INTO airports (code, city, country) VALUES (%s, %s, %s)"
            cursor.execute(query, airportInfo)
            print("query exectuted " + str(count))
            print("committing to db")
            cnxn.commit()  # this commits changes to the database


if __name__ == "__main__":
    updateAirports()
