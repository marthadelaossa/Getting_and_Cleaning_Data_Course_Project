#  Project of Getting and Cleaning Data Course
setwd("F:/DataScience/DataScience/3.CleaningData/Semana4/Getting_and_Cleaning_Data_Course_Project")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "data.zip" )
unzip("data.zip")
setwd("F:/DataScience/DataScience/3.CleaningData/Semana4/Getting_and_Cleaning_Data_Course_Project/UCI HAR Dataset")
#1.Merges the training and the test sets to create one data set.
#Read the files
# Reading files

# Trainings tables:
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")
# Testing tables:
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")
# Activity labels:
activityLabels = read.table('activity_labels.txt')
# Feature vector:
features <- read.table('features.txt')
#Assigning columns names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')
#Merges the training and the test sets to create one data set
trains <- cbind(y_train, subject_train, x_train)
tests <- cbind(y_test, subject_test, x_test)
All <- rbind(trains, tests)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

CNames <- colnames(All)
mean_std <- (grepl("activityId" , CNames) |
                   grepl("subjectId" , CNames) |  
                   grepl("activityLabels" , CNames) | 
                   grepl("mean" , CNames) | 
                   grepl("std" , CNames) 
)
MeanandStd <- All[ , mean_std == TRUE]

#3.Uses descriptive activity names to name the activities in the data set

ActivityNames <- merge(MeanandStd, activityLabels,
                           by='activityId',
                           all.x=TRUE)

#4.Appropriately labels the data set with descriptive variable names.
# Ready en 1 & 2

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
tidydata <- ActivityNames %>%
  group_by(subjectId, activityId,activityType) %>%
  summarise_all(funs(mean))
#write it to a .csv outputting the requested tidy dataset.
write.table(tidydata, "FinalData.txt", row.name=FALSE)
write.table(tidydata, "FinalData.csv", row.name=FALSE)
FinalData <- read.table("FinalData.txt")
FinalData2 <- read.table("FinalData.csv")
View(FinalData)