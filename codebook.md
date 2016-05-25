# Codebook
James Shepherd  
May 24, 2016  
The following code (also stored in run_analysis.R) peforms the following steps:  
- Downloads the UCI HAR Dataset  
- Merges together the training and testing data sets  
- Extracts columns that pertain to mean and standard deviation from the data set (and ignores the others)  
- Takes the activity names and Ids from activity_labels.txt and replaces the numeric activity values 1 through 6 with the actual activity name  
- Applies the correct column names to the data set (for all 66 mean and standard deviation variables, as well as the activity and subject columns)  
- Generates a new, tidy data set that calculates the average measure values for each subject and activity, storing the output in a file called tidyData.txt  
  
The raw data tables from the UCI HAR Dataset that are used are the following:  
features.txt - contains the column names for each variable measured  
activity_labels.txt - contains the labels for the 6 activities being measured   
subject_train.txt - contains subject labels for the training data set  
x_train.txt - contains the values measured for each training observation  
y_train.txt - contains the values measured for each training observation  
subject_test.txt - contains the subject labels for the test data set  
x_test.txt - contains the values measured for each testing observation  
y_test.txt - contains the values measured for each testing observation  
  
These observations are for 30 volunteers performing 6 activities (walking, walking upstairs, walking downstairs, sitting, standing, and laying)  
  
## 1. Load, create, and merge the two data sets  

```r
train <- read.table('./UCI HAR Dataset/train/x_train.txt', header = FALSE)
trainLabels <- read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE)
trainSubjects <- read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE)
```
   

```r
test <- read.table('./UCI HAR Dataset/test/x_test.txt', header = FALSE)
testLabels <- read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE)
testSubjects <- read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE)
```


```r
data <- rbind(train, test)
labels <- rbind(trainLabels,testLabels)
subjects <- rbind(trainSubjects, testLabels)
```
  
## 2. Extract only mean and standard deviation measurements  

```r
colNames <- read.table('./UCI HAR Dataset/features.txt', header = FALSE)
relevantFeatures <- grep("-(mean|std)\\(\\)",colNames[,2])
data <- data[, relevantFeatures]
colnames(data) <- colNames[relevantFeatures,2]
```
  
## 3. Descriptive activity names applied to the data set's activities  

```r
activityNames <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
labels[,1] <- activityNames[labels[,1],2]
```
  
## 4. Variables labelled appropriately  

```r
colnames(subjects) <- "Subjects"
colnames(labels) <- "Activities"
colnames(data) <- colNames[relevantFeatures,2]
```
  
## Join the subjects and activity labels onto the data set  

```r
data <- cbind(subjects, labels, data)
```
  
## 5. Average of each variable for each activity and subject created and written to new, independent data set  

```r
library(plyr)
tidyData <- aggregate(. ~ Subjects + Activities, data, mean)
tidyData <- tidyData[order(tidyData$Subjects, tidyData$Activities),]
write.table(tidyData, "tidyData.txt", row.name = FALSE)
```
