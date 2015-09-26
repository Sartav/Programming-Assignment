#Download file and Read Files

fileSource <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileSource,destfile="./GCDWeek3/Dataset.zip",method="curl")
unzip(zipfile="./GCDWeek3/Dataset.zip",exdir="./GCDWeek3")
path <- file.path("./GCDWeek3" , "UCI HAR Dataset")

Subject_Train <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
Subject_Test <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
Activity_Train <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
Activity_Test <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
Features_Train <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
Features_Test  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)

#Merge the training and the test sets to create one data set and add labels

Subject_TrainTest <- rbind(Subject_Train, Subject_Test)
Activity_TrainTest <- rbind(Activity_Train, Activity_Test)
Features_TrainTest <- rbind(Features_Train, Features_Test)

names(Subject_TrainTest)<-c("subject")
names(Activity_TrainTest)<- c("activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features_TrainTest)<- FeaturesNames$V2

AllTogether <- cbind(Subject_TrainTest, Activity_TrainTest, Features_TrainTest)
View(AllTogether)

MeanSDData <-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
View(MeanSDData)

SpecificName<-c(as.character(MeanSDData), "activity", "subject" )
AllTogether<-subset(AllTogether,select=SpecificName)

View(AllTogether)
str(AllTogether)

#Create tidy dataset
library(plyr)
AllTogetherFinal<-aggregate(. ~subject + activity, AllTogether, mean)
AllTogetherFinal<-AllTogetherFinal[order(AllTogetherFinal$subject,AllTogetherFinal$activity),]
write.table(AllTogetherFinal, file = "tidydata.txt",row.name=FALSE)
