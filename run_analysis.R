##Load dplyr library
library("dplyr")

##Set up working directory

setwd("./R Coursera/Getting and Cleaning Data")

##Get the data file downloaded

filename <- "Coursera_DS3_Final.zip"

if(!file.exists(filename)){
  fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,filename, method="curl")
}

##Check and unzip the files in the folder

if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

## Read data into tables

features<-read.table("UCI HAR Dataset/features.txt",col.names=c("sno,","feature_desc"))
activity<-read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("sno","activity_label"))
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
test_x<-read.table("UCI HAR Dataset/test/X_test.txt", col.names=features$feature_desc)
test_y<-read.table("UCI HAR Dataset/test/y_test.txt", col.names = "labels")

subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
train_x<-read.table("UCI HAR Dataset/train/X_train.txt", col.names=features$feature_desc)
train_y<-read.table("UCI HAR Dataset/train/y_train.txt", col.names = "labels")

##Merge the training and test data sets
X<-rbind(train_x,test_x)
Y<-rbind(train_y,test_y)
Subject <- rbind(subject_train, subject_test)
Merged_Data<-cbind(Subject, Y, X)

## Select only mean and standard deviations of the observations
TidyData<- Merged_Data %>% select(subject, labels, contains("mean"), contains("std"))

##Assign activity labels
TidyData$labels<-activity[TidyData$labels,2]

## Assign descriptive names to the table data

names(TidyData)[2]<-"Activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

## Group data by Activity and Person

Summary_Data<-TidyData %>% group_by(Activity, subject)

## create a second, independent tidy data set with the average of each 
## variable for each activity and each subject.

FinalData<-summarise_all(Summary_Data, funs(mean))
write.table(FinalData, "FinalData.txt", row.names = FALSE)


