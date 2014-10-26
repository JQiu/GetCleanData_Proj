Camel casing is used for variable naming.

## Loading the Original Data Set

`features` - holds the variable names of the feature vectors from `features.txt`

`XTrain` - sensor training features from `X_train.txt`

`yTrain` - activity output labels from `y_train.txt`

`subjectTrain` - subject label from `subject_train.txt`

`XTrain` - sensor training features from `X_train.txt`

`yTrain` - activity output labels from `y_train.txt`

`subjectTrain` - subject label from `subject_train.txt`

## Extracting Relevant Variables

The training features, activity output label, and subject label sets are stacked on top of their respective test sets using `rbind()`. The resulting sets are then column stacked using `cbind()`.

`XData` - horizontal stacked sensor features

`yData` - horizontal stacked activity output labels

`subjectData` - horizontal stacked subject labels

`totoalData` - vertical stacked complete data set with `XData`, `yData`, and `subjectData`


## Extracting the Mean and Std

The features that correspond to mean and std of the time / frequency domain sensor, jerk, and magnitude measurements are extracted using `intersect()` and `grep()`. Feature variable names that appear to be mistakes (`"BodyBody"`) are removed.

`match` - contain the matched indices from `features` by applying `"mean\\(\\)|std\\(\\)"` regexp pattern and finding the intersection with feature set that excludes `"BodyBody"` in name

`matchNames` - contain the matched names that correspond to indices in `match`, `Activity` and `Subject` are also added as column variables

`subsetData` - subset of `totalData` that correspond to the matched mean and std feature variables as in `matchNames`

## Setting Descriptive Activity Names

`lookup` - lookup table that match numeric values 1-6 to activity labels in `activity_labels.txt`

`activityLabels` - the assigned activity labels from `lookup` for `subsetData`

## Setting Appropriate Names for Variables

`matchNames` is updated here using regexp patterns to convert feature variable names to camel casing. The beginning `"f"` and `"t"` characters are converted to `"Freq"` and `"Time"` to make frequency and time domain delineation more explicit. `"-"` characters are removed. "`mean()`" and `"std()"` characters are converted to `"Mean"` and `"Std"` respectively.

## Average Variables by Activity and Subject

`tidyData` - the final tidy data set with the average of feature variables aggregated by subject and activity