#This is not my work, this is a python file I was using to try and figure out scrapy
# Ref: Scrapy docs https://docs.scrapy.org/en/latest/intro/tutorial.html


import scrapy

class QuotesSpider(scrapy.Spider):
    name = "quotes2" #identifies spider
    
    #returns iterable of Requests
    #def start_requests(self): 
    start_urls=[
        'http://quotes.toscrape.com/page/1/',
        'http://quotes.toscrape.com/page/2/'
    ]
        #for url in urls:
            #yield scrapy.Request(url = url, callback = self.parse)
          
          
    #handle response downloaded from requests 
    # response paramater is an instance of TextResponse holding page contents
    #extracts scraped data as dicts and finds new URLs to follow, creating new requests from them      
    def parse(self, response): 
        #page = response.url.split("/")[-2]
        #filename = f'quotes-{page}.html'
        #with open(filename, 'wb') as f:
         #   f.write(response.body)
        #self.log(f'Saved file{filename}')
        
        for quote in response.css('div.quote'):
            yield{
                'text':quote.css('span.text::text').get(),
                'author':quote.css('small.author::text').get(),
                'tags': quote.css('div.tags a.tag::text').getall()
                
            }
    
        
        
        
        
        
        
        
        