library(leaflet)
library(ggmap)
library(shiny)
library(dplyr)
library(gstat)
library(sp)
library(ggplot2)
library(spdep)
library(knitr)
Rochester<-read.csv("Rochester.csv")
Rochester<-na.omit(Rochester)
Rochester<-filter(Rochester,lon>-78,lon< -77.2,lat>42)

Buffalo<-read.csv("Buffalo_House.csv")
Buffalo<-na.omit(Buffalo)
Buffalo<-filter(Buffalo,42.43635<lat,lat<43.33651,-79.49042<lon,lon< -78.6)

Syracuse<-read.csv("Syracuse.csv")
Syracuse<-na.omit(Syracuse)
Syracuse<-filter(Syracuse,lat>42.92,lon< -75,lon>-77)

Albany<-read.csv("Albany.csv")
Albany<-na.omit(Albany)
Albany<-filter(Albany,lon>-75,lon< -73.72,lat>42.61,lat<42.77)

Binghamton<-read.csv("Binghamton.csv")
Binghamton<-na.omit(Binghamton)
Binghamton=filter(Binghamton,lat>42,lon< -75.8)

shinyServer(function(input, output) {
  datasetInput<-reactive({
    switch(input$citynames,
      "Buffalo"=Buffalo,
      "Rochester"=Rochester,
      "Syracuse"=Syracuse,
      "Albany"=Albany,
      "Binghamton"=Binghamton,
      "New York city"=Buffalo
    )
  })
  textInput<-reactive({
    switch(input$citynames,
           "Buffalo"="Buffalo",
           "Rochester"="Rochester",
           "Syracuse"="Syracuse",
           "Albany"="Albany",
           "Binghamton"="Binghamton",
           "New York city"="New York City"
           )
  })
 
  output$map<-renderLeaflet({
    cityName<-datasetInput()
    forslider<-filter(cityName,min(input$price)<=price, price<=max(input$price))
    center<-geocode(paste(textInput(),'NY',seq=''))
    leaflet() %>% addTiles() %>% setView(lng=center$lon,lat=center$lat,zoom=12)%>% addMarkers(lng=forslider$lon,lat=forslider$lat,popup=forslider$price)})
  #HP<-reactive({House}
  #HP <- reactiveValues(House)
  output$num<-renderText(
    length(which(min(input$price)<=datasetInput()$price & datasetInput()$price<=max(input$price)))
  )
  output$plot<-renderPlot({
    searchdata<-datasetInput()
    index1<-duplicated(searchdata[,4])
    index2<-duplicated(searchdata[,5])
    index=index1 & index2
    Housing=searchdata[!index,]
    hist(log(Housing$price),main = paste(textInput(),"Housing Price"),col = "#75AADB")
  })
  output$plot1<-renderPlot({
    searchdata<-datasetInput()
    index1<-duplicated(searchdata[,4])
    index2<-duplicated(searchdata[,5])
    index=index1 & index2
    Housing=searchdata[!index,]
    boxplot(Housing$price,col = "#75AADB",ylab="Price")
  })
  output$summary1<-renderPrint({
    searchdata<-datasetInput()
    index1<-duplicated(searchdata[,4])
    index2<-duplicated(searchdata[,5])
    index=index1 & index2
    Housing=searchdata[!index,]
    summary(Housing$price)
  })
  output$SA<-renderPlot({
    searchdata<-datasetInput()
    index1<-duplicated(searchdata[,4])
    index2<-duplicated(searchdata[,5])
    index=index1 & index2
    Housing=searchdata[!index,]
    coordinates(Housing)<-c("lon","lat")
    nbk1 <- knn2nb(knearneigh(Housing, k =4, longlat =TRUE))
    snbk1 <- make.sym.nb(nbk1)
    nsp.Moron.I <- sp.correlogram(snbk1, Housing$price, order=6, method="I", zero.policy =TRUE)
    plot(nsp.Moron.I)
  })
  output$summary<-renderPrint({
    searchdata<-datasetInput()
    index1<-duplicated(searchdata[,4])
    index2<-duplicated(searchdata[,5])
    index=index1 & index2
    Housing=searchdata[!index,]
    coordinates(Housing)<-c("lon","lat")
    nbk1 <- knn2nb(knearneigh(Housing, k =4, longlat =TRUE))
    snbk1 <- make.sym.nb(nbk1)
    sm<-moran.test(Housing$price, nb2listw(snbk1))
    sm
  })
  output$pic<-renderPlot({
    if (textInput()=="Buffalo"){
      xgrid <- seq(min(datasetInput()$lon), max(datasetInput()$lon),by=0.005)
      ygrid <- seq(min(datasetInput()$lat), max(datasetInput()$lat),by=0.005)
      basexy <- expand.grid(xgrid, ygrid)
      colnames(basexy) <- c("x", "y")
      coordinates(basexy) <- ~x+y
      gridded(basexy) <- TRUE
      Bu<-datasetInput()
      coordinates(Bu)<-c("lon","lat")
      idwout <- idw(price~1, Bu,basexy)
      spplot(idwout, c("var1.pred"))
    }else{
    xgrid <- seq(min(datasetInput()$lon), max(datasetInput()$lon),by=0.001)
    ygrid <- seq(min(datasetInput()$lat), max(datasetInput()$lat),by=0.001)
    basexy <- expand.grid(xgrid, ygrid)
    colnames(basexy) <- c("x", "y")
    coordinates(basexy) <- ~x+y
    gridded(basexy) <- TRUE
    Bu<-datasetInput()
    coordinates(Bu)<-c("lon","lat")
    idwout <- idw(price~1, Bu,basexy)
    spplot(idwout, c("var1.pred"))
  }})
  output$var<-renderPlot({
    v<- variogram(object = price~1,data = datasetInput(),locations =~lon+lat)
    v.fit = fit.variogram(v,vgm(model = 'Sph'))
    plot(v, model=v.fit)
  })
  observeEvent(
  input$citynames,
  output$downloadcity <- downloadHandler(
    filename =function() { paste(input$citynames, '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
   )
  )
})

