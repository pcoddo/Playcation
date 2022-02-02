library(rvest)
library(tidyverse)
library(dplyr)
library(stringi)
library(jsonlite)
library(stringr)
library(countrycode)


##################################
# Web scrape cities from Wikipedia
##################################

# URL: List of cities by international visitors
url = "https://en.wikipedia.org/wiki/List_of_cities_by_international_visitors"
xpath = "/html/body/div[3]/div[3]/div[5]/div[1]/table"

# Parse HTML table and links
cities_html = url %>%
  read_html() %>%
  html_node(xpath=xpath)

cities_table = cities_html %>%
  html_table()

cities_links = cities_html %>%
  html_nodes("tr") %>%
  html_node("a") %>%
  html_attr("href")

# Create data.frame
cities = cities_table
cities$Link = paste("https://en.m.wikivoyage.org", 
                    cities_links[2:length(cities_links)], sep="")

# Sort by Mastercard ranking and limit to top 100
cities = cities[order(cities$`Rank(Mastercard)`)[1:100],]

# Subset columns
cities = cities[,c(3,4,9)]

# Clean up
#cities$Country[which(cities$City=="Hong Kong")] = "Hong Kong"
cities$City[which(cities$City=="Delhi")] = "New Delhi"
cities$City[which(cities$City=="São Paulo")] = "Sao Paulo"
cities$City[which(cities$City=="Düsseldorf")] = "Duesseldorf"
cities$City[which(cities$City=="Zürich")] = "Zurich"
cities$City[which(cities$City=="Washington D.C.")] = "Washington, D.C."
cities$City[which(cities$City=="Frankfurt am Main")] = "Frankfurt"

##################################
# Find per diem rates
##################################

perdiem = read.csv("perdiem.csv")

# Find highest lodging value for each location
perdiem = perdiem %>%
  group_by(City) %>%
  summarise_each(funs(max))

# Insert lodging to cities data frame
cities = left_join(cities, perdiem, by = c("City")) %>%
  rename(Country = Country.y)
cities[,2] = NULL


##################################
# Geocode results
##################################

# Initialize lat/lon columns
cities$Latitude = NA
cities$Longtitude = NA

# Define geocode function
geocode = function(city, country){
  
  # Nominatim API 
  src_url = "https://nominatim.openstreetmap.org/search?q="
  
  # Address string
  query = paste(city, country, sep = "%2C")
  
  # Create URL from Nominatim API to return geojson
  requests = paste0(src_url, query, "&format=geojson")
  
  # Process response
  response = read_html(requests) %>%
    html_node("p") %>%
    html_text() %>%
    fromJSON()
  
  # Extract lat/lon
  lon = response$features$geometry$coordinates[[1]][1]
  lat = response$features$geometry$coordinates[[1]][2]
  
  coords = list(lat, lon)
  
  return(coords)
  
}  

# Apply to data frame
cities$Label = NA

for(i in 1:nrow(cities)){
  out = geocode(cities$City[i], cities$Country[i])
  
  cities$Latitude[i] = out[[1]]
  cities$Longtitude[i] = out[[2]]
  
  if(cities$City[i] != cities$Country[i]){
    
    cities$Label[i] = paste(cities$City[i], ", ", cities$Country[i], sep="")
    
  } else {
    cities$Label[i] = cities$City[i]
  }
  
}

# Add country code
cities$country_code = NA

for(i in 1:nrow(cities)){
  
  cities$country_code[i] = countrycode(cities$Country[i], origin = 'country.name', destination = 'iso3c')
  
}

# Save results
write.csv(cities, file = "cities.csv", row.names = FALSE)

