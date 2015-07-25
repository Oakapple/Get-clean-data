# Codebook for Getting and Cleaning Data Course Project

As part of creating a tidy data set for the course project, this code book is
provided.  It includes:

* _Codebook_: A description of each of the variables, including units
* _Summary choices_: Information about the summary choices
* _Study Design_: Information about the experimental study design

## Codebook

The following datasets are used:
* features.txt (the types of measurements and calculation)
* activity_labels.txt (the activity type - standing, laying etc)

For both test and training datasets
* subject_train.txt and subject_test.txt (who is doing the activity)
* x_train.txt and x_test.txt (all the measurements and calculations)
* y_train.txt and y_test.txt (the activity for which the measurements were taken)

The datasets for train and test are composed as shown below:

|activityID|subjectID|measurements from features.txt|
|----------|---------|-------|
|yTest|subjectTest|xTest|

In addition, two variables were integrated with the data set. A descriptive factor for the activity observed during each measurement, and the subject participating in that activity.

* activity
* subject

The textual label for the activity is added after the two tables are combined.

|training data|
|-------|
|**test data**|

This dataset includes the mean and standard deviation variables from the
HAR study. These were selected by including all variables whose name in the original dataset matched one of the patterns below. 

* activity..
* subject..
* -mean.. and not (-meanFreq.. or mean..-)
* -std.. and not -std()..-

To expand the range of vairables to take through to the next stage, this rule can be altered.

Of the original 561 variables, the following 18 met the critera for inclusion (along with activity ID and Type, and the subjectID):

* activityId
* subjectId
* tBodyAccMag-mean()
* tBodyAccMag-std()
* tGravityAccMag-mean()
* tGravityAccMag-std()
* tBodyAccJerkMag-mean()
* tBodyAccJerkMag-std()
* tBodyGyroMag-mean()
* tBodyGyroMag-std()
* tBodyGyroJerkMag-mean()
* tBodyGyroJerkMag-std()
* fBodyAccMag-mean()
* fBodyAccMag-std()
* fBodyBodyAccJerkMag-mean()
* fBodyBodyAccJerkMag-std()
* fBodyBodyGyroMag-mean()
* fBodyBodyGyroMag-std()
* fBodyBodyGyroJerkMag-mean()
* fBodyBodyGyroJerkMag-std()
* activityType

This is a selection of variables from the HAR data, which are described in detail
in the file _features\_info.txt_ in the data set.  Quoting from that file:

> The features selected for this database come from the accelerometer and
> gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals
> (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then
> they were filtered using a median filter and a 3rd order low pass Butterworth
> filter with a corner frequency of 20 Hz to remove noise. Similarly, the
> acceleration signal was then separated into body and gravity acceleration
> signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth
> filter with a corner frequency of 0.3 Hz. 
> 
> Subsequently, the body linear acceleration and angular velocity were derived in
> time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the
> magnitude of these three-dimensional signals were calculated using the
> Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag,
> tBodyGyroJerkMag). 
> 
> Finally a Fast Fourier Transform (FFT) was applied to some of these signals
> producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag,
> fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain
> signals). 
> 
> These signals were used to estimate variables of the feature vector for each
> pattern:  '-XYZ' is used to denote 3-axial signals in the X, Y and Z
> directions.
> 
> tBodyAcc-XYZ
> tGravityAcc-XYZ
> tBodyAccJerk-XYZ
> tBodyGyro-XYZ
> tBodyGyroJerk-XYZ
> tBodyAccMag
> tGravityAccMag
> tBodyAccJerkMag
> tBodyGyroMag
> tBodyGyroJerkMag
> fBodyAcc-XYZ
> fBodyAccJerk-XYZ
> fBodyGyro-XYZ
> fBodyAccMag
> fBodyAccJerkMag
> fBodyGyroMag
> fBodyGyroJerkMag
> 
> The set of variables that were estimated from these signals are: 
> 
> mean(): Mean value
> std(): Standard deviation

## Summary choices

The summary made in creating this dataset based on the HAR data were dictated
primarily by the instructions of the assignment.  In particular:

> 5\. Creates a second, independent tidy data set with the average of each
>    variable for each activity and each subject.

So, each of the 18 variables above from the HAR data is averaged (mean) across
all overvations for each subject-activity pair, resulting in a total
of 180 observations (30 subjects x 6 activities).

## Study Design

This dataset merely cleans and aggregates data from the HAR project, and as such has no tudy design of its own.  The study design for that project is available at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
