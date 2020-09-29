# Question 2
# Often you are asked whether particular States are improving their mortality rates (per cause) faster than, or slower than, the national average. 
# Create a visualization that lets your clients see this for themselves for one cause of death at the time. 
# Keep in mind that the national average should be weighted by the national population.


mortality <- read.csv('https://raw.githubusercontent.com/charleyferrari/CUNY_DATA_608/master/module3/data/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)
unique(mortality$ICD.Chapter)

shinyUI(fluidPage(
    title = "Mortality Rate by State",
    fluidRow(
        column(4,
               selectInput('vars', 'Death By', choices=unique(mortality$ICD.Chapter))
        ),
        column(4,
               selectInput('state', 'State Name', choices=unique(mortality$State))
        )
    ),
    fluidRow(
        plotOutput('graph2')
    )

))