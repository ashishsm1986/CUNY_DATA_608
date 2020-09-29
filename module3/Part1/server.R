library(shiny)
library(ggplot2)
library(dplyr)


mortality_df <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv", header = TRUE, stringsAsFactors = FALSE)

# Filter for 2010 only 

mortality_2010 <- subset(mortality_df, Year=='2010')



reason <- as.data.frame(unique(mortality_2010$ICD.Chapter))

function(input, output) {
    rates <- reactive({rates <- subset(mortality_2010, ICD.Chapter==input$reason)})
    output$graph1 <- renderPlot({
        ggplot(rates(), aes(x=Crude.Rate, y=reorder(State, -Crude.Rate)))+ scale_x_continuous(limits=c(0, max(rates()$Crude.Rate))+1, expand = c(0,0))+
            geom_segment(aes(yend=State), xend=0, color="blue")+ geom_point(size=2.5, color = "red") + theme_bw()+ 
            theme(panel.grid.major.y = element_blank(), axis.title=element_text(size=20))+ xlab("2010 Mortality Rate for US States") + ylab("State Name") +
            ggtitle(input$reason)
    }) 
}