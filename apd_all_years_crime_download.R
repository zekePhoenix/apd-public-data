# Download all APD crime data from atlantapd.org

library(rvest)
library(tidyverse)
library(readr)
library(lubridate)
library(stringr)
library(xml2)

# DATA DOWNLOAD ----
# 1. Download zipfiles from atlantapd.org
# 2. bind all data into one dataframe

# *1a. Download Historical data from 2009 forward--------------------------------
site = "https://www.atlantapd.org/i-want-to/crime-data-downloads"
session <- session(site)
Cobra_download_historical <- session %>% session_follow_link("COBRA-2009")
download_html(Cobra_download_historical$url, "COBRA_historical.zip")
#Unzip and read data
unzip("COBRA_historical.zip")
CobraData_historical <- read_csv("COBRA-2009-2019.csv", 
                                 col_types = cols(`Occur Date` = col_date(format = "%Y-%m-%d"), 
                                                  `Possible Date` = col_date(format = "%Y-%m-%d"), 
                                                  `Report Date` = col_date(format = "%Y-%m-%d"),
                                                  `Occur Time` = col_time(format = "%H%M"),
                                                  `Possible Time` = col_time(format = "%H%M")))





# *1b. Download 2020 ICIS Data ------------------------------------------------
site = "https://www.atlantapd.org/i-want-to/crime-data-downloads"
session <- session(site)
Cobra_download2020 <- session %>% session_follow_link("COBRA-2020-Old")
#dateUploaded <- Cobra_download$response$headers$`last-modified`
download_html(Cobra_download2020$url, "COBRA_2020_ICIS.zip")
#Unzip and read data
unzip("COBRA_2020_ICIS.zip")
CobraData_2020_ICIS <- read_csv("COBRA-2020-OldRMS-09292020.csv", 
                                col_types = cols(rpt_date = col_date(format = "%m/%d/%Y"), 
                                                 occur_date = col_date(format = "%m/%d/%Y"), 
                                                 occur_time = col_time(format = "%H:%M"), 
                                                 poss_date = col_date(format = "%m/%d/%Y"), 
                                                 poss_time = col_time(format = "%H:%M")))

# *1c. Download 2020 Mark43 Data ------------------------------------------------
site = "https://www.atlantapd.org/i-want-to/crime-data-downloads"
session <- session(site)
Cobra_download2020_m43 <- session %>% session_follow_link("COBRA-2020 (NEW")
download_html(Cobra_download2020_m43$url, "COBRA_2020_Mark43.zip")
#Unzip and read data
unzip("COBRA_2020_Mark43.zip")
CobraData_2020_Mark43 <- read_csv("COBRA-2020(NEW RMS 9-30 12-31).csv", 
                                  col_types = cols(rpt_date = col_date(format = "%m/%d/%Y"), 
                                                   occur_date = col_date(format = "%m/%d/%Y"), 
                                                   occur_time = col_time(format = "%H:%M"), 
                                                   poss_date = col_date(format = "%m/%d/%Y"), 
                                                   poss_time = col_time(format = "%H:%M")))

# *1d. Download 2021 fresh data ------------------------------------------------
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

# *1d. Download 2022 fresh data ------------------------------------------------

site = "https://www.atlantapd.org/i-want-to/crime-data-downloads"
session <- session(site)
Cobra_download2022 <- session %>% session_follow_link("COBRA-2022")
download_html(Cobra_download2022$url, "COBRA_2022.zip")
#Unzip and read data
unzip("COBRA_2022.zip")
CobraData_2022<- read_csv("COBRA-2022.csv", 
                          col_types = cols(rpt_date = col_date(format = "%m/%d/%Y"), 
                                           occur_date = col_date(format = "%m/%d/%Y"), 
                                           occur_time = col_time(format = "%H:%M"), 
                                           poss_date = col_date(format = "%m/%d/%Y"), 
                                           poss_time = col_time(format = "%H:%M")))


# 2. Wrangle All COBRA data and bind ----

names(CobraData_historical)
names(CobraData_2020_ICIS)
names(CobraData_2020_Mark43)
names(CobraData_2021)

# COBRA Historical 

df_historical <- CobraData_historical %>% 
        rename(offense_id = `Report Number`, rpt_date = `Report Date`, occur_date = `Occur Date`,
               occur_time = `Occur Time`, poss_date = `Possible Date`, poss_time = `Possible Time`,
               beat = Beat, apartment_office_prefix = `Apartment Office Prefix`,
               apartment_number = `Apartment Number`, location = Location, watch = `Shift Occurence`,
               location_type = `Location Type`, UC2_Literal = `UCR Literal`, UCR_Number = `UCR #`,
               ibr_code = `IBR Code`, neighborhood = Neighborhood, npu = NPU, lat = Latitude,
               long = Longitude)

# COBRA 2020 ICIS

df_2020_icis <- CobraData_2020_ICIS %>% 
        add_column(ibr_code = NA)

# COBRA 2020 Mark43

df_2020_m43 <- CobraData_2020_Mark43 %>% 
        dplyr::select(-MinOfucr, -dispo_code) %>% 
        rename(apartment_office_prefix = apt_office_prefix, apartment_number = apt_office_num, watch = Shift,
               location_type = loc_type) %>% 
        add_column(UCR_Number = NA)

# COBRA 2021

df_2021 <- CobraData_2021 %>% 
        dplyr::select(-zone,-occur_day_num, -occur_day) %>% 
        add_column(apartment_office_prefix = NA, apartment_number = NA, watch = NA, location_type = NA,
                   UCR_Number = NA)


# COBRA 2022

df_2022 <- CobraData_2022%>% 
        dplyr::select(-zone,-occur_day_num, -occur_day) %>% 
        add_column(apartment_office_prefix = NA, apartment_number = NA, watch = NA, location_type = NA,
                   UCR_Number = NA)

df_all <- rbind(df_historical, df_2020_icis, df_2020_m43,df_2021, df_2022)

#join uc codes

df_uc_codes <- data.frame(UC2_Literal = unique(df_all$UC2_Literal),
                          UC_literal = c('Larceny-Non Vehicle','Larceny-From Vehicle','Robbery',
                                         'Robbery','Auto Theft','Agg Assault','Burglary','Burglary',
                                         'Robbery','Homicide','Homicide','Robbery',
                                         'Burglary'))


df_all <- inner_join(df_all, df_uc_codes)

# define crimes as factors

uc_levels <- c('Homicide','Robbery','Agg Assault',
               'Burglary','Larceny-From Vehicle',
               'Larceny-Non Vehicle','Auto Theft')

df_all$UC_literal <- factor(df_all$UC_literal,levels = uc_levels)

df_all <- df_all %>% 
        mutate(occur_time = as.character(occur_time)) %>% 
        mutate(poss_time = as.character(poss_time))
saveRDS(df_all,"apd_all_crime.RDS")
write_csv(df_all, "apd_public_crime_data.csv", col_names = TRUE)
