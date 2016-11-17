###############################################
#Original author: Dan Liu
#Last modified by: Dan Liu
#Last modified time: 11/16/2016
#get the occupations data and its corresponding careerareas
###############################################

library("rjson")
library("XML")

setwd("/Users/Dan/IBM project/data/new/occupations")
occupations_files = list.files(pattern="*.json")

id = c()
firststep = c()
starterjob = c()
occupation_group_id = c()
occupation_group_name = c()
for (i in 1:length(occupations_files)){
  setwd("/Users/Dan/IBM project/data/new/occupations")
  json_file<-occupations_files[i]
  json_data<-fromJSON(file=json_file)
  id = c(id, substring(json_file, 1, nchar(json_file)-5))
  firststep = c(firststep, json_data$result$data$firstStep)
  starterjob = c(starterjob, json_data$result$data$starterJob)
  group_id_temp = json_data$result$data$occupationGroup$id
  group_id_temp = substring(group_id_temp, 27, nchar(group_id_temp))
  occupation_group_id = c(occupation_group_id, group_id_temp)
  occupation_group_name = c(occupation_group_name, json_data$result$data$occupationGroup$name)
}
firststep_group_data = as.data.frame(cbind(id, firststep, starterjob,occupation_group_id, occupation_group_name))

setwd("/Users/Dan/IBM project/data/new/careerareas")
careerares_files = list.files(patter = "*.json")

id = c()
careerarea_id = c()
careerarea_name = c()
for(i in 1: length(careerares_files)){
  setwd("/Users/Dan/IBM project/data/new/careerareas")
  json_file<-careerares_files[i]
  json_data<-fromJSON(file=json_file)
  id_temp = substring(json_file, 12, nchar(json_file))
  id = c(id, substring(id_temp, 1, nchar(id_temp)-5))
  career_id_temp = json_data$result$data[[1]]$id
  career_id_temp = substring(career_id_temp, 22, nchar(career_id_temp))
  careerarea_id = c(careerarea_id, career_id_temp)
  careerarea_name = c(careerarea_name, json_data$result$data[[1]]$name)
}
career_data = as.data.frame(cbind(id, careerarea_id, careerarea_name))

id_firststep_group_career = merge(firststep_group_data, career_data, by = 'id')

setwd("/Users/Dan/IBM project/data/new")
write.csv(id_firststep_group_career, file = "Occupationid_firststep_group_careerarea.csv", row.names=FALSE)
