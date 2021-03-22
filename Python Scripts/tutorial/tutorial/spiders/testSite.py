# test script

# scraping
import scrapy
from scrapy import Request
from scrapy.crawler import CrawlerProcess

# other
import re
from datetime import datetime
#import datetime
import os


class FlightsSpiderTst(scrapy.Spider):

    # starting log
    # logger.log_text("Starting scraper")

    name = "flightStatTest"  # identifies spider
    custom_settings = {'DOWNLOAD_DELAY': 1}

    start_urls = [
        'https://ryanair.flight-status.info/page-1',
    ]

    def parse(self, response):

        rowNum = 2
        # pageNo = 1
        print("starting parse, rowNum: ", rowNum, "\n")
        while rowNum < 34:
            #stats = open("flightStatsTst.txt", "w+")
            # stats.write("\n")
            status = ""

            # scraping info using xpath -
            # this sometimes changes if the website changes
            # last updated 08/02/2021 09:47
            status = response.xpath(
                '//*[@id="wrap-page"]/main/section[2]/div/div[1]/table/tbody/tr[{}]'.format(rowNum)).get()
            status = re.sub(r'<[^>]+>', '', status)
            status = re.sub(r'\t', '', status)
            status.strip()
            status = os.linesep.join([s for s in status.splitlines() if s])
            status = re.sub(r'\r', '', status)
            # stats.write(status.strip())
            # stats.close()
            #status = re.sub()
            lineForm = status.split("\n")
            count = 0
            while count < 7:
                print(lineForm[count])
                count = count + 1

            # writing to txt file
            #stats = open("flightStatsTst.txt", "r")

            print("Reading txt file")
            #Lines = stats.readlines()
            # stats.close()

            #lineForm = []
            #count = 0
            # for line in Lines:
            #    if line.strip():
            #        lineForm.append(line.strip())
            #        count += 1

            flightNo = lineForm[0]
            departure = lineForm[1]
            arrival = lineForm[2]
            origin = lineForm[3]
            destination = lineForm[4]
            terminal = lineForm[5]
            lastUpdate = lineForm[6]
            dateToday = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            # dateToday = dateToday.
            statusDict = {
                "FlightNo": flightNo,
                "Departure": departure,
                "Arrival": arrival,
                "Origin": origin,
                "Destination": destination,
                "Terminal": terminal,
                "Terminal2": dateToday,
                "Status": lastUpdate
            }

            print(statusDict)
            rowNum += 1

        # scraping link to next page using xpath -
        # this sometimes changes if the website changes
        # last updated 08/02/2021 09:58
        linkNextPage = response.xpath(
            '//*[@id="wrap-page"]/main/section[2]/div/div[1]/ul/li[8]/a/@href').get()
        linkNextPage = linkNextPage.strip()
        if linkNextPage.find('page-3') < 0:
            print("next page")

            yield Request(linkNextPage, callback=self.parse)

# https://ryanair.flight-status.info/page-112


if __name__ == "__main__":
    process = CrawlerProcess()
    process.crawl(FlightsSpiderTst)
    process.start()
