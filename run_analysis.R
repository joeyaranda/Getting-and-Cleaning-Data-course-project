setwd("C:\\")
install.packages("plyr")
library(plyr)

#download file from the given URL
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Load activity and features datasets
activlabels<-read.table("data\\UCI HAR Dataset\\activity_labels.txt")
activlabelscol2<-as.character(activlabels[,2])
features<-read.table("data\\UCI HAR Dataset\\features.txt")
featurescol2<-as.character(features[,2])
class(activlabels)

#Extract features with mean and standard dev observations
meanandstd<-grep(".*mean.*|.*std.*",featurescol2)
featname<-features[meanandstd,2]
featname_clean1<-gsub('-mean','Mean',featname)
featname_clean2<-gsub('-std','StDev',featname_clean1)
featname_clean3<-gsub('[-()]','',featname_clean2)

#Load trains and test datasets
x_train <- read.table("data\\UCI HAR Dataset\\train\\X_train.txt")[meanandstd]
y_train <- read.table("data\\UCI HAR Dataset\\train\\Y_train.txt")
sub_train <- read.table("data\\UCI HAR Dataset\\train\\subject_train.txt")
train <- cbind(sub_train, y_train, x_train)

x_test <- read.table("data\\UCI HAR Dataset\\test\\X_test.txt")[meanandstd]
y_test <- read.table("data\\UCI HAR Dataset\\test\\Y_test.txt")
sub_test <- read.table("data\\UCI HAR Dataset\\test\\subject_test.txt")
test <- cbind(sub_test, y_test, x_test)

#Merge train and test observations
mergedata <- rbind(train, test)
colnames(mergedata) <- c("Subject", "Activity", featname_clean3)

mergedata$Activity <- factor(mergedata$Activity, levels = activlabels[,1], labels = activlabels[,2])
mergedata$Subject <- as.factor(mergedata$Subject)

#Create second tidy dataset
secondtidydata<-aggregate(.~Subject + Activity,mergedata,mean)
arrangesecondtidydata<-arrange(secondtidydata,Subject)
write.table(arrangesecondtidydata,"data\\NewTidyData.txt",row.name=FALSE)
