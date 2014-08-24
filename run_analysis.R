library(plyr)
# Train Files
trainXFile <-       "./UCI HAR Dataset/train/X_train.txt"
trainYFile <-       "./UCI HAR Dataset/train/y_train.txt"
trainSubjectFile <- "./UCI HAR Dataset/train/subject_train.txt"

#Test Files
testXFile <-        "./UCI HAR Dataset/test/X_test.txt"
tesYFile <-         "./UCI HAR Dataset/test/y_test.txt"
testSubjectFile  <- "./UCI HAR Dataset/test/subject_test.txt"

#Features File
featuresFile <-     "./UCI HAR Dataset/features.txt"
activityLabelsFile <- "./UCI HAR Dataset/activity_labels.txt"


#Activity
activityLabels <- read.table(activityLabelsFilePath, col.names =  c("activityid","activity"))

#Load train data
trainSetX <- read.table(trainXFile, sep = "", as.is = TRUE)
trainSetY <- read.table(trainYFile, col.names = c("activityid"))
trainSubject <- read.table(trainSubjectFile)
#trainSetY <- merge(trainSetY, activityLabels, sort = FALSE)

#Load test data
testSetX <- read.table(testXFile, sep = "", as.is = TRUE)
testSetY <- read.table(tesYFile, col.names = c("activityid"))
testSubject <- read.table(testSubjectFile)
#testSetY <- merge(testSetY, activityLabels, sort = FALSE)

featuresSet <- read.table(featuresFile, sep=" ")

trainSet <- cbind(trainSubject, trainSetY$activityid, trainSetX)
testSet <- cbind(testSubject, testSetY$activityid, testSetX)


names(trainSet) <- c("subject", "activityid", as.character(features$V2))
names(testSet)  <- c("subject", "activityid", as.character(features$V2))

#1.Merges the training and the test sets to create one data set.
combineSet <- rbind(trainSet, testSet)

#4.Appropriately labels the data set with descriptive variable names
names(combineSet) <- sub("\\(\\)", "", names(combineSet))
names(combineSet) <- gsub("-", "", names(combineSet))

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
combineSetMeanStd <- combineSet[, grep("subject|activity|mean|std", colnames(combineSet)) ] <- combineSet[, grep("subject|activity|mean|std", colnames(combineSet)) ]

#3.Uses descriptive activity names to name the activities in the data set
combineSetMeanStd <- merge(combineSetMeanStd, activityLabels)

#5. independent tidy data set with the average of each variable for each activity and each subject
combineAgg <- ddply(combineSetMeanStd, .(subject, activity), numcolwise(mean))
combineAgg <- combineAgg[order(combineAgg$subject,combineAgg$activityid),]

write.table(combineAgg, "tidy_data.txt", row.names = FALSE)

#View(combineSetMeanStd)
#View(combineAgg)
#View(trainSetX)
#View(trainSetY)
#View(trainSubject)
#View(testSetX)
#View(testSetY)
#View(testSubject)
#View(features)


