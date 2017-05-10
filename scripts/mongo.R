library(mongolite)
require(ggplot2)
require(scales)

mongo_deaths <- mongo(collection = "deaths", db = "dbexam")
mongo_conditions <- mongo(collection = "conditions", db = "dbexam")
mongo_icd10 <- mongo(collection = "icd10", db = "dbexam")

#############agregacja1
agg1<-mongo_deaths$aggregate('[  
          { "$match":{
              "MannerOfDeath":"Suicide",
              "AgeType":"Years"}},
          { "$bucket":{  
              "groupBy":"$Age",
              "boundaries":[ 1,10,20,30,40,50,60,70,80,90,100],
              "default":"Other"}}
             ]')
agg1
colnames(agg1)[which(names(agg1) == "_id")] <- "age"
ggplot( data = agg1, aes(age,count,group = 1 )) + geom_bar(stat="identity") + 
  xlab("przedzia³ wiekowy") + ylab("liczba samobójstw")

########agregacja2
agg2<-mongo_deaths$aggregate('[
  { "$match":{
    "AgeType":"Years",
    "Education":{ "$ne":"NA" },
    "$and":[ {"Age":{"$gt":35}}, {"Age":{"$lt":100}}]}},
  { "$facet":{
    "Education":[
      { "$group":{
        "_id":{ "sex":"$Sex","edu":"$Education" },
        "count":{ "$sum":1 }}},
      { "$sort":{ "count":-1 }},
      { "$group":{
       "_id":"$_id.sex",
        "education":{ "$push":{ "range":"$_id.edu","total":"$count" }}}}
      ],
   "Marriage":[
      { "$group":{
        "_id":{ "sex":"$Sex", "status":"$MaritalStatus" },
        "count":{ "$sum":1} }},
      { "$sort":{ "count":-1 }},
      { "$group":{
        "_id":"$_id.sex",
        "marriage":{ "$push":{"status":"$_id.status","total":"$count"}}}}
      ]
  }}
  ]')

agg2
edu_m<-agg2$Education[[1]]$education[[1]]
edu_f<-agg2$Education[[1]]$education[[2]]
edu_m$name <- "male"
edu_f$name <- "female"
edu <- rbind(edu_m,edu_f)
p <- ggplot(edu, aes(range,total, fill = name)) + geom_bar(stat="identity",position = "dodge")
f<-p+theme(axis.text.x = element_text(angle = 90, hjust = 1))+ scale_y_continuous(name="liczba zgonów", labels = comma)+
  xlab("stopieñ edukacji") 
f

mar_f<-agg2$Marriage[[1]]$marriage[[1]]
mar_m<-agg2$Marriage[[1]]$marriage[[2]]
mar_m$name <- "male"
mar_f$name <- "female"
mar <- rbind(mar_m,mar_f)
p <- ggplot(mar, aes(status,total, fill = name)) + geom_bar(stat="identity",position = "dodge")
f<-p+theme(axis.text.x = element_text(angle = 90, hjust = 1))+ scale_y_continuous(name="liczba zgonów", labels = comma)+
  xlab("stan cywilny")
f

####agregacja3
agg3_1<-mongo_deaths$aggregate('[
   { "$project": {
       "Id": 1,
       "MannerOfDeath": 1,
       "Race_new": {
         "$switch": {
           "branches": [
              { "case": { "$eq": ["$Race","White"]},"then": "White"},
              { "case": { "$eq": ["$Race","Black"]},"then": "Black"},
              { "case": { "$or": [
                { "$eq": ["$Race","Chinese"]},{ "$eq": ["$Race","Japanese"]},
                { "$eq": ["$Race","Asian Indian"]},{"$eq": ["$Race","Korean"]},
                { "$eq": ["$Race","Other Asian or Pacific Islander"]},
                { "$eq": ["$Race","American Indian (includes Aleuts and Eskimos)"]},
                { "$eq": ["$Race","Vietnamese"]},{ "$eq": ["$Race","Guamanian"]}]},
                  "then": "Yellow"}],
               "default": "Did not match"}}}},
   { "$match": { "Race_new": {"$ne": "Did not match"}}},
   { "$group": { "_id": { "race": "$Race_new"},"count": {"$sum": 1}}},
   { "$project": { "_id": 0,"race": "$_id.race","count": "$count"}}]')

yellow<-agg3_1$count[1]
black<-agg3_1$count[2]
white<-agg3_1$count[3]

agg3_2<-mongo_deaths$aggregate(paste('[
  { "$project": {
      "Id": 1,
      "MannerOfDeath": 1,
      "Race_new": {
        "$switch": {
         "branches": [
           { "case": { "$eq": ["$Race","White"]},"then": "White"},
           { "case": { "$eq": ["$Race","Black"]},"then": "Black"},
           { "case": { "$or": [
             { "$eq": ["$Race","Chinese"]},{ "$eq": ["$Race","Japanese"]},
             { "$eq": ["$Race","Asian Indian"]},{"$eq": ["$Race","Korean"]},
             { "$eq": ["$Race","Other Asian or Pacific Islander"]},
             { "$eq": ["$Race","American Indian (includes Aleuts and Eskimos)"]},
             { "$eq": ["$Race","Vietnamese"]},{ "$eq": ["$Race","Guamanian"]}]},
                "then": "Yellow"}],
           "default": "Did not match"}}}},
  { "$match": {"MannerOfDeath":"Homicide","Race_new":{"$ne": "Did not match"} } },
  { "$group": {"_id":{"race": "$Race_new"}, "count": {"$sum": 1} } }, 
  { "$project": { "percentage of all deaths":
          { "$switch": {
              "branches": [
                { "case": { "$eq": [ "$_id.race","White" ] }, 
                       "then": {"$multiply":[{"$divide":[100,',white,']},"$count"]} },
                { "case": { "$eq": [ "$_id.race","Black" ] }, 
                       "then": {"$multiply":[{"$divide":[100,',black,']},"$count"]} },
                { "case": { "$eq": [ "$_id.race","Yellow" ] }, 
                       "then": {"$multiply":[{"$divide":[100,',yellow,']},"$count"]} }],
                "default": "0"}},"_id":0,"count":"$count","race":"$_id.race"}}]'))

write.csv(agg3_2,file="D:\\nosql-egzam\\nosql-exam\\results\\result3.csv",row.names = FALSE)

#########agregacja4
agg4<-mongo_conditions$aggregate('[
  { "$group":{
      "_id":"$DeathRecordId",
      "Other_conditions":{ "$push":"$$ROOT" }}},
  { "$match":{
      "Other_conditions":{
        "$elemMatch":{ "Part":1,"Line":1,"Icd10Code":"I469"}}}},
  { "$unwind":"$Other_conditions" },
  { "$match":{
      "Other_conditions.Icd10Code":{ "$ne":"I469" },
      "Other_conditions.Part":2 }},
  { "$group":{
      "_id":"$Other_conditions.Icd10Code",
      "count":{"$sum":1}}},
  { "$sort":{"count":-1 } },
  { "$limit":10 },
  { "$lookup":{
      "from":"icd10",
      "localField":"_id",
      "foreignField":"Code",
      "as":"Icd10Description" }},
  { "$unwind":"$Icd10Description"},
  { "$project":{
      "_id":0,
      "code":"$_id",
      "description":"$Icd10Description.Description",
      "count_of_cases":"$count"}}
  ]',options = '{"allowDiskUse":true}')
agg4
write.csv(agg4,file="D:\\nosql-egzam\\nosql-exam\\results\\result4.csv",row.names = FALSE)

