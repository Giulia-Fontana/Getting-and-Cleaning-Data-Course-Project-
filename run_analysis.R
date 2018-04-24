
# Use the dplyr library

library(dplyr)


# download the data from the zip file and unzio into my data directory

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")


# Read the Training data 

read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_values <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_activity <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")


# read Test data

test_values <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_activity <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read features

features <- read.table("./data/UCI HAR Dataset/features.txt", as.is = TRUE)

# Readactivity labels

activities = read.table("./data/UCI HAR Dataset/activity_labels.txt")

# Set the column names

colnames(activities) <- c("activity_Id", "activity_type")

# Merges the training and the test sets to create one data set

set_test <- cbind(test_subjects, test_values, test_activity)
set_train <- cbind(train_subjects, train_values, train_activity)
One_Dataset <- rbind(set_train, set_test)


# Set the column names

colnames(One_Dataset) <- c("subject", features[, 2], "activity")

# Subset the Dataset, using column vector and extract  mean and standard deviation for each measurement

column_vector <- grepl("subject|activity|mean|std", colnames(One_Dataset))
One_Dataset <- One_Dataset[, column_vector]


# Uses descriptive activity names to name the activities in the data set

One_Dataset$activity <- factor(One_Dataset$activity, levels = activities[, 1], labels = activities[, 2])

# Appropriately labels the data set with descriptive variable names

One_Dataset_column <- colnames(One_Dataset)
One_Dataset_column <- gsub("[\\(\\)-]", "", One_Dataset_column)
One_Dataset_column <- gsub("^f", "frequency", One_Dataset_column)
One_Dataset_column <- gsub("^t", "time", One_Dataset_column)
One_Dataset_column <- gsub("BodyBody", "Body", One_Dataset_column)
colnames(One_Dataset) <- One_Dataset_column


#Create independent tidy data set with the average of each variable for each activity and each subject

Second_Dataset <- aggregate(. ~subject + activity, One_Dataset, mean)
Second_Dataset <- Second_Dataset[order(Second_Dataset$subject, Second_Dataset$activity),]
write.table(Second_Dataset, "./data/tidy_dataset.txt", row.name=FALSE)
