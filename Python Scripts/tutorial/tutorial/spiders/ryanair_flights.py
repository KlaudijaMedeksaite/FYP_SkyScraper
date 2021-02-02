import scrapy
import re
import json
from scrapy import Request

class FlightsSpider(scrapy.Spider):
    name = "flightStat" #identifies spider
    
    start_urls=[
        'https://ryanair.flight-status.info/page-1',
    ]
    fly = open("flightFiles.json","w+")
    fly.write('{"Flights":[\n')
    fly.close()
    
    def parse(self, response):
        
        rowNum = 2
        #pageNo = 1
        
        while rowNum < 34:
            stats = open("flightStats.txt", "w+")
            stats.write("\n")

            status = ""
            print("IM HEREEEEEEEEEEE!!!!!!!!!!!!!!!!!!!\n")
            status = response.xpath('//*[@id="wrap-page"]/main/section[2]/div/div[2]/table/tbody/tr[{}]'.format(rowNum)).get()
            status = re.sub(r'<[^>]+>','',status)
            #print(status.strip())
            stats.write(status.strip())
            stats.close()
            
            stats = open("flightStats.txt", "r")
            Lines = stats.readlines()
            #print(Lines.strip())
            stats.close()
            
            
            lineForm = []
            count = 0
            for line in Lines:
                if  line.strip():
                    lineForm.append(line.strip())
                    #print(lineForm[count])
                    count +=1

             
            flightNo = lineForm[0]
            departure = lineForm[1]
            arrival = lineForm[2]
            origin = lineForm[3]
            destination = lineForm[4]
            terminal = lineForm[5]
            lastUpdate = lineForm[6]
            
            statusDict = {
                    "FlightNo" : flightNo,
                    "Departure":departure,
                    "Arrival":arrival,
                    "Origin":origin,
                    "Destination":destination,
                    "Terminal":terminal,
                    "Status":lastUpdate
            }
            
            print(statusDict)
            rowNum+=1

            with open("flightFiles.json","a") as write_file:
                json.dump(statusDict, write_file)#, indent=2
                if rowNum < 34:
                    write_file.write(',\n')
        
        
        linkNextPage = response.xpath('//*[@id="wrap-page"]/main/section[2]/div/div[2]/ul/li[8]/a/@href').get()
        linkNextPage = linkNextPage.strip()
        if linkNextPage.find('page-140') < 0:
            print("next page link: {}".format(linkNextPage))
            fly = open("flightFiles.json","a")
            fly.write(",\n")
            yield Request(linkNextPage,callback=self.parse)
        else:
            fly = open("flightFiles.json","a")
            fly.write("\n]}")
            fly.close()

            #https://ryanair.flight-status.info/page-112
