library(jsonlite)
library(dplyr)
library(readr)

Sys.setlocale("LC_CTYPE", "russian")

path <- "museums.json"
source <- fromJSON(path, simplifyVector = TRUE)

head(source, 1)
names(source)

data <- source$data$general
head(data, 1)
names(data)

data <- data %>% select(id, name, address, organization, tags, extraFields) 

data$fullAddress <- data$address$fullAddress
data$coordinates <- data$address$mapPosition$coordinates
data$types <- data$extraFields$types

data <- data %>% select(-address, -extraFields)
data$organization <- select(data$organization, -address, -locale, -inn, -subordinationIds, -subordination, -localeIds)

data %>%
  toJSON(pretty = TRUE) %>%
  write_lines("museums-v2.json")


simpl <- data %>% select(-fullAddress, -types)
simpl$organization <- simpl$organization$type

simpl %>%
  toJSON(pretty = TRUE) %>%
  write_lines("museums-simpl.json")
