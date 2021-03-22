# scraping
import scrapy
from scrapy import Request
from scrapy.crawler import CrawlerProcess

# logging
import google.cloud.logging
import logging

# db
import mysql.connector
from mysql.connector.constants import ClientFlag

# other
import re
from datetime import datetime
import os
import sqlalchemy

# CONNECT TO DB METHODS


def init_connection_engine():
    db_config = {
        # [START cloud_sql_mysql_sqlalchemy_limit]
        # Pool size is the maximum number of permanent connections to keep.
        "pool_size": 5,
        # Temporarily exceeds the set pool_size if no connections are available.
        "max_overflow": 2,
        # The total number of concurrent connections for your application will be
        # a total of pool_size and max_overflow.
        # [END cloud_sql_mysql_sqlalchemy_limit]

        # [START cloud_sql_mysql_sqlalchemy_backoff]
        # SQLAlchemy automatically uses delays between failed connection attempts,
        # but provides no arguments for configuration.
        # [END cloud_sql_mysql_sqlalchemy_backoff]

        # [START cloud_sql_mysql_sqlalchemy_timeout]
        # 'pool_timeout' is the maximum number of seconds to wait when retrieving a
        # new connection from the pool. After the specified amount of time, an
        # exception will be thrown.
        "pool_timeout": 30,  # 30 seconds
        # [END cloud_sql_mysql_sqlalchemy_timeout]

        # [START cloud_sql_mysql_sqlalchemy_lifetime]
        # 'pool_recycle' is the maximum number of seconds a connection can persist.
        # Connections that live longer than the specified amount of time will be
        # reestablished
        "pool_recycle": 1800,  # 30 minutes
        # [END cloud_sql_mysql_sqlalchemy_lifetime]

    }

    # if os.environ.get("DB_HOST"):
    return init_tcp_connection_engine(db_config)
    # else:
    #    return init_unix_connection_engine(db_config)


def init_tcp_connection_engine(db_config):
    # [START cloud_sql_mysql_sqlalchemy_create_tcp]
    # Remember - storing secrets in plaintext is potentially unsafe. Consider using
    # something like https://cloud.google.com/secret-manager/docs/overview to help keep
    # secrets secret.
    db_user = "root"  # os.environ["root"]
    db_pass = "12345"  # os.environ["12345"]
    db_name = "ryanairdb"  # os.environ["ryanairdb"]
    db_host = "34.123.203.246:3306"  # os.environ["34.123.203.246:3306"]

    # Extract host and port from db_host
    host_args = db_host.split(":")
    db_hostname, db_port = host_args[0], int(host_args[1])

    pool = sqlalchemy.create_engine(
        # Equivalent URL:
        # mysql+pymysql://<db_user>:<db_pass>@<db_host>:<db_port>/<db_name>
        sqlalchemy.engine.url.URL(
            drivername="mysql+pymysql",
            username=db_user,  # e.g. "my-database-user"
            password=db_pass,  # e.g. "my-database-password"
            host=db_hostname,  # e.g. "127.0.0.1"
            port=db_port,  # e.g. 3306
            database=db_name,  # e.g. "my-database-name"
        ),
        **db_config
    )
    # [END cloud_sql_mysql_sqlalchemy_create_tcp]

    return pool


def init_unix_connection_engine(db_config):
    # [START cloud_sql_mysql_sqlalchemy_create_socket]
    # Remember - storing secrets in plaintext is potentially unsafe. Consider using
    # something like https://cloud.google.com/secret-manager/docs/overview to help keep
    # secrets secret.
    db_user = "root"  # os.environ["root"]
    db_pass = "12345"  # os.environ["12345"]
    db_name = "ryanairdb"  # os.environ["ryanairdb"]
    db_socket_dir = "/cloudsql"  # os.environ.get("", "/cloudsql")
    # os.environ["final-year-project-24022000:us-central1:flight-info"]
    cloud_sql_connection_name = "final-year-project-24022000:us-central1:flight-info"

    pool = sqlalchemy.create_engine(
        # Equivalent URL:
        # mysql+pymysql://<db_user>:<db_pass>@/<db_name>?unix_socket=<socket_path>/<cloud_sql_instance_name>
        sqlalchemy.engine.url.URL(
            drivername="mysql+pymysql",
            username=db_user,  # e.g. "my-database-user"
            password=db_pass,  # e.g. "my-database-password"
            database=db_name,  # e.g. "my-database-name"
            query={
                "unix_socket": "{}/{}".format(
                    db_socket_dir,  # e.g. "/cloudsql"
                    cloud_sql_connection_name)  # i.e "<PROJECT-NAME>:<INSTANCE-REGION>:<INSTANCE-NAME>"
            }
        ),
        **db_config
    )
    # [END cloud_sql_mysql_sqlalchemy_create_socket]

    return pool


# This global variable is declared with a value of `None`, instead of calling
# `init_connection_engine()` immediately, to simplify testing. In general, it
# is safe to initialize your database connection pool when your script starts
# -- there is no need to wait for the first request.
db = None


# CONNECT TO DB METHODS - end


class FlightsSpider(scrapy.Spider):
    # starting log
    # logger.log_text("Starting scraper")
    name = "flightStat"  # identifies spider
    custom_settings = {'DOWNLOAD_DELAY': 1}

    start_urls = [
        'https://ryanair.flight-status.info/page-1',
    ]

    def parse(self, response):
        global db
        db = db or init_connection_engine()

        # config = {
        #    'user': 'root',
        #    'password': '12345',
        #    'host': '34.123.203.246',
        #    'socketPath': '/cloudsql/' + 'final-year-project-24022000:us-central1:flight-info',
        #    'client_flags': [ClientFlag.SSL],
        #    'ssl_ca': 'ssl/server-ca.pem',
        #    'ssl_cert': 'ssl/client-cert.pem',
        #    'ssl_key': 'ssl/client-key.pem'
        # }
        # Necessary for logging to cloud

        # now we establish our connection to DB
        # cnxn = mysql.connector.connect(**config)
        # cursor = cnxn.cursor()  # initialize connection cursor
        # config['database'] = 'ryanairdb'  # add new database to config dict

        rowNum = 2
        # pageNo = 1
        # print("starting parse, rowNum: ", rowNum, "\n")
        # starting parse log
        # google.cloud.logging("starting parse, rowNum: ")
        print(rowNum, "\n")
        while rowNum < 34:

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

            lineForm = status.split("\n")

            flightNo = lineForm[0]
            departure = lineForm[1]
            arrival = lineForm[2]
            origin = lineForm[3]
            destination = lineForm[4]
            terminal = lineForm[5]
            lastUpdate = lineForm[6]
            dateToday = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            statList = [flightNo, departure, arrival, origin,
                        destination, terminal, dateToday, lastUpdate]
            # statusDict = {
            #    "FlightNo": flightNo,
            #    "Departure": departure,
            #    "Arrival": arrival,
            #    "Origin": origin,
            #    "Destination": destination,
            #    "Terminal": terminal,
            #    "Terminal2": terminal,
            #    "Status": lastUpdate
            # }

            rowNum += 1

            queryUSE = sqlalchemy.text("USE ryanairdb")
            queryREPLACE = sqlalchemy.text(
                "REPLACE INTO flight_info (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) ")

            try:
                with db.connect() as conn:
                    conn.execute(queryUSE)
                    conn.execute(
                        queryREPLACE, statList)
            except Exception as e:
                print(e)
                # If something goes wrong, handle the error in this section. This might
                # involve retrying or adjusting parameters depending on the situation.
                # [START_EXCLUDE]
                # logger.exception(e)
                # return Response(
                #    status=500,
                #    response="Unable to successfully cast vote! Please check the "
                #    "application logs for more details.",
                # )

                # cursor.execute("USE ryanairdb", "")
                # query = "REPLACE INTO flight_info (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) "
                # cursor.execute(query, statList)
                # logging.warning("inputting into db finished")

        # scraping link to next page using xpath -
        # this sometimes changes if the website changes
        # last updated 08/02/2021 09:58
        linkNextPage = response.xpath(
            '//*[@id="wrap-page"]/main/section[2]/div/div[1]/ul/li[8]/a/@href').get()
        linkNextPage = linkNextPage.strip()
        if linkNextPage.find('page-2') < 0:
            # next page log
            # logger.log_text("next page")
            # logging.warning("next page")

            yield Request(linkNextPage, callback=self.parse)

        # cnxn.commit()  # this commits changes to the database
        # logging.warning("committed to db")

# https://ryanair.flight-status.info/page-112


if __name__ == "__main__":
    process = CrawlerProcess()
    process.crawl(FlightsSpider)
    process.start()
