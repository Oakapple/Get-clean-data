##########################################################################################################
#
## Coursera Getting and Cleaning Data
## Week 3 Course Project
## Colin Smart
## 23 July 2015
#
# runAnalysis.r File Description:
#
# This script will perform the following steps on the UCI HAR Dataset downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# Tidy up the workspace and set the working directory to point to the root directory for the UCI dataset.
# The WD is different depending on whether I'm working on a Mac or a PC.
#
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
##########################################################################################################


# Tidy up workspace
rm(list = ls())

#set working directory to the location where the UCI HAR Dataset was unzipped
choose.WD = function(x)
  return(if (x == "Windows")
    wd = "C:\\Users\\user\\Documents\\GitHub\\datasciencecoursera\\DataGathering"
    else if (x == "Darwin")
      wd = "/Users/Colin/Repository/datasciencecoursera/DataGathering")
setwd(choose.WD(Sys.info()["sysname"]))

# 1. Merge the training and the test sets to create one data set.

# 1.1 Read in the training data from files

#imports features.txt (the types of measurements and calculation)
features = read.table('./UCI HAR Dataset/features.txt', header = FALSE)

#imports activity_labels.txt (the activity type - standing, laying etc)
activityType = read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)

#imports subject_train.txt (who is doing the activity)
subjectTrain = read.table('./UCI HAR Dataset/train/subject_train.txt', header = FALSE)

#imports x_train.txt (all the measurements and calculations)
xTrain = read.table('./UCI HAR Dataset/train/x_train.txt', header = FALSE)

#imports y_train.txt (the activity for which the measurements were taken)
yTrain = read.table('./UCI HAR Dataset/train/y_train.txt', header = FALSE) 

# 1.2 Assign column names to the data imported above
colnames(activityType)  = c('activityId','activityType')  # The 6 types of activity
colnames(subjectTrain)  = "subjectId"                     # Who was undertaking the activity
colnames(xTrain)        = features[,2]                    # All the measurements taken
colnames(yTrain)        = "activityId"                    # What activity was undertaken

# 1.3 Create the final training set by merging yTrain, subjectTrain, and xTrain
# WARNING: assumes that the rows align as there is no index to link the rows

trainingData = cbind(yTrain,subjectTrain,xTrain)

# 1.4 Read in the test data from files
subjectTest = read.table('./UCI HAR Dataset/test/subject_test.txt', header = FALSE) #imports subject_test.txt
xTest       = read.table('./UCI HAR Dataset/test/x_test.txt', header = FALSE) #imports x_test.txt
yTest       = read.table('./UCI HAR Dataset/test/y_test.txt', header = FALSE) #imports y_test.txt

# 1.5 Assign column names to the data imported above
colnames(subjectTest) = "subjectId"   # Who was undertaking the activity
colnames(xTest)       = features[,2]  # All the measurements taken
colnames(yTest)       = "activityId"  # What activity was undertaken


# 1.6 Create the final test set by merging the xTest, yTest and subjectTest data
# WARNING: assumes that the rows align as there is no index to link the rows

testData = cbind(yTest,subjectTest,xTest)


# 1.7 Combine training and test data to create a final data set
finalData = rbind(trainingData,testData)


# 2. Extract only the measurements on the mean and standard deviation for each measurement.

# 2.1 Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns
colNames  = colnames(finalData)

# 2.2 Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector = (
  grepl("activity..",colNames) |
    grepl("subject..",colNames) |
    grepl("-mean..",colNames) &
    !grepl("-meanFreq..",colNames) &
    !grepl("mean..-",colNames) |
    grepl("-std..",colNames) & !grepl("-std()..-",colNames)
);

# 2.3 Subset finalData table based on the logicalVector to keep only desired columns
finalData = finalData[logicalVector == TRUE]

# 3. Use descriptive activity names to name the activities in the data set

# 3.1 Merge the finalData set with the activityType table to include descriptive activity names
# using the activityID to link the activities
finalData = merge(finalData,activityType,by = 'activityId',all.x = TRUE)

# 4. Appropriately label the data set with descriptive activity names

# 4.1 Updating the colNames vector to include the new column names after merge and drop those deselected
colNames  = colnames(finalData)

# 4.2 Cleaning up the variable names
# While colnames is now shorter the code provides a general cleanup that could be applied to the original list
for (i in 1:length(colNames))
{
  colNames[i] = gsub("\\()","",colNames[i]) # Remove brackets ()
  colNames[i] = gsub("-std$","StdDev",colNames[i]) # replace std at end of line with StdDev
  colNames[i] = gsub("-mean","Mean",colNames[i]) # replace -mean with Mean
  colNames[i] = gsub("^(t)","time",colNames[i]) # replace t at the start of the line with time
  colNames[i] = gsub("^(f)","freq",colNames[i]) # replace f at the start of the line with freq
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i]) # consistent capitalisation
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i]) # Single Body and consistent capitalisation
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i]) # consistent capitalisation
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i]) # expand contraction
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i]) # expand contraction and consistent capitalisation
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i]) # expand contraction
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i]) # expand contraction
}

# Reapplying the new descriptive column names to the finalData set
colnames(finalData) = colNames

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# 5.1 Create a new table, finalDataNoActivityType without the activityType column
# This is because the mean of an activityType (text) has no meaning an returns warnings
finalDataNoActivityType  = finalData[,names(finalData) != 'activityType']

# 5.2 Summarise the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData    = aggregate(
  finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by =
    list(
      activityId = finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId
    ),mean
)

# 5.3 Merging the tidyData with activityType to include descriptive actvity names (removed before step 5.2)
tidyData    = merge(tidyData,activityType,by = 'activityId',all.x = TRUE)

# 5.4 Export the tidyData set
write.table(tidyData, './tidyData.txt',row.names = FALSE,sep = '\t')
