###############################################
#Original author: Dan Liu
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#get the occupation's bgtoccs data
###############################################

library("rjson")
library("XML")

setwd("/Users/Dan/IBM project/data/new/occupations")
occupations_files = list.files(pattern="*.json")

id = c()
bgtoccs = c()
for (i in 1:length(occupations_files)){
  setwd("/Users/Dan/IBM project/data/new/occupations")
  json_file<-occupations_files[i]
  json_data<-fromJSON(file=json_file)
  id = c(id, substring(json_file, 1, nchar(json_file)-5))
  bgtoccs = c(bgtoccs, json_data$result$data$bgtOcc)
}
bgtoccs_data = cbind(id, bgtoccs)
write.csv(bgtoccs_data, file= "bgtoccs_data.csv", row.names=FALSE)