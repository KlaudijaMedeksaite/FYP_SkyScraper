import scrapy
import re
import json
from scrapy import Request
from scrapy.crawler import CrawlerProcess
import mysql.connector
from mysql.connector.constants import ClientFlag

config = {
    'user': 'root',
    'password': '12345',
    'host': '34.123.203.246',
    'client_flags': [ClientFlag.SSL],
    'ssl_ca': 'ssl/server-ca.pem',
    'ssl_cert': 'ssl/client-cert.pem',
    'ssl_key': 'ssl/client-key.pem'
}


class FlightsSpider(scrapy.Spider):

    name = "flightStat"  # identifies spider
    custom_settings = {'DOWNLOAD_DELAY': 1}

    start_urls = [
        'https://ryanair.flight-status.info/page-1',
    ]
    fly = open("flightFiles.json", "w+")
    fly.write('{"Flights":[\n')
    fly.close()

    def parse(self, response):

        # now we establish our connection
        cnxn = mysql.connector.connect(**config)
        cursor = cnxn.cursor()  # initialize connection cursor
        config['database'] = 'ryanairdb'  # add new database to config dict

        rowNum = 2
        #pageNo = 1
        print("starting parse, rowNum: ", rowNum, "\n")

        while rowNum < 34:
            stats = open("flightStats.txt", "w+")
            stats.write("\n")
            status = ""

            # scraping info using xpath -
            # this sometimes changes if the website changes
            # last updated 08/02/2021 09:47
            status = response.xpath(
                '//*[@id="wrap-page"]/main/section[2]/div/div[1]/table/tbody/tr[{}]'.format(rowNum)).get()
            status = re.sub(r'<[^>]+>', '', status)
            print(status.strip())
            stats.write(status.strip())
            stats.close()

            # writing to txt file
            stats = open("flightStats.txt", "r")
            Lines = stats.readlines()
            stats.close()

            lineForm = []
            count = 0
            for line in Lines:
                if line.strip():
                    lineForm.append(line.strip())
                    count += 1

            flightNo = lineForm[0]
            departure = lineForm[1]
            arrival = lineForm[2]
            origin = lineForm[3]
            destination = lineForm[4]
            terminal = lineForm[5]
            lastUpdate = lineForm[6]

            statList = [flightNo, departure, arrival, origin,
                        destination, terminal, terminal, lastUpdate]
            statusDict = {
                "FlightNo": flightNo,
                "Departure": departure,
                "Arrival": arrival,
                "Origin": origin,
                "Destination": destination,
                "Terminal": terminal,
                "Terminal2": terminal,
                "Status": lastUpdate
            }

            print(statusDict)
            rowNum += 1

            # for putting into db
            cursor.execute("USE ryanairdb", "")
            query = "REPLACE INTO flight_info (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) "
            cursor.execute(query, statList)

        # scraping link to next page using xpath -
        # this sometimes changes if the website changes
        # last updated 08/02/2021 09:58
        linkNextPage = response.xpath(
            '//*[@id="wrap-page"]/main/section[2]/div/div[1]/ul/li[8]/a/@href').get()
        linkNextPage = linkNextPage.strip()
        if linkNextPage.find('page-140') < 0:
            yield Request(linkNextPage, callback=self.parse)

        cnxn.commit()  # this commits changes to the database

# https://ryanair.flight-status.info/page-112


if __name__ == "__main__":
    process = CrawlerProcess()
    process.crawl(FlightsSpider)
    process.start()
