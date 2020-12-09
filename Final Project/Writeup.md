For the final project Have creates visualizations on US active cases and daily death reports on COVID-19.

## Link to Dashboard:- https://ashishsm1986.shinyapps.io/data-608-US-COVID-Impact/

## The Data source is located here:- 
https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_daily_reports_us

The dataset is produced by  Center for Systems Science and Engineering (CSSE) at Johns Hopkins University.
The csse_covid_19_daily_reports_us folder contains an aggregation of each USA State level data.

## Some data parameters are:-

Geography, Confirmed Deaths, Confirmed Recoveries and Active cases.

- First step would be clean up the data for nulls or missing information.
    - For this i used web scraping that i learnt in my earlier classes at CUNY.
    - I created a file combine_data.csv file from all the data after cleansing. Because i wanted to avoid having to go through all the files one by one everyime i redeployed the dashboard.

## Visualizations i made are:-
- A US Map with the state numbers depicting the impact of COVID. This provides a hollistic view of how all the states across US are affected by COVID.

- A barplot of Deaths vs Confirmed cases with confirmed deaths per state. The user can choose which state to look into.

- A barplot of People Hospitalized vs Confirmed cases per state. The user can choose which state to look into. This helps us understand how each state's healthcare facilities could be coping with increasing infections. Unfortunately there is not data reported beyond August in this regard as the state governments are not reporting these numbers anymore. https://github.com/CSSEGISandData/COVID-19/issues/3083

- A timeseries plot of Active cases vs confirmed cases  per state. The user can choose which state to look into. This helps us understand how quickly the cases are being resolved overall for each state.

- A barplot of Number of new cases per state. The user can choose which state to look into. This helps us guage how new cases are popping up in each state overtime from April to December.

- I made distinct color for each quarter of the year to easily identify the differences across the qurters.

- I added the filter on the states and thought it to be best so the user could see data for all the states.



#### I Believe this analysis important as the COVID is currently world's most active problem to analyze.
#### The Audience can be a curious student a policy maker of a respective state or general public who wants to know how differnt states are doing overtime to fight covid and perhaps state governments could coordinate and learn from each other to better prepare for the same or similar.
#### By this analysis we can which U.S states are affected the most and where the most vaccines may be required when it becomes available for public.
#### We realize about 200,000 people have lost their life in U.S alone and have had around 14 million cases of Covid infections overall through this year.
#### We could also be able to see which states have been able to to bring down the spread of the virus and have been effective.
#### As we can see the most impacted states are Newyork, followed by Texas and California.
#### The best doing states are Vermont with overall 77 deaths.

## licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0) by the Johns Hopkins University on behalf of its Center for Systems Science in Engineering. Copyright Johns Hopkins University 2020.