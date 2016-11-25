## DOWNLOAD THE DATA 

setwd("~/Desktop/UCI HAR Dataset")
filesPath <- "~/Desktop/UCI HAR Dataset"
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## LOAD REQUIRED PACKAGES

library(dplyr)
library(data.table)
library(tidyr)

## # Read subject files

Path <- "~/Desktop/UCI HAR Dataset/data/UCI HAR Dataset"
data_Subject_Train <- tbl_df(read.table(file.path(Path, "train", "subject_train.txt")))
data_Subject_Test  <- tbl_df(read.table(file.path(Path, "test" , "subject_test.txt" )))

## Read activity files
data_Activity_Train <- tbl_df(read.table(file.path(Path, "train", "Y_train.txt")))
data_Activity_Test  <- tbl_df(read.table(file.path(Path, "test" , "Y_test.txt" )))

##Read data files.
data_Train <- tbl_df(read.table(file.path(Path, "train", "X_train.txt" )))
data_Test  <- tbl_df(read.table(file.path(Path, "test" , "X_test.txt" )))

## MERGE TRAINING AND TEST DATA SETS TO CREATE ONE DATA SET
mergeddataSubject <- rbind(data_Subject_Train, data_Subject_Test)
setnames(mergeddataSubject, "V1", "subject")
mergeddataActivity<- rbind(data_Activity_Train, data_Activity_Test)
setnames(mergeddataActivity, "V1", "activityNum")
 
#combine the DATA training and test files
dataTable <- rbind(dataTrain, dataTest)
 
 # name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- tbl_df(read.table(file.path(Path, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName
 
#column names for activity labels
activityLabels<- tbl_df(read.table(file.path(Path, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum","activityName"))
 
# Merge columns
mergeddataSubjAct<- cbind(mergeddataSubject, mergeddataActivity)
dataTable <- cbind(mergeddataSubjAct, dataTable)

## EXTRACT THE MEAN AND SD FOR EACH MEASUREMENT

dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE)
dataFeaturesMeanStd <- union(c("subject","activityNum"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd) 
 
dataTable <- merge(activityLabels, dataTable , by="activityNum", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)
 
dataTable$activityName <- as.character(dataTable$activityName)
 
head(str(dataTable),2)

## USE DESCRIPTIVE NAMES IN THE DATA SET
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))
head(str(dataTable),6)

## INDEPENDENT TIDY DATA SET
write.table(dataTable, "TidyData.txt", row.name=FALSE)
 