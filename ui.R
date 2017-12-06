#library(rsconnect)
library(dplyr)
library(leaflet)
library(ggmap)
library(shiny)
library(gstat)
library(ggplot2)
library(sp)
library(spdep)
library(knitr)
# Define UI for miles per gallon application
shinyUI(
  fluidPage(
  # Application title
  div(class='headTitle',
  div(class='author1',"The Spatial Autocorrelation and Spatial Distribution Prediction of the Housing Price (Buying Price) in cities of NY State"),
  div(class='author','Junjie Li')),
  navbarPage(
    title="Housing Price Analysis",
    tabPanel("Presenation",icon=icon("home")),
    tabPanel("Further Application (Getting newest data)")),
  br(),
  tags$head(       
    tags$link(
      rel='stylesheet',
      type='text/css',
      href="forR.css"
    ),
    tags$script(src="forR.js")),
  div(class='swiper',
      div(class='wrapper',
          div(id='list',style='left:-1200px',
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper1.jpg')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Conclusion',
                             'Housing price can display the urban spatial classes structure.')),
                      span(a(class='info2')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper.png')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Introduction')),
                      span(a(class='info2',
                             'Developing a web paltform to analyze spatial autocorelation and spatial distribution of housing price 
                             for main cities in NY State.')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper3.jpg')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Data')),
                      span(a(class='info2',
                             'Grabing data from potral housing price website.')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper4.jpg')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Methods')),
                      span(a(class='info2',
                             'Using Spatial Autocorelation Analysis, IDW and Oridinary Kriging Interpolation.')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper2.png')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Results')),
                      span(a(class='info2',
                             'Getting the autocorelationship of housing price for main citise in NY State
                             and predict the spatial distribution of housing price.')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper1.jpg')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Conclusion')),
                      span(a(class='info2',
                             'Housing price can display the urban spatial classes structure.')))),
              div(class='slider',
                  a(href='#',
                    img(src='images/swiper.png')),
                  div(class='imgInfo',
                      span(a(class='info1',
                             'Introduction')),
                      span(a(class='info2',
                             'Developing a web paltform to analyze spatial autocorelation and spatial distribution of housing price 
                             for main cities in NY State.'))))
              ),
          div(id='buttons',
              span(index='1',
                   class='on'),
              span(index='2'),
              span(index='3'),
              span(index='4'),
              span(index='5')
              ),
          a(href='javascript:',
            id='prev',
            class='arrow'),
          a(href='javascript:',
            id='next',
            class='arrow')
      )
    
  ),
  div(class='kind',
      div(class='button btn1'),
      div(class='kindTitle',
          'Introduction')),
  div(class='kindContainer1',
      div('Housing price are necessary for economists to elvaluate economic level and helpful for geographers to study urban spatial economy structure.
      Mean value of housing price for geographical units is not enough to dispaly the spatial corelationship of housing price between block and block, and we also need a more smooth map, like interpolation 
      map to display housing price distribution. With more smooth map, it will be more easy and direct for us to watch urban spatial economy structure.
      But 2 problems to utilize and analyze housing price.
      1.Government: they just provide us for a mean or median value of geographical units, like the mean value of housing price of a block.
      2.Portal housing price websites(enterprises): except mean value data, they have enough original housing price points data, but nealry all the portal housing price websites in United States do not develop a 
      function to display interpolation map for housing price.
      So I decide to develop a website for interpolation map of housing price with R and try to analyze the housing price distribution in Buffalo as an exampe.'),
      div(class='UL','URLs for portal housing price websites:',
          a(href="www.trulim.com",'www.trulim.com'),
          a(href="http://Realtor.com",'www.Realtor.com'),
          a(href="http://zillow.com",'www.zillow.com'),
          a(href="http://www.rentometer.com",'www.rentometer.com'))),
  div(class='kind',
      div(class='button btn2'),
      div(class='kindTitle',
          'Data')),
  div(class='kindContainer2',
      div('Package and Tools: Rvest, Shiny&ShinyApp, gstat, spdep, leaflet, HTML+CSS+Javascript'),
      div('Data source:',
          a(href='www.trulia.com',
            'www.trulia.com')),
      'Using the package(rvest) to grab the housing price data from the www.trulia.com, because it will take a long 
    time if you get the records from the website by inputting to the table by yourself. So the package(rvest)
      is a good choice to get the data in the HTML file by identifying the CSS selectors where the data stores in.
      From the www.trulia.com, I want to get the attributes about the address, price, and the coordinates. 
      The address and the price can get from the HTML page directly by the package. But the coordinates in the website
      are also from the Google map API, in order to get the coordinates of houses,
      I use the function geocode()* from the package(ggmap). Inputting the address name into the function geocode(), 
      and the function will send the requires to the Google map API, and then download the coordinates(lon,lat) 
      of the address automatically. Eventually, joining the columns of address, price, lon and lat together to build 
      the final data table(Buffalo_House_Price).'),
  div(class='kind',
      div(class='button btn3'),
      div(class='kindTitle',
          'Methods')),
  div(class='kindContainer3',
      div('Spatial Autocorelation:'),
      div('Spatial autocorrelation in GIS helps understand the degree to which one object is similar to other nearby objects. Morans I (Index) measures spatial autocorrelation.'),
      img(src='images/for1.svg'),
      div('IDW:'),
      div('Inverse distance weighting (IDW) is a type of deterministic method for multivariate interpolation with a known scattered set of points. The assigned values to 
      unknown points are calculated with a weighted average of the values available at the known points.'),
      img(src='images/for2.png',style='width:300px;'),
      div('Oridinary Kriging:'),
      div('Ordinary Kriging is the type of kriging method in which the 
      weights of the values sum to unity. It uses an average of a subset of neighboring points to produce a particular interpolation point.'),
      img(src='images/for3.jpg'),
      br(),
      img(src='images/for4.jpg')),
 div(class='kind',
     div(class='button1 btn4'),
     div(class='kindTitle',
         'Results')),
 div(class='kindContainer4',
  sidebarPanel(
    selectInput("citynames", "Choose a city:", 
                choices = c("Buffalo","Rochester","Syracuse","Albany","Binghamton","New York city")),
    br(),
    sliderInput("price", "House Price:", 
                min=0, max=1000000, value = c(10000,100000)),
    h5("Number of Housing Price Points:"),
    textOutput('num'),
    br(),
    downloadButton('downloadcity', 'Download')
  ),
  
  mainPanel(
    leafletOutput('map',height = "490"),
    br(),
    tabsetPanel(type = "tabs",
                tabPanel("Plot",
                         h3("Plot of Data"),
                         plotOutput("plot"),
                         plotOutput("plot1"),
                         verbatimTextOutput("summary1")),
                tabPanel("Auticorrelation", 
                         h3("Spatial Autocorrelation for Housing Price"),
                         plotOutput('SA'),
                         verbatimTextOutput("summary")),
                tabPanel("IDW", 
                         h3("IDW Estimnation for Housing Price"),
                         plotOutput('pic')),
                tabPanel("Kriging", 
                         h3("Oridinary Kriging Estimnation for Housing Price (Semivariance only)"),
                         plotOutput('var')),
                tabPanel("Code", 
                         div(a(class='linkcode',href="https://litu5555.github.io/Finalproject/","Code about Grabing Data")),
                             div(a(class='linkcode',href="https://github.com/litu5555/finalproject","Whole Project Code on GitHub")))
    )
   
  )),
  div(class='kind',style='clear:both;',
      div(class='button btn5'),
      div(class='kindTitle',
          'Conclusion')),
  div(class='kindContainer5',
       div("1.Average housing price in 5 main cities (Albany, Binghamton, Buffalo, Rochester, Syracuse) and their rural areas in NY state can be ordered by sequence from high to low(Albany > Buffalo > Rochester > Binghamton > Syracuse)."),
       div("2.5 main cities have positive coefficients of spatial distribution, but due to sample, the value of global Moran's I is not high enough to prove wether housing price has autocorrelation, especially Buffalo's value approch 0."),
       div("3.Except Buffalo, other 4 cities housing price value can be interpolated by IDW (Inverse Distance Weighting), and the outputing images can show different cities have different peak and valley of housing price.")),
 div(class='kind',
     div(class='button btn6'),
     div(class='kindTitle',
         'Reference')),
 div(class='kindContainer6',
     div("[1] Wu, Chao, et al. Spatial and social media data analytics of housing prices in 
         Shenzhen, China. PloS one 11.10 (2016): e0164553."),
     div("[2] Koramaz, Turgay Kerem, and Vedia Dokmeci. Spatial determinants of housing 
         price values in Istanbul. European Planning Studies 20.7 (2012): 1221-1237."),
     div("[3] Jeanty, P. Wilner, Mark Partridge, and Elena Irwin. Estimation of a spatial 
         simultaneous equation model of population migration and housing price dynamics.
         Regional Science and Urban Economics 40.5 (2010): 343-352."),
     div("[4] Basu, Sabyasachi, and Thomas G. Thibodeau. Analysis of spatial autocorrelation 
         in house prices. The Journal of Real Estate Finance and Economics 17.1 (1998): 61-85.")
     ),
 div(class='footers',
     div(class='wrapper',
         a('Geography Department of State University of New York at Buffalo'),
         a('Junjie Li'),
         a('Phone:(716)9075610'),
         a(href='mailto:jli327@buffalo.edu','Email:jli327@buffalo.edu')))
)
)
#rsconnect::deployApp("D:/forR/shiny")