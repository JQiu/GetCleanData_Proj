library(stringr)
library(plyr)

## Read in the original data sets
## Feature names
features = read.table("./UCI HAR Dataset/features.txt", colClasses = c("numeric", "character"))

## Training data, labels, and subjects
XTrain = read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain = read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain = read.table("./UCI HAR Dataset/train/subject_train.txt")

## Test data, labels, and subjects
XTest = read.table("./UCI HAR Dataset/test/X_test.txt")
yTest = read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest = read.table("./UCI HAR Dataset/test/subject_test.txt")

## 1. Merge the training and test sets 
## Stack the data frames
XData <- rbind(XTrain, XTest)
yData <- rbind(yTrain, yTest)
subjectData <- rbind(subjectTrain, subjectTest)

totalData <- cbind(cbind(XData, yData), subjectData)

## 2. Extract the mean and std measurements
## Find mean and std for the time / freq signals and their magnitudes
## Omit the BodyBody measurements which are not in the features_info and are mistakes (see forum)
match <- intersect(grep("mean\\(\\)|std\\(\\)", features[,2]), grep("BodyBody", features[,2], invert=T))
matchNames <- features[match,2]

## Extract the subset
## Append the activity and subject indices - last 2 columns
match <- c(match, ncol(totalData)-1)
match <- c(match, ncol(totalData))

matchNames <- c(matchNames, "Activity")
matchNames <- c(matchNames, "Subject")

subsetData <- totalData[, match]
names(subsetData) <- matchNames

## 3. Set descriptive activity names
## Create lookup table
lookup = data.frame(Activity = c(1, 2, 3, 4, 5, 6), 
                    Label = c("walking", "walkingUpstairs", "walkingDownstairs", "sitting", "standing", "laying"))

## Set the labels to the Activity variable
activityLabels <- lookup[match(subsetData$Activity, lookup$Activity), 2]
subsetData$Activity <- activityLabels

## 4. Set appropriate names for the variables
## Use camel casing for readibility
## Set first character f -> Freq, t -> Time. Denoting time or freq signal
matchNames <- gsub("^f", "Freq", matchNames)
matchNames <- gsub("^t", "Time", matchNames)

## Set mean -> Mean and std -> Std and remove () chars
matchNames <- gsub("mean\\(\\)", "Mean", matchNames)
matchNames <- gsub("std\\(\\)", "Std", matchNames)

## Remove - chars
matchNames <- gsub("-", "", matchNames)

## Update variable names
names(subsetData) <- matchNames

## 5. Average each varaible for each acvity and subject
tidyData <- ddply(subsetData, .(Activity, Subject), numcolwise(mean))

## Update the variable names and order them as in tidyData
avgNames <- str_c(matchNames[1:(length(matchNames)-2)], "Average")
tidyNames <- c("Activity", "Subject", avgNames)

names(tidyData) <- tidyNames

## Write out data frame for submission
write.table(tidyData, file="pa.txt", row.name=FALSE)