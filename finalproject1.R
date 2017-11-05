install.packages("ggmap")
install.packages("rvest") #install the package if you do not have it before.
install.packages("ape")
library(maptools)
library(ggmap)
library(rvest)
library(ape)
library(dplyr)

#In order to get the housing price in the www.trulia.com, seearch the key word "buffalo", then get the urls below:
#https://www.trulia.com/NY/Buffalo/=https://www.trulia.com/NY/Buffalo/1_p/
#https://www.trulia.com/NY/Buffalo/2_p/
#https://www.trulia.com/NY/Buffalo/3_p/
#...
#https://www.trulia.com/NY/Buffalo/78_p/
#Url from Buffalo/ to Buffalo/78_p, which means tha there are 62 searching result pages for the housing price in the buffalo. 

Buffalo_House=data.frame(Name=character(0),price=numeric(0),lon=numeric(0),lat=numeric(0))
Buffalo_House
for(i in 1:75){ 
  #geocode()function link the google map API to get the adress's location, but it just can get nearly 2500 location a time.
  url=sprintf("https://www.trulia.com/NY/Buffalo/%s_p/",i)
  housingPriceLink<-read_html(url,encoding="UTF-8")
  price<-housingPriceLink %>% html_nodes("#resultsColumn ul li .cardPrice") %>% html_text()#"#resultsColumn ul li .cardPrice"is the CSS selectors in the HTML page.
  Name<-housingPriceLink %>% html_nodes("#resultsColumn ul li .addressDetail") %>% html_text()
  coordinate<-geocode(Name, output = c("latlon", "latlona", "more", "all"),source = c("google", "dsk"), messaging = FALSE)
  housePrice<-data.frame(Name,price,coordinate)
  Buffalo_House=rbind(Buffalo_House,housePrice)
}
Buffalo_House
getwd() 
write.table(Buffalo_House, file = "C:/Users/MaiBenBen/Desktop/Buffalo_House.txt")#the example table can see in the UBlearns.  
#newtable<-read.table(file = "Buffalo_House.txt")
#newtable
#filter(Buffalo_House,lat<42.7)
#filter(Buffalo_House,lat>43.1)

plot(x=Buffalo_House$lon,y=Buffalo_House$lat,ylab="latidute",xlab="longtiude",ylim=c(42.7,43.1),xlim=c(-78.7,-78.95))
