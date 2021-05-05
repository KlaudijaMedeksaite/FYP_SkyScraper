import scrapy
import re
import json
from datetime import date
from datetime import datetime
from scrapy import Request
from scrapy.crawler import CrawlerProcess
import mysql.connector
from mysql.connector.constants import ClientFlag


config = {
    'user': 'root',
    'password': '12345',
    'host': '34.123.203.246',
}

# now we establish our connection
cnxn = mysql.connector.connect(**config)
cursor = cnxn.cursor()  # initialize connection cursor
config['database'] = 'flightDB'  # add new database to config dict


class FlightsSpider(scrapy.Spider):

    name = "RyanairflightStat"  # identifies spider
    custom_settings = {'DOWNLOAD_DELAY': 1}

    start_urls = [
        'https://ryanair.flight-status.info/page-1',
    ]

    def parse(self, response):

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
                # print("f_no: ", flightNo, "dep: ",  departure, "arr: ", arrival, "origin:", origin, "destination: ", destination, "terminals: ", terminal, "status: ",  lastUpdate)

            # for airport creation
            # origin
            originAirportCity, originAirportCountry = origin.split(
                ',', 1)
            extra, originAirportCity = originAirportCity.split(
                ')', 1)
            originAirportCity = str(originAirportCity).strip()
            originAirportCountry = str(originAirportCountry).strip()

            # destination

            destAirportCity, destAirportCountry = destination.split(
                ',', 1)
            extra, destAirportCity = destAirportCity.split(
                ')', 1)
            destAirportCity = str(destAirportCity).strip()
            destAirportCountry = str(destAirportCountry).strip()
            # print("city: ", destAirportCity," country: ", destAirportCountry)

            # fix origin and destination to conform as foreign key
            origin, extra = str(origin).split(')', 1)
            origin = str(origin).replace('(', '')

            destination, extra = str(destination).split(')', 1)
            destination = str(destination).replace('(', '')

            # fix terminal vars to be split into two
            terminalDep, terminalArr = terminal.split(' - ')
            terminalArr = terminalArr.replace('Arrival', '')
            terminalDep = terminalDep.replace('Departure', '')

            # create flightDay var
            flightDay = date.today().weekday()

            if(flightDay == 0):
                flightDay = "Monday"
            elif(flightDay == 1):
                flightDay = "Tuesday"
            elif(flightDay == 2):
                flightDay = "Wednesday"
            elif(flightDay == 3):
                flightDay = "Thursday"
            elif(flightDay == 4):
                flightDay = "Friday"
            elif(flightDay == 5):
                flightDay = "Saturday"
            elif(flightDay == 6):
                flightDay = "Sunday"

            # put all vars into list, ready to go into db
            statList = [flightNo, departure, arrival, origin,
                        destination, terminalDep, terminalArr, lastUpdate, flightDay]
            airportListOR = [origin, originAirportCountry, originAirportCity]
            airportListDES = [destination, destAirportCountry, destAirportCity]
            # print(statList)
            rowNum += 1

            # for putting into db

            try:
                # print("Adding to ryanair_flights")
                cursor.execute("USE flightDB", "")
                query = "REPLACE INTO ryanair_flights (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status, flight_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) "
                cursor.execute(query, statList)
                # print(statList)

                # print("executed")
            except:
                # print(Exception)
                # Sometimes trying to add flight to db with a foreign key relying
                # on airports db but its not in there, need to add it in this case
                try:
                    try:
                        # print("Trying to update airport table with new origin airport")
                        cursor.execute("USE flightDB", "")
                        query = "REPLACE INTO airports (code, country, city) VALUES (%s, %s, %s)"
                        cursor.execute(query, airportListOR)
                        # print("executed ok")

                        cnxn.commit()
                        # print("committed, trying to to add to ryanair_flights table")
                        cursor.execute("USE flightDB", "")
                        # print(statList)
                        query = "REPLACE INTO ryanair_flights (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status, flight_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) "
                        cursor.exe
                        cute(query, statList)
                        # print("executed ok")
                    except:
                        # print("Trying to update airport table with new destination airport")
                        cursor.execute("USE flightDB", "")
                        # print(statList)

                        query = "REPLACE INTO airports (code, country, city) VALUES (%s, %s, %s)"
                        cursor.execute(query, airportListDES)
                        # print("executed ok")

                        cnxn.commit()
                        # print("committed, trying to to add to ryanair_flights table")
                        cursor.execute("USE flightDB", "")
                        query = "REPLACE INTO ryanair_flights (flight_no, depart_time, arrive_time, origin, destination, depart_terminal, arrive_terminal, flight_status, flight_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) "
                        cursor.execute(query, statList)
                except:
                    # print("Trying to to update instead of replace to ryanair_flights table")
                    cursor.execute("USE flightDB", "")
                    # print(statList)
                    query = "UPDATE ryanair_flights set depart_time = '"+statList[1]+"', arrive_time ='" + statList[2]+"', depart_terminal = '"+statList[5] + \
                        "', arrive_terminal = '"+statList[6]+"', flight_status = '"+statList[7] + \
                        "', flight_date = '" + \
                        statList[8]+"' where flight_no like '"+statList[0]+"';"

                    cursor.execute(query)
                    # print("executed ok")

            statistics(statList)
            flight_days(statList[0], statList[8])
        # scraping link to next page using xpath -
        # this sometimes changes if the website changes
        # last updated 08/02/2021 09:58
        linkNextPage = response.xpath(
            '//*[@id="wrap-page"]/main/section[2]/div/div[1]/ul/li[8]/a/@href').get()
        linkNextPage = linkNextPage.strip()
        if linkNextPage.find('page-12') < 0:
            yield Request(linkNextPage, callback=self.parse)

        cnxn.commit()  # this commits changes to the database
        print("committed to DB")


# https://ryanair.flight-status.info/page-112


def statistics(statList):

    # connect to db and get origin, destination

    cursor.execute("USE flightDB")

    # statistics = [flight_no, counter, cur_dur, track_dur, cur_stat, track_stat]
    flight_no = statList[0]
    # connect to airports db, figure out what country origin is

    # tracking on time percent
    # connect to db, if not null get track_percent or whtvr
    query = "SELECT track_stat, counter, track_dur, counter_stat from statistics where flight_no like '" + flight_no+"'"
    t_stat = str(0)
    cursor.execute(query)
    results = cursor.fetchall()
    results = str(results)
    results = results.replace('[', '').replace(
        ']', '').replace('(', '').replace(')', '')
    results = results.replace('\'', '')

    if results.strip() == '':
        t_stat = str(100)
        count = str(1)
        track_dur = str(0)
        counterStat = int(1)
    else:
        t_stat, count, track_dur, counterStat = results.split(',')
        t_stat = t_stat.strip()
        count = count.strip()
        track_dur = track_dur.strip()
        counterStat = counterStat.strip()
        counterStat = int(counterStat) + 1

    # print(t_stat + ", " + count + ", " + track_dur + ", " + str(counterStat))

    # lastupdate = 7, tStat=8
    t_stat = int(float(t_stat)/10)
    count = int(count)
    if "On time" in statList[7]:
        count += 1
        t_stat += 10
    elif "Delayed" in statList[7]:
        count += 1

        if "Arrived" in statList[7]:
            extra, delayAmt = statList[7].split('by', 1)
            delayAmt = delayAmt.strip().replace('m', '')
            if 'h' in delayAmt:
                extra, delayAmt = delayAmt.split('h ', 1)
                delayAmt = int(delayAmt) + 60

            delayAmt = int(delayAmt)

            if delayAmt < 5:
                t_stat += 9
            elif delayAmt < 15:
                t_stat += 7
            elif delayAmt < 30:
                t_stat += 4
            elif delayAmt < 45:
                t_stat += 2
            else:
                t_stat += 1

        elif "Departed" in statList[7]:
            t_stat += 6
    elif "cancelled" in statList[7]:
        count += 1
        t_stat += 0

    #print("l 296: count: " + str(count))
    #print("l 297: t_stat: " + str(t_stat))

    if(count > 0):
        t_stat = t_stat/int(count) * 10
    t_stat = str(t_stat)
    count = str(count)
    #print("l 303: t_stat: " + str(t_stat))

    # cur dur for now will just be literal time difference, ignoring tz
    a = datetime.now()
    b = datetime.now()

    h, m = statList[1].split(':')
    a = a.replace(hour=int(h), minute=int(m))
    h, m = statList[2].split(':')
    b = b.replace(hour=int(h), minute=int(m))

    if b < a:
        # print("b before: " + str(b))
        b = b.replace(day=b.day+1)
        # print("b after: " + str(b))

    hours = b-a

    mins = int(hours.total_seconds())/60
    if mins > 60:
        hours = int(mins/60)
        try:
            mins = int(mins % (hours * 60))
        except:
            mins = 0
    else:
        hours = 0

    hours = str(hours)
    mins = str(mins)

    if '.' in mins:
        # print("339: mins: " + mins)
        mins, extra = mins.split('.')
        # print("341: mins: " + mins)

    if int(mins) == 60:
        hours = str(1)
        mins = str(0)
    cur_dur = hours + '.' + mins

    # print("cur_dur: " + cur_dur)
    if counterStat == 1:
        track_dur = cur_dur
    else:

        th, tm = track_dur.split('.')
        tm = int(tm)

        tm += int(th) * 60

        ch, cm = cur_dur.split('.')
        cm = int(cm)

        cm += int(ch) * 60

        tm = int((tm + cm)/2)
        # print("364: track_dur: " + str(tm))

        th = 0
        if tm == 60:
            # print("368: tm == 60")
            th += 1
            tm = int(0)
        else:
            # print("372: tm != 60")

            mod = int(tm % 60)  # mod = 205 % 60 = 25
            th += int((tm-mod)/60)  # th += (205-25 = 180)/ 60 = 3 # th = 3
            tm = int(mod)  # tm is 25
            # print("377: th: " + str(th))
        tm = int(tm)
        # print("379: tm: " + str(tm))

        if '.' in str(tm):
            # print("382: tm: " + tm)
            tm, extra = str(tm).split('.')
            # print("384: tm: " + tm)

        track_dur = str(th) + '.' + str(int(tm))
        # print("387: track_dur: " + track_dur)

    # commit to db
    statisticsList = [flight_no, count,
                      cur_dur, track_dur, statList[7], t_stat, counterStat]
    # print(statisticsList)

    query = "REPLACE INTO statistics (flight_no, counter, cur_dur, track_dur, cur_stat, track_stat, counter_stat) VALUES (%s, %s, %s, %s, %s, %s,%s)"
    cursor.execute(query, statisticsList)


def flight_days(flightNo, day):

    if 'Monday' in day:
        column = 'mon_fly'
    elif 'Tuesday' in day:
        column = 'tue_fly'
    elif 'Wednesday' in day:
        column = 'wed_fly'
    elif 'Thursday' in day:
        column = 'thu_fly'
    elif 'Friday' in day:
        column = 'fri_fly'
    elif 'Saturday' in day:
        column = 'sat_fly'
    elif 'Sunday' in day:
        column = 'sun_fly'

    try:
        #print("Trying to REPLACE into fly_days with: " +flightNo + " on column " + column)
        cursor.execute("USE flightDB")
        query = "REPLACE INTO fly_days (flight_no, " + \
            column + ") VALUES ('"+flightNo+"', 'true');"
        # print(query)
        cursor.execute(query)
        # print("ok")

    except:
        print("Cant replace in fly_days. Updating..")
        print("Trying to UPDATE fly_days with: " +
              flightNo + " on column " + column)

        cursor.execute("USE flightDB")
        query = "UPDATE fly_days set " + column + \
            " = 'true' where flight_no like '"+flightNo+"';"
        # print(query)
        cursor.execute(query)
        # print("ok")


if __name__ == "__main__":
    process = CrawlerProcess()
    process.crawl(FlightsSpider)
    process.start()

    # List = [
    #    'FR9961',
    #    '20:30',
    #    '21:50',
    #    'PMO',
    #    'PSA',
    #    'None',
    #    'None',
    #    'In_gate',
    #    '0',
    #    'Tuesday'
    # ]

    # statistics(List)
