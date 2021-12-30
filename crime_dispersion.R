# Crime Dispersion

# https://www.jratcliffe.net/post/how-widespread-are-crime-increases-here-is-one-analytical-method

# get t1 and t2 data frames

df_2019 <- df_all %>% 
        filter(year(rpt_date) == 2019)

df_2020 <- df_all %>% 
        filter(year(rpt_date) == 2020)

# filter for larceny from auto


sub_2019 <- df_2019 %>% 
        filter(UC_literal =='Auto Theft') %>% 
        count(beat)

sub_2020 <- df_2020 %>% 
        filter(UC_literal =='Auto Theft') %>% 
        count(beat)

# join data into one data frame

df_joined <- sub_2019 %>% 
        full_join(sub_2020, by = 'beat') %>% 
        rename(crime2019 = n.x, crime2020 = n.y) %>% 
        mutate_if(is.numeric,coalesce,0) %>% 
        as.data.frame() %>% 
        mutate(beat = as.character(beat))

# Crime Dispersion

#install.packages("devtools")
#library(devtools)
#install_github("jerryratcliffe/crimedispersion")

library(crimedispersion)

output <- crimedispersion(df_joined, 'beat','crime2019','crime2020', method = 'match')

output[[2]]





