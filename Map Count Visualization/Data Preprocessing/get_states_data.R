###############################################
#Original author: Dan Liu
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#get the overall stateareas data 
###############################################

library("rjson")
library("XML")

setwd("/Users/Dan/IBM project/data/new")
files = list.files(pattern = '*.json')
json_file<-files[4]
json_data<-fromJSON(file=json_file)
state_name = c()
state_id = c()
area_name = c()
for (i in 1:278){
  str = json_data$result$data[[i]]$id
  state_id = c(state_id, as.numeric(substring(str, 21, nchar(str))))
  state_name = c(state_name, json_data$result$data[[i]]$stateName)
  area_name = c(area_name, json_data$result$data[[i]]$areaName)
}
state_area_all = cbind(state_id, state_name, area_name)
setwd("/Users/Dan/IBM project/data/new")
write.csv(state_area_all, file= "states_data.csv", row.names=FALSE)
