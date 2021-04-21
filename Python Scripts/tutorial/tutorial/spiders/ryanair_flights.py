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
    # 'client_flags': [ClientFlag.SSL],
    # 'ssl_ca': 'ssl/server-ca.pem',
    # 'ssl_cert': 'ssl/client-cert.pem',
    # 'ssl_key': 'ssl/client-key.pem'
}


class FlightsSpider(scrapy.Spider):

    name = "RyanairflightStat"  # identifies spider
    custom_settings = {'DOWNLOAD_DELAY': 1}

    start_urls = [
        'https://ryanair.flight-status.info/page-1',
    ]

    def parse(self, response):

        # now we establish our connection
        cnxn = mysql.connector.connect(**config)
        cursor = cnxn.cursor()  # initialize connection cursor
        config['database'] = 'flightDB'  # add new database to config dict

        rowNum = 2
        # pageNo = 1
        print("starting parse, rowNum: ", rowNum, "\n")

        while rowNum < 34:
            status = ""

            # scraping info using xpath -
            # this sometimes changes if the website changes
            # last updated 08/02/2021 09:47
            status = response.xpath(
                '//*[@id="wrap-page"]/main/section[2]/div/div[1]/table/tbody/tr[{}]'.format(rowNum)).get()
            status = re.sub(r'<[^>]+>', '', status)

            # Fix response
            status = status.replace('\t', '')
            status = status.replace('\n\n', '\n')
            status = status.split('FR', 1)[1]
            status = 'FR' + status

            # Split response into vars
            try:
                flightNo, departure, arrival, origin, destination, terminal, lastUpdate, extra = status.split(
                    '\n')
            except:
                flightNo, theRest = status.split('\n', 1)
                if(flightNo == "FR4460"):
                    departure, origin, destination, terminal, lastUpdate, extra = theRest.split(
                        '\n')
                    arrival = "00:00"
                print("f_no: ", flightNo, "dep: ",  departure, "arr: ", arrival, "origin:", origin,
                      "destination: ", destination, "terminals: ", terminal, "status: ",  lastUpdate)

            # fix origin and destination to conform as foreign key
            origin, extra = str(origin).split(')', 1)
            origin = str(origin).replace('(', '')

            destination, extra = str(destination).split(')', 1)
            destination = str(destination).replace('(', '')

            # fix terminal vars to be split into two
            terminalDep, terminalArr = terminal.split(' - ')
            terminalArr = terminalArr.replace('Arrival', '')
            terminalDep = terminalDep.replace('Departure', '')

            # put all vars into list, ready to go into db
            statList = [flightNo, departure, arrival, origin,
                        destination, terminalDep, terminalArr, lastUpdate]
            print(statList)
            rowNum += 1

            # for putting into db
            cursor.execute("USE flightDB", "")
            query = "REPLACE INTO ryanair_flights (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) "
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
