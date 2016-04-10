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
library("plyr")
library("dplyr")
library("reshape")

#create a URL to download the zip
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#check if the file exists download the zip file
if (!file.exists("HARDataset.zip")) {download.file(url1,"HARDataset.zip")}

#unzip the file
unzip(zipfile="HARDataset.zip")


#read in each test and train file into a data frame
actTest <- read.table("/UCI HAR Dataset/test/y_test.txt")
actTrain <- read.table("/UCI HAR Dataset/train/y_train.txt")

subTest <- read.table("/UCI HAR Dataset/test/subject_test.txt")
subTrain <- read.table("/UCI HAR Dataset/train/subject_train.txt")

featTest <- read.table("/UCI HAR Dataset/test/X_test.txt")
featTrain <- read.table("/UCI HAR Dataset/train/X_train.txt")

#combine the test and train data frames into all data frames
actAll <- rbind(actTest,actTrain)
subAll <- rbind(subTest,subTrain)
featAll <- rbind(featTest,featTrain)

#remove now unneccessary data frames
rm(actTest,actTrain,subTest,subTrain,featTest,featTrain)

#set the names of each data frame based on input files
featureNames <- read.table("/UCI HAR Dataset/features.txt")
names(featAll) <- featureNames$V2
names(actAll) <- ("ActivityID")
names(subAll) <- ("SubjectID")
actNames <- read.table("/UCI HAR Dataset/activity_labels.txt")
names(actNames) <- c("ActivityID","ActivityName")



#retain only columns containing the phrase std, mean, Mean
df <- featAll[, grepl("std|mean|Mean",names(featAll))]

#combine the 3 data frames into 1
df <- cbind(df,subAll,actAll)

#join the main data frame to the activity names frame
df <- join(x=df,y=actNames,by="ActivityID",type="left")

#assign variables to keep and eliminate ActivityID to create Tidy data
keepVars <- names(df) %in% c("ActivityID")
df <- df[!keepVars]

#melt the data set on subject and activity, creating a normalized data set
meltedDF <- melt(df,id=c("SubjectID","ActivityName"))

#summarize the data set on subject, activity, and variable, creating means
meanDF <- ddply(meltedDF,c("SubjectID","ActivityName","variable"),summarise,mean=mean(value))

#write final data set to output file tidy_data.txt
write.table(meanDF,file='tidy_data.txt',row.names=FALSE)
