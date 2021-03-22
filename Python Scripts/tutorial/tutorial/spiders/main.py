import scrapy
from scrapy.crawler import CrawlerProcess
import ryanair_flights
import google.cloud.logging
import logging
from datetime import time

import traceback


#client = google.cloud.logging.Client()
# client.get_default_handler()
# client.setup_logging()

try:
    def scrapeRyan(data, context):
        # if __name__ == "__main__":
        try:
            process = CrawlerProcess()
            process.crawl(ryanair_flights.FlightsSpider)
            process.start()
        except Exception as e:
            error_message = traceback.format_exc().replace('\n', '  ')
            logging.error(error_message)
            # logger.error(f"Trace:{traceback.format_exc()}")
            # time.sleep(5)
            #raise e
            return 'Error'
except Exception as e:
    logging.basicConfig(level=logging.INFO)
    logging.info(e)


if __name__ == "__main__":
    scrapeRyan(0, 0)
