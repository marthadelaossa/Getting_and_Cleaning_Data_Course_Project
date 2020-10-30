---
title: "README.md"
author: "Martha De la Ossa"
date: "29/10/2020"
---

Getting and Cleaning Data Course Project README


According to the purpose of this project, the original data was transformed by the R script calls "run_analysis.R" in  5 steps:

Before to transformed the the original data it was necessary to set the working directory and download the information from the page where it was:

      setwd("F:/DataScience/DataScience/3. Cleaning Data/Semana 4/Getting_and_Cleaning_Data_Course_Project")
      url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file( url, destfile = "data.zip" )
      unzip("data.zip")
      setwd("F:/DataScience/DataScience/3. Cleaning Data/Semana 4/Getting_and_Cleaning_Data_Course_Project/UCI HARDataset")

1 Step : Merging the training and the test sets to create one data set:

   First the script Read the information File Trainings tables:
   
      x_train <- read.table("train/X_train.txt")
      y_train <- read.table("train/y_train.txt")
      subject_train <- read.table("train/subject_train.txt")
      
    Testing tables:
    
      x_test <- read.table("test/X_test.txt")
      y_test <- read.table("test/y_test.txt")
      subject_test <- read.table("test/subject_test.txt")
      
    Activity labels:
    
      activityLabels = read.table('activity_labels.txt')
     Feature vector:
      features <- read.table('features.txt')
      
2. Step: Appropriately labeling the data set with descriptive activity names.

    assigning columns names:
    
      colnames(x_train) <- features[,2] 
      colnames(y_train) <-"activityId"
      colnames(subject_train) <- "subjectId"
      colnames(x_test) <- features[,2] 
      colnames(y_test) <- "activityId"
      colnames(subject_test) <- "subjectId"
      colnames(activityLabels) <- c('activityId','activityType')
      
    and finally Merges the training and the test sets to create one data set
    
      trains <- cbind(y_train, subject_train, x_train)
      tests <- cbind(y_test, subject_test, x_test)
      All <- rbind(trains, tests)
         
   
3 Step: Extracting only the measurements on the mean and standard deviation for each measurement.

        CNames <- colnames(All)
        mean_std <- (grepl("activityId" , CNames) |
                           grepl("subjectId" , CNames) |  
                           grepl("activityLabels" , CNames) | 
                           grepl("mean" , CNames) | 
                           grepl("std" , CNames) 
        )
        MeanandStd <- All[ , mean_std == TRUE] 
        
4. Step: Using descriptive activity names to name the activities in the data set

         ActivityNames <- merge(MeanandStd, activityLabels,
                                 by='activityId',
                                 all.x=TRUE)

5. Creating a second, independent tidy data (FinalData.txt) set with the average of each variable for each activity and each subject.

          library(dplyr)
          tidydata <- ActivityNames %>%
            group_by(subjectId, activityId,activityType) %>%
            summarise_all(funs(mean))
          #write it to a ,txt outputting the requested tidy dataset.
          write.table(tidydata, "FinalData.txt", row.name=FALSE)
          FinalData <- read.table("FinalData.txt")
          FinalData2 <- read.table("FinalData.csv")
          

