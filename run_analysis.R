## Download file, extract contents, and set working directory

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
"Course Project Data.zip")
unzip("Course Project Data.zip")
setwd('./UCI HAR Dataset')

## 1. Load, create, and merge the two data sets

train <- read.table('./train/x_train.txt', header = FALSE)
trainLabels <- read.table('./train/y_train.txt', header = FALSE)
trainSubjects <- read.table('./train/subject_train.txt', header = FALSE)

test <- read.table('./test/x_test.txt', header = FALSE)
testLabels <- read.table('./test/y_test.txt', header = FALSE)
testSubjects <- read.table('./test/subject_test.txt', header = FALSE)

data <- rbind(train, test)
labels <- rbind(trainLabels,testLabels)
subjects <- rbind(trainSubjects, testLabels)

## 2. Extract only mean and standard deviation measurements

colNames <- read.table('./features.txt', header = FALSE)
relevantFeatures <- grep("-(mean|std)\\(\\)",colNames[,2])
data <- data[, relevantFeatures]
colnames(data) <- colNames[relevantFeatures,2]

## 3. Descriptive activity names applied to the data set's activities

activityNames <- read.table("activity_labels.txt", header = FALSE)
labels[,1] <- activityNames[labels[,1],2]

## 4. Variables labelled appropriately
colnames(subjects) <- "Subjects"
colnames(labels) <- "Activities"
colnames(data) <- colNames[relevantFeatures,2]

## Join the subjects and activity labels onto the data set

data <- cbind(subjects, labels, data)

## 5. Average of each variable for each activity and subject created and written to new, independent data set

library(plyr)
tidyData <- aggregate(. ~ Subjects + Activities, data, mean)
tidyData <- tidyData[order(tidyData$Subjects, tidyData$Activities),]
write.table(tidyData, "tidyData.txt", row.name = FALSE)
