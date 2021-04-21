# creating airport-table
import mysql.connector
from mysql.connector.constants import ClientFlag

config = {
    'user': 'root',
    'password': '12345',
    'host': '34.123.203.246'
}


# now we establish our connection
cnxn = mysql.connector.connect(**config)
cursor = cnxn.cursor()  # initialize connection cursor
# create a new 'ryanairdb' database
cursor.execute('CREATE DATABASE IF NOT EXISTS flightDB')
cnxn.close()  # close connection because we will be reconnecting to ryanairdb
config['database'] = 'flightDB'  # add new database to config dict
cnxn = mysql.connector.connect(**config)
cursor = cnxn.cursor()  # initialize connection cursor

cursor.execute("CREATE TABLE IF NOT EXISTS airports ("
               "code VARCHAR(255),"
               "city VARCHAR(255),"
               "country VARCHAR(255),"
               "PRIMARY KEY(code))")

cursor.execute("CREATE TABLE IF NOT EXISTS ryanair_flights ("
               "flight_no VARCHAR(255),"
               "depart_time VARCHAR(255),"
               "arrive_time VARCHAR(255),"
               "origin VARCHAR(255),"
               "destination VARCHAR(255),"
               "depart_terminal VARCHAR(255),"
               "arrive_terminal VARCHAR(255),"
               "update_time VARCHAR(255),"
               "flight_status VARCHAR(255),"
               "tracking_status VARCHAR(255),"
               "PRIMARY KEY(flight_no),"
               "FOREIGN KEY(origin) REFERENCES airports(code),"
               "FOREIGN KEY(destination) REFERENCES airports(code))")


cnxn.commit()  # this commits changes to the database
