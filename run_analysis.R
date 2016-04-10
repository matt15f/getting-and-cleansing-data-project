#getting and cleansing data course assignment
#Matt Orr 2016

#first test if required packages have been installed,
#if they have not then install them
packages <- c("plyr","dplyr","reshape")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) 
      {
      install.packages(setdiff(packages, rownames(installed.packages())))  
      }

#load packages to the library
library("plyr","dplyr","reshape")

#create a directory to host the files if it does not exist
if (!dir.exists("D:/R/HAR")) {dir.create("D:/R/HAR")}

#create a URL to download the zip
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#check if the file exists download the zip file
if (!file.exists("D:/R/HAR/HARdataset.zip")) {download.file(url1,"D:/R/HAR/HARdataset.zip")}

#unzip the file
unzip(zipfile="D:/R/HAR/HARdataset.zip",exdir="D:/R/HAR")

#create 3 variables holding path names
basepath <- "D:/R/HAR/UCI HAR Dataset/"
testPath <- "D:/R/HAR/UCI HAR Dataset/test/"
trainPath <- "D:/R/HAR/UCI HAR Dataset/train/"

#read in each test and train file into a data frame
actTest <- read.table(file.path(testPath,"y_test.txt"))
actTrain <- read.table(file.path(trainPath,"y_train.txt"))

subTest <- read.table(file.path(testPath,"subject_test.txt"))
subTrain <- read.table(file.path(trainPath,"subject_train.txt"))

featTest <- read.table(file.path(testPath,"X_test.txt"))
featTrain <- read.table(file.path(trainPath,"X_train.txt"))

#combine the test and train data frames into all data frames
actAll <- rbind(actTest,actTrain)
subAll <- rbind(subTest,subTrain)
featAll <- rbind(featTest,featTrain)

#remove now unneccessary data frames
rm(actTest,actTrain,subTest,subTrain,featTest,featTrain)

#set the names of each data frame based on input files
featureNames <- read.table(file.path(basepath,"features.txt"))
names(featAll) <- featureNames$V2
names(actAll) <- ("ActivityID")
names(subAll) <- ("SubjectID")
actNames <- read.table(file.path(basepath,"activity_labels.txt"))
names(actNames) <- c("ActivityID","ActivityName")



#retain only columns containing the phrase std, mean, Mean
df <- featAll[, grepl("std|mean|Mean",names(featAll))]

#combine the 3 data frames into 1
df <- cbind(df,subAll,actAll)

#join the main data frame to the activity names frame
df <- left_join(x=df,y=actNames,by=c("ActivityID"="ActivityID"))

#assign variables to keep and eliminate ActivityID to create Tidy data
keepVars <- names(df) %in% c("ActivityID")
df <- df[!keepVars]

#melt the data set on subject and activity, creating a normalized data set
meltedDF <- melt(df,id=c("SubjectID","ActivityName"))

#summarize the data set on subject, activity, and variable, creating means
meanDF <- ddply(meltedDF,c("SubjectID","ActivityName","variable"),summarise,mean=mean(value))

#write final data set to output file tidy_data.txt
write.table(meanDF,file='d:/R/HAR/tidy_data.txt')
