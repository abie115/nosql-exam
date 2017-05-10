require(dplyr)

death <- read.csv("D:\\nosql-egzam\\DeathRecords\\DeathRecords.csv")
ageType <- read.csv("D:\\nosql-egzam\\DeathRecords\\AgeType.csv")
education <- read.csv("D:\\nosql-egzam\\DeathRecords\\Education2003Revision.csv")
maritalStatus<- read.csv("D:\\nosql-egzam\\DeathRecords\\MaritalStatus.csv")
dayOfWeekOfDeath<- read.csv("D:\\nosql-egzam\\DeathRecords\\DayOfWeekOfDeath.csv")
race<- read.csv("D:\\nosql-egzam\\DeathRecords\\Race.csv")
mannerOfDeath<- read.csv("D:\\nosql-egzam\\DeathRecords\\MannerOfDeath.csv")
activityCode<- read.csv("D:\\nosql-egzam\\DeathRecords\\ActivityCode.csv")
#icd10code <- read.csv("D:\\nosql-egzam\\DeathRecords\\Icd10Code.csv")


filteredSet = death[,c("Id", "Sex","AgeType","Age","PlaceOfDeathAndDecedentsStatus",
                           "MaritalStatus", "DayOfWeekOfDeath","MonthOfDeath","MannerOfDeath",
                           "ActivityCode","Icd10Code","Race","Education2003Revision")]

names(filteredSet)[names(filteredSet) == 'Education2003Revision'] <- 'Education'

filteredSet <- left_join(filteredSet, ageType, by = c("AgeType" = "Code"))
filteredSet$AgeType <- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "AgeType"

filteredSet <- left_join(filteredSet, education, by = c("Education" = "Code"))
filteredSet$Education<- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "Education"

filteredSet <- left_join(filteredSet, maritalStatus, by = c("MaritalStatus" = "Code"))
filteredSet$MaritalStatus<- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "MaritalStatus"

filteredSet <- left_join(filteredSet, dayOfWeekOfDeath, by = c("DayOfWeekOfDeath" = "Code"))
filteredSet$DayOfWeekOfDeath <- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "DayOfWeekOfDeath"

filteredSet <- left_join(filteredSet, race, by = c("Race" = "Code"))
filteredSet$Race <- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "Race"

filteredSet <- left_join(filteredSet, mannerOfDeath, by = c("MannerOfDeath" = "Code"))
filteredSet$MannerOfDeath <- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "MannerOfDeath"

filteredSet <- left_join(filteredSet, activityCode, by = c("ActivityCode" = "Code"))
filteredSet$ActivityCode <- NULL
names(filteredSet)[names(filteredSet) == "Description"] <- "ActivityCode"

#filteredSet <- left_join(filteredSet, icd10code, by = c("Icd10Code" = "Code"))
#names(filteredSet)[names(filteredSet) == "Description"] <- "Icd10Code_Description"

#filteredSet$Icd10Code <- factor(dfilteredSet$Icd10Code)

#write to csv
write.csv(filteredSet,file = "D:\\nosql-egzam\\DeathRecords_prepare.csv", row.names=FALSE)
