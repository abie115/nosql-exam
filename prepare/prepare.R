death <- read.csv("D:\\nosql-egzam\\DeathRecords\\DeathRecords.csv")
ageType <- read.csv("D:\\nosql-egzam\\DeathRecords\\AgeType.csv")
education <- read.csv("D:\\nosql-egzam\\DeathRecords\\Education2003Revision.csv")
maritalStatus<- read.csv("D:\\nosql-egzam\\DeathRecords\\MaritalStatus.csv")
dayOfWeekOfDeath<- read.csv("D:\\nosql-egzam\\DeathRecords\\DayOfWeekOfDeath.csv")
race<- read.csv("D:\\nosql-egzam\\DeathRecords\\Race.csv")
mannerOfDeath<- read.csv("D:\\nosql-egzam\\DeathRecords\\MannerOfDeath.csv")
placeOfDeathAndDecedentsStatus<- read.csv("D:\\nosql-egzam\\DeathRecords\\PlaceOfDeathAndDecedentsStatus.csv")
activityCode<- read.csv("D:\\nosql-egzam\\DeathRecords\\ActivityCode.csv")
icd10code <- read.csv("D:\\nosql-egzam\\DeathRecords\\Icd10Code.csv")


filteredRecords = death[,c("Id", "Sex","AgeType","Age","PlaceOfDeathAndDecedentsStatus",
                           "MaritalStatus", "DayOfWeekOfDeath","MonthOfDeath","MannerOfDeath",
                           "ActivityCode","Icd10Code","Race","Education2003Revision")]

names(filteredRecords)[names(filteredRecords) == 'Education2003Revision'] <- 'Education'

filteredRecords <- left_join(filteredRecords, ageType, by = c("AgeType" = "Code"))
filteredRecords$AgeType <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "AgeType"

filteredRecords <- left_join(filteredRecords, education, by = c("Education" = "Code"))
filteredRecords$Education<- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "Education"

filteredRecords <- left_join(filteredRecords, maritalStatus, by = c("MaritalStatus" = "Code"))
filteredRecords$MaritalStatus<- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "MaritalStatus"

filteredRecords <- left_join(filteredRecords, dayOfWeekOfDeath, by = c("DayOfWeekOfDeath" = "Code"))
filteredRecords$DayOfWeekOfDeath <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "DayOfWeekOfDeath"

filteredRecords <- left_join(filteredRecords, race, by = c("Race" = "Code"))
filteredRecords$Race <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "Race"

filteredRecords <- left_join(filteredRecords, mannerOfDeath, by = c("MannerOfDeath" = "Code"))
filteredRecords$MannerOfDeath <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "MannerOfDeath"

filteredRecords <- left_join(filteredRecords, placeOfDeathAndDecedentsStatus, by = c("PlaceOfDeathAndDecedentsStatus" = "Code"))
filteredRecords$PlaceOfDeathAndDecedentsStatus <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "PlaceOfDeathAndDecedentsStatus"

filteredRecords <- left_join(filteredRecords, activityCode, by = c("ActivityCode" = "Code"))
filteredRecords$ActivityCode <- NULL
names(filteredRecords)[names(filteredRecords) == "Description"] <- "ActivityCode"

filteredRecords <- left_join(filteredRecords, icd10code, by = c("Icd10Code" = "Code"))
names(filteredRecords)[names(filteredRecords) == "Description"] <- "Icd10Code_Description"

filteredRecords$Icd10Code <- factor(dfilteredRecords$Icd10Code)

#write to csv
write.csv(filteredRecords,file = "D:\\nosql-egzam\\death_data.csv", row.names=FALSE)
