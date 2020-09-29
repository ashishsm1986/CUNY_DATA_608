library(shiny)
library(ggplot2)
library(dplyr)

mortality <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)

shinyServer(function(input, output) {
    
    output$graph2 <- renderPlot({
        data <- mortality %>% 
            filter(State == input$state, ICD.Chapter==input$vars)
        dataNat <- mortality %>% 
            filter(ICD.Chapter==input$vars) %>% 
            group_by(Year) %>% 
            summarise(rate=(sum(as.numeric(Deaths))/sum(as.numeric(Population))*100000),.groups = 'drop')
        ggplot(data, aes(x=Year, y=Crude.Rate, color='purple')) + geom_line() + geom_line(aes(x=dataNat$Year, y=dataNat$rate, color='green')) + scale_color_manual(name='color', values=c('purple'='purple', 'green'='green'), labels=c('National Average', 'State'))
    })

})