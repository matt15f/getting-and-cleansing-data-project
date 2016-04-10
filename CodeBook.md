#run_analys.r Code Book - Getting and cleansing data course assignment.

This codebook documents the final dataset that run_analysis.r creates.  The resulting dataset has 4 variables, it is a narrow tidy dataset.  

##Variables
* 'SubjectID' - this is the identifier of the test subject
* 'ActivityName' - This is the name of the activity that the subject was doing while measurements were taken
* 'measurement' - This is the name of the measurement taken
* 'mean' - this is the mean value of the given measurement recorded for subject performing the activity.

Comments from the script describing the workflow have been copied into this codebook.

first test if required packages have been installed,
if they have not then install them

load packages to the library

create a directory to host the files if it does not exist

create a URL to download the zip

check if the file exists download the zip file

unzip the file

create 3 variables holding path names

read in each test and train file into a data frame

combine the test and train data frames into all data frames

remove now unneccessary data frames

set the names of each data frame based on input files

retain only columns containing the phrase std, mean, Mean

combine the 3 data frames into 1

join the main data frame to the activity names frame

assign variables to keep and eliminate ActivityID to create Tidy data

melt the data set on subject and activity, creating a normalized data set

summarize the data set on subject, activity, and variable, creating means

write final data set to output file tidy_data.txt