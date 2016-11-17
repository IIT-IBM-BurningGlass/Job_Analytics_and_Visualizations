###############################################
#Original author: Dan Liu
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#get all count data in all states for all occupations
#"states_geo_continent.csv" given by 'https://inkplant.com/code/state-latitudes-longitudes'
#"states_geo.csv" should be "states_geo_continent.csv" plus coordinates data of Puerto Rico, Virgin Islands and Guam
###############################################

library("rjson")
library("XML")

setwd("/Users/Dan/IBM project/data/new/occupations")
occupations_files = list.files(pattern="*.json")
occupation_id_list = c()
for (i in 1:length(occupations_files)){
  setwd("/Users/Dan/IBM project/data/new/occupations")
  json_file<-occupations_files[i]
  json_data<-fromJSON(file=json_file)
  occupation_id_list = c(occupation_id_list, substring(json_file, 1, nchar(json_file)-5))
}

setwd("/Users/Dan/IBM project/data/new")
#states_geo = read.csv("states_geo.csv")
states_geo = read.csv("states_geo_continent.csv")#
states_geo = as.matrix(states_geo)

setwd("/Users/Dan/IBM project/data/new")
files = list.files(pattern = '*.json')
json_file<-files[4]
json_data<-fromJSON(file=json_file)
state_name = c()
state_id = c()
area_name = c()
for (i in 1:length(json_data$result$data)){
  str = json_data$result$data[[i]]$id
  state_id = c(state_id, as.numeric(substring(str, 21, nchar(str))))
  state_name = c(state_name, json_data$result$data[[i]]$stateName)
  area_name = c(area_name, json_data$result$data[[i]]$areaName)
}
state_area_all = cbind(state_id, state_name, area_name)

getCount <- function(i){
  setwd(paste("/Users/Dan/IBM project/data/new/occupations-all-areas-all/", as.numeric(i), sep = ""))
  occupations_count_files = list.files(pattern="*.json")
  
  state_id = c()
  occupation_id = c()
  count = c()
  for (i in 1:length(occupations_count_files)){
    json_file<-occupations_count_files[i]
    json_data<-fromJSON(file=json_file)
    count = c(count, json_data$result$data$JobOpenings)
    str = strsplit(json_file, "-")[[1]]
    state_id = c(state_id, substring(str[2], 1, nchar(str[2])-5))
    occupation_id = c(occupation_id, str[1])
  }
  occupation_count = cbind(occupation_id, state_id, count)
  occupation_count = as.matrix(merge(state_area_all, occupation_count,  by = 'state_id'))
  
  State = c()
  areas_count_sum = c()
  #occupation_id = c()
  occupation_id = as.numeric(occupation_count[1,4])#
  for(i in 1:dim(states_geo)){
    temp = which(occupation_count[,2] == states_geo[i,1])
    State = c(State, states_geo[i,1])
    areas_count_sum = c(areas_count_sum, sum(as.numeric(occupation_count[temp, 5])))# add all area counts in as one state counts (including individual area and "all areas")
    #occupation_id = c(occupation_id, as.numeric(occupation_count[1,4])
  }
  #occupation_count_total = cbind(State,occupation_id, areas_count_sum)
  occupation_count_total = cbind(State, areas_count_sum)#
  colnames(occupation_count_total) = c("State", occupation_id)#
  #occupation_count_total2 = merge(states_geo, occupation_count_total, by = 'State')
  #return(occupation_count_total2)
  return(occupation_count_total)#
}

temp = getCount(as.numeric(occupation_id_list[1]))
for (i in 2:length(occupation_id_list)){
  temp = merge(temp, getCount(as.numeric(occupation_id_list[i])), by = "State")
}
setwd("/Users/Dan/IBM project/data/new")
#write.csv(temp, file = "Count-allOccupations-allStates.csv", row.names=FALSE)
write.csv(temp, file = "Count-allOccupations-Continent.csv", row.names=FALSE)