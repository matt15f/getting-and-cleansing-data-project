#Readme for run_analysis.r - Getting and Cleansing Data Course Project

This readme describes the getting and cleansing course project R script, run_analysis.r.

The first thing the script does is check to see if required packages are installed, if not it installs and loads them.  Then the package checks to see if a directory for storage has been created, if not it creates it, then the same is done for the dataset zip file.

The file is unzipped into 3 paths.  The 6 files are loaded into data frames, then the corresponding frames are combined, one frame for activites, one for subjects, one for features.
Feature frame column names are read in from features.txt, the names of the others are assigned manually.  Activity ID and name information is read in from activity_labels.txt

Then only columns containing the phrases 'std', 'mean', and 'Mean' are retained from the feature data set.

The three data sets are then combined and activity name is added to it.  Activity ID is removed.

The data set is then melted to create a normalized data set (narrow instead of wide).

The mean is then applied for each combination of subject, activity, and measurement.

The final data frame is then written to a file tidy_data.txt