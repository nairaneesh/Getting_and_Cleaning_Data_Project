
# This  script is to process the data and prepare a tidy dataset for Week4 assignment.

library(reshape)
library(reshape2)

# Read Activity Labels

aLabels <- read.table("activity_labels.txt",stringsAsFactors=FALSE)

# Read features

features <- read.table("features.txt",stringsAsFactors=FALSE)

#Get mean and std positions

requiredFeaturespos <- grep(".*mean.*|.*std.*", features$V2) 

#Preparing feature names

requiredFeaturesLabels <- features[requiredFeaturespos,]$V2
requiredFeaturesLabels <- gsub('[-()]', '', requiredFeaturesLabels)

# Loading Traning Data

trainingData <- read.table("train/X_train.txt")[requiredFeaturespos]
trainingActivities <- read.table("train/Y_train.txt")
trainingSubjects <- read.table("train/subject_train.txt")

#combine all training data
trainingData <- cbind(trainingSubjects, trainingActivities, trainingData)

#Loading Test data

testData <- read.table("test/X_test.txt")[requiredFeaturespos]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")

#Combine all test data
testData <- cbind(testSubjects, testActivities, testData)

#combine test and train data
combinedData <- rbind(trainingData, testData)
colnames(combinedData) <- c("subject", "activity", requiredFeaturesLabels)

#Turn variables into factors
combinedData$activity <- factor(combinedData$activity, levels = aLabels$V1, labels = aLabels$V2 )
combinedData$subject <- as.factor(combinedData$subject)

#Melt data

meltedData <- melt(combinedData,id=c("subject","activity"))
meltedMean <- dcast(meltedData,subject+activity ~ variable,mean)

#Write tidy dataset

write.table(meltedMean,"tidydata.dat",row.names=FALSE,quote=FALSE)






