#Load all the necessary libraries. 
library(shiny)
library(tidyverse)
library(lubridate)
library(leaflet)
library(rvest)
library(plotly)
library(scales)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(flexdashboard)
# Read the data using web scraping.
# Below  set of commands only run once. Commenting this out to avoid running this everytime the visualization is created.
#Url to read data from on github
#url <- 'https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports_us'
#url %>%
#  read_html() %>%
#  html_nodes(xpath = '//*[@role="rowheader"]') %>%
#  html_nodes('span a') %>%
#  html_attr('href') %>% #Get the URL of each file
#  sub('blob/', '', .) %>% #remove "blob" text from the url
#  paste0('https://raw.githubusercontent.com', .) %>% #append https://raw.githubusercontent.com to each url
#   Read all the files from the url
#   Since some files have different format we use tryCatch to ignore those files
#  purrr::map_df(function(x) tryCatch(read.csv(x), error = function(e) {})) -> combined_data

#To avoid scraping the data every time we write the data to the disk and read it from there

#write.csv(combined_data, 'combined_data.csv', row.names = FALSE)
#Remove state name as recovered this was not valid rows.
#combined_data <- combined_data %>% filter(Province_State != 'Recovered')

# After creating the file i uploaded it to gihub and reading it from there over the web.

combined_data <- read_csv('https://raw.githubusercontent.com/ashishsm1986/CUNY_DATA_608/master/Final%20Project/combined_data.csv')
#combined_data <- read_csv('combined_data.csv')
state_name <- unique(combined_data$Province_State)

#Convert character to Posixct format and add date. 

combined_data %>%
  mutate(Last_Update = ymd_hms(Last_Update), 
         Date = as.Date(Last_Update)) -> combined_data


map_data <- combined_data %>%
  arrange(Province_State, desc(Last_Update)) %>%
  distinct(Province_State, .keep_all = TRUE) %>%
  select(Province_State, Lat, Long = Long_, Confirmed, Deaths, Recovered, Active) %>%
  mutate(dlevels = cut(Deaths, 5, labels = c('Low', 'Medium', 'High', 'Very high','Worst')))
  
beatCol <- colorFactor(colorRamp(c('green','purple', 'red')), map_data$dlevels)

labels <- sprintf('State Name : %s<br>Active Cases :%d<br>Confirmed Cases : %d<br>Deaths : %d', 
                  map_data$Province_State, map_data$Active, map_data$Confirmed, map_data$Deaths)
  

ui <- fluidPage(
  titlePanel("Covid Impact Dashboard for US"),
  
  useShinydashboard(),
  fluidRow(
    shinydashboard::valueBox(comma(sum(map_data$Deaths)), "Deaths in US", icon = icon("head-side-mask"), color = 'red', width = 6),
    #valueBox(comma(sum(map_data$Deaths)), "Deaths in US", icon = icon("head-side-mask"), color = 'red'),
    shinydashboard::valueBox(comma(sum(map_data$Confirmed)), "Total confirmed cases in US", icon = icon("head-side-mask"), color = 'blue', width = 6)
    #valueBox(comma(sum(map_data$Confirmed)), "Total confirmed cases in US", icon = icon("head-side-mask"), color = 'blue')
  ),
  br(), br(), 
  sidebarLayout(
    sidebarPanel(
      h4('CountryWide Covid Impact')
    ),
    mainPanel(
      leafletOutput("plot5")
    )
  ),
  sidebarLayout(
    sidebarPanel(
      h4('Deaths vs Confirmed cases'),
      selectInput("state1", "State Name:", 
                  choices=state_name),
    ),
    mainPanel(
      plotlyOutput("plot1")
    )
  ), 
  sidebarLayout(
    sidebarPanel(
      h4('People Hospitalized vs Confirmed cases'),
      selectInput("state2", "State Name:", 
                  choices=state_name),
    ),
    mainPanel(
      plotlyOutput("plot2")
    )
  ), 
  sidebarLayout(
    sidebarPanel(
      h4('Active cases vs confirmed cases'),
      selectInput("state3", "State Name:", 
                  choices=state_name),
    ),
    mainPanel(
      plotlyOutput("plot3")
    )
  ), 
  sidebarLayout(
    sidebarPanel(
      h4('Number of new cases'),
      selectInput("state4", "State Name:", 
                  choices=state_name),
    ),
    mainPanel(
      plotlyOutput("plot4")
    )
  ),
  fluidRow(
    h4("Project Write up:-", a("Click Here", href = "https://github.com/ashishsm1986/CUNY_DATA_608/blob/master/Final%20Project/Writeup.md",target="_blank"))
  )
)

server <- function(input, output) {

  
  query_modal <- modalDialog(
    title = HTML("<b>General Info !</b>"),
    HTML("<ul><li>This Visualization does analysis COVID affect on US states from April 2020 to December 02 2020.</li> 
      <li>The visualization is interactive.</li>
      <li>You can click on any state in the map to get its COVID related numbers.</li>
      <li>For any of the bar charts, you can zoom in area by draggng your curser in the chosen area.<br>
      <li>The tooltips will help identify the exact numbers on the charts.</li>
      <li>For any of the charts select any state you are interested in.</li>
      <li>New York seem to be most affected with the most number of deaths and COVID Cases followed by Texas and California.</li>
      <li>Vermont seem to be best coping with the least number of deaths of 77.</li>
      <br>
      <b>Data Source:- </b>https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports_us
      <br>
      <b>License:- </b>This data set is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) by the Johns Hopkins University on behalf of its Center for Systems Science in Engineering. Copyright Johns Hopkins University 2020.</ul>")
  )
  
  
  showModal(query_modal)
  
  observeEvent(input$run, {
    removeModal()
  })
  
  output$plot1 <- renderPlotly({
    ggplotly(combined_data %>%
               filter(Province_State == input$state1) %>%
               mutate(month = month(Last_Update), 
                      color =  case_when(month %in% 4:6 ~ '2nd Quarter', 
                                         month %in% 7:9 ~ '3rd Quarter', 
                                         TRUE ~ '4th Quarter'),
                     ratio = Deaths/Confirmed) %>%
               ggplot() + aes(Last_Update, ratio, color = color) + geom_col() + 
               scale_x_datetime(date_labels = '%b', date_breaks  ="1 month") + 
               xlab('Date') + ylab('Deaths/Confirmed Cases') + 
               guides(color=FALSE)) %>%
               layout(showlegend = FALSE)
  })
  
  
  output$plot2 <- renderPlotly({
    ggplotly(combined_data %>%
      filter(Province_State == input$state2) %>%
      mutate(month = month(Last_Update), 
             color = case_when(month %in% 4:6 ~ '2nd Quarter', 
                                month %in% 7:9 ~ '3rd Quarter', 
                                TRUE ~ '4th Quarter'),
            ratio = People_Hospitalized/Confirmed) %>%
      ggplot() + aes(Last_Update, ratio, color = color) + geom_col() + 
      scale_x_datetime(date_labels = '%b', date_breaks  ="1 month") + 
      xlab('Date') + ylab('People_Hospitalized/Confirmed Cases') + guides(color=FALSE)) %>%
      layout(showlegend = FALSE)
  })
  
  
  output$plot3 <- renderPlotly({
    ggplotly(combined_data %>%
      filter(Province_State == input$state3) %>%
      mutate(month = month(Last_Update), 
             color =  case_when(month %in% 4:6 ~ '2nd Quarter', 
                                month %in% 7:9 ~ '3rd Quarter', 
                                TRUE ~ '4th Quarter'),
              ratio = Active/Confirmed) %>%
      ggplot() + aes(Last_Update, ratio, color = color) + geom_line() + 
      scale_x_datetime(date_labels = '%b', date_breaks  ="1 month") + 
      xlab('Date') + ylab('Active Cases/Confirmed Cases') + guides(color=FALSE)) %>%
      layout(showlegend = FALSE)
  })
  
  output$plot4 <- renderPlotly({
    ggplotly(combined_data %>%
      filter(Province_State == input$state4) %>%
      mutate(month = month(Last_Update), 
             color = case_when(month %in% 4:6 ~ '2nd Quarter', 
                               month %in% 7:9 ~ '3rd Quarter', 
                               TRUE ~ '4th Quarter'),
            new_case = Confirmed - lag(Confirmed)) %>%
      ggplot() + aes(Last_Update, new_case, color = color) + geom_col() + 
      scale_x_datetime(date_labels = '%b', date_breaks  ="1 month") + 
      xlab('Date') + ylab('New cases') + guides(color=FALSE)) %>%
      layout(showlegend = FALSE)
  })
  
  output$plot5 <- renderLeaflet({
    
    leaflet(map_data) %>%
      setView(-96, 37, 4) %>%
      addTiles %>%
      addCircleMarkers(~Long, ~Lat, popup = labels, 
                       label = ~Province_State, color = ~beatCol(dlevels), 
                       radius = ~log(Deaths, 2)) %>%
      addLegend('bottomright', pal = beatCol, values = map_data$dlevels,
                title = 'Number of Deaths',
                opacity = 1)
  })
  
}

shinyApp(ui = ui, server = server)
