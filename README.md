## Getting and Cleaning Data Course Project

The R script `run_analysis.R` processes data from [UCI-HAR-Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
It does the following:

1. If no parament was given, download the data sets from the Internet; else use
   the first parament as the zip format file. Then unzip the file to the
   current directory.
2. Read in the data, and merges the training and the test sets to create one
   data set.
3. Extracts only the measurements on the mean and standard deviation for each
   measurement. That means '-mean()' or '-std()' should be in the field names.
4. Uses descriptive activity names to name the activities in the data set.
   After this step, '1' was converted to 'walking', '2' was converted to
   'walking_upstairs', and so on, according to the original code book.
5. Appropriately labels the data set with descriptive variable names. For
   example, 'tBodyAcc-mean()-X' was converted to 'tBodyAccMeanX'. This step
   generates `UCI-HAR-Dataset.tidy.txt`.
6. From the data set in step 4, creates a second, independent tidy data set.
   with the average of each variable for each activity and each subject. This
   step generates `UCI-HAR-Dataset.tidy.mean.txt`.
