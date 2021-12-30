# APD 2021 Data download

library(rvest)
library(tidyverse)
library(readr)
library(lubridate)
library(stringr)
library(xml2)

site = "https://www.atlantapd.org/i-want-to/crime-data-downloads"
session <- session(site)
Cobra_download2021 <- session %>% session_follow_link("COBRA-2021")
download_html(Cobra_download2021$url, "COBRA_2021.zip")
#Unzip and read data
unzip("COBRA_2021.zip")
CobraData_2021<- read_csv("COBRA-2021.csv", 
                          col_types = cols(rpt_date = col_date(format = "%m/%d/%Y"), 
                                           occur_date = col_date(format = "%m/%d/%Y"), 
                                           occur_time = col_time(format = "%H:%M"), 
                                           poss_date = col_date(format = "%m/%d/%Y"), 
                                           poss_time = col_time(format = "%H:%M")))
