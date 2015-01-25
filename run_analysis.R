
#initial setup
setwd("c:\\Users\\Hussam\\Documents\\courses\\Getting_and_Cleaning_Data\\project\\UCI HAR Dataset\\")
library(dplyr)


#loading datasets (training and test)
training <- read.table("./train/X_train.txt", strip.white=TRUE)
test <- read.table("./test/X_test.txt", strip.white=TRUE)

#merging the training and the test sets to create one data set
total <- rbind(training, test)

#reading the features data set
features <- read.table("features.txt")


#find the indexes of mean and standard deviation columns in features data set
indexes <- grep("mean|std", features[,2], ignore.case=TRUE)

#select only these columns as specified by indexes variable from our main data set
#and create a new data set with these only columns
mean_std_total <- total[,indexes]

#get columns names from features based on mean and std column
columns_names <- features[indexes,2]

#apply features as column names in our data set
colnames(mean_std_total) <- as.vector(columns_names)

#loading activity train and test to add this new column to our dataset
activity_train <- read.table("./train/y_train.txt", strip.white=TRUE)
activity_test <- read.table("./test/y_test.txt", strip.white=TRUE)
activity <- rbind(activity_train, activity_test)
colnames(activity) <- "activity"
mean_std_total <- cbind(mean_std_total, activity)

#naming the activities in the dataset based on the "activity_labels.txt" file 
#included in the dataset
mean_std_total$activity[mean_std_total$activity==1] <- 'WALKING'
mean_std_total$activity[mean_std_total$activity==2] <- 'WALKING_UPSTAIRS'
mean_std_total$activity[mean_std_total$activity==3] <- 'WALKING_DOWNSTAIRS'
mean_std_total$activity[mean_std_total$activity==4] <- 'SITTING'
mean_std_total$activity[mean_std_total$activity==5] <- 'STANDING'
mean_std_total$activity[mean_std_total$activity==6] <- 'LAYING'

#loading subject data in order to bind it to our dataset to use to calculate the
#average
subject_train <- read.table("./train/subject_train.txt", strip.white=TRUE)
subject_test <- read.table("./test/subject_test.txt", strip.white=TRUE)
subject <- rbind(subject_train, subject_test)
colnames(subject) <- "subject"

#add the subject data as a new column to our dataset
mean_std_total <- cbind(mean_std_total, subject)

#calculating the average of each variable for each activity and each subject
avg_activity_subject <- aggregate(. ~ subject + activity, mean_std_total, mean)

#writing the tidy data set of the average
write.table(avg_activity_subject, file="tidy.txt", row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)






