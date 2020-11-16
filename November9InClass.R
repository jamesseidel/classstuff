library("tidyverse")
library("lubridate")
library("stringr")
library("viridis")
library("sf")

storm <- read_csv("StormEvents_details-ftp_v1.0_d2019_c20201017.csv.gz")

storms_2019 <- storm %>% 
  select(BEGIN_DATE_TIME, END_DATE_TIME, 
         EPISODE_ID:STATE_FIPS, EVENT_TYPE:CZ_NAME, SOURCE,
         BEGIN_LAT:END_LON) %>% 
  mutate(BEGIN_DATE_TIME = dmy_hms(BEGIN_DATE_TIME),
         END_DATE_TIME = dmy_hms(END_DATE_TIME),
         STATE = str_to_title(STATE),
         CZ_NAME = str_to_title(CZ_NAME)) %>% 
  filter(CZ_TYPE == "C") %>% 
  select(-CZ_TYPE) %>% 
  mutate(STATE_FIPS = str_pad(STATE_FIPS, 2, side = "left", pad = "0"),
         CZ_FIPS = str_pad(CZ_FIPS, 3, side = "left", pad = "0")) %>% 
  unite(fips, STATE_FIPS, CZ_FIPS, sep = "") %>% 
  rename_all(funs(str_to_lower(.)))

colo_events <- storms_2019 %>% 
  filter(state == "Colorado") %>% 
  group_by(fips) %>% 
  count()

library("tigris")
co_counties <- counties(state = "CO", cb = TRUE, class = "sf")

install.packages("tigris")



