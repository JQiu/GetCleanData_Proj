## Introduction

In this project we process and clean data from strap-on sensors (accelerometers, gyroscopes, etc.) commonly found in emerging wearable tech. The original data is used for human activity recognition and was collected from a Samsung Galaxy S phone. We will be creating a tidy subset from some of the features of the feature vector.

## Loading and Stacking the Data

The data set comes in multiple parts. We first load in the training and test data. These include the sensor features (`X_train.txt, X_test.txt`), the output activity labels (`y_train.txt, y_test.txt`), and the subject labels (`subject_train.txt, subject_test.txt`).

These are then stacked into a super set, where activity and subject labels are stacked column wise (using `cbind()`) with respect to their training and test features. The training super set is then stacked on top (using `rbind()`) of the test super set to create one combined data set.

Camel casing have been chosen for variable names for readability.

## Extracting Relevant Variables

We will extract the mean and std of the sensor measurements. Reading the `features_info.txt` gives some more information and context with respect to the 561-feature vector. The linear body acceleration and angular velocity from the accelerometers and gyroscopes were used to determine the jerk signals. We will only extract the mean and std features of the straight tri-axial sensor measurements, the jerk measurements, and their magnitudes in both time and frequency domain.

There also appears to be mistakes in some of the features. We omit features that include `"BodyBody"` in their names. We subset the features by using regexp. We do this using `intersect()` on two `grep()` calls that finds occurrences of `"mean()" or "std()"` and `"BodyBody"`

## Setting Descriptive Activity Names

Next we map the activity labels from 1-6 to a more descriptive string. The mapping can be found in `activity_labels.txt`. A lookup table is created and `match()` is used to update the activities for each observation.

## Setting Appropriate Names for Variables

We clean up the variable names using regexp patterns and `gsub()`. Variables that correspond to time and frequency domain features are made more explicit by finding occurrence of `"f"` or `"t"` at the beginning of the variable name and substituting with `"Freq"` or `"Time"` respectively. Occurrences of `"mean()"` and `"std()"` are replaced with `"Mean"` and `"Std"`. Finally, occurrences of `"-"` are removed. This results in variables names that fit the camel casing convention and are descriptive of 

## Average Variables by Activity and Subject

The `plyr` package is used to aggregate the average of the variables by subject and activity. This is done by applying `ddply()` and results in a tidy data frame. We update the variable names by appending `"Average"` to each variable name before saving the data set with `write.table()`.