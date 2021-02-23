import ryanair_flights
import scrapy
from scrapy.crawler import CrawlerProcess


def runRyan():
    if __name__ == "__main__":
        process = CrawlerProcess()
        process.crawl(ryanair_flights.FlightsSpider)
        process.start()


if __name__ == "__main__":
    runRyan()
