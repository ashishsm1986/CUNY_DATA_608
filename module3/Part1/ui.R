#Data608 HW3 Part1

#Question1
#As a researcher, you frequently compare mortality rates from particular causes across
#different States. You need a visualization that will let you see (for 2010 only) the crude
#mortality rate, across all States, from one cause (for example, Neoplasms, which are
#effectively cancers). Create a visualization that allows you to rank States by crude mortality
#for each cause of death.

library(shiny)
library(ggplot2)
library(dplyr)


mortality_df <- read.csv("https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv", header = TRUE, stringsAsFactors = FALSE)

# Filter for 2010 only 

mortality_2010 <- subset(mortality_df, Year==2010)

# Reasons of death 

reason <- unique(mortality_2010$ICD.Chapter)
fluidPage(
    titlePanel("2010 Mortality Rates"),
    fluidRow(selectInput("reason", "Death Due to:", choices=sort(reason))), 
    plotOutput("graph1", height = 1000)
)