#!/usr/bin/env Rscript

# unzip zip file
if(!dir.exists('UCI HAR Dataset/')) {
    args=commandArgs(trailingOnly = TRUE)
    zip.name = 'UCI-HAR-Dataset.zip'

    if(length(args) == 0) {
        dataset.url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataset.url, zip.name)
    } else {
        stopifnot(file.exists(args[1]))
        zip.name = args[1]
    }

    unzip(zip.name)
}

library(dplyr)

## Merges the training and the test sets to create one data set
train <- read.table('UCI HAR Dataset/train/X_train.txt')
train.subject <- readLines('UCI HAR Dataset/train/subject_train.txt')
train.label <- readLines('UCI HAR Dataset/train/y_train.txt')

test <- read.table('UCI HAR Dataset/test/X_test.txt')
test.subject <- readLines('UCI HAR Dataset/test/subject_test.txt')
test.label <- readLines('UCI HAR Dataset/test/y_test.txt')

data = rbind(train, test)
data.subject = c(train.subject, test.subject)
data.label = c(train.label, test.label)

## Extracts only the measurements on the mean and standard deviation
feature.name = read.table('UCI HAR Dataset/features.txt')[,2]
feature.subset.id = grep('-(mean|std)\\(\\)', feature.name)
data.clean = cbind(data.subject, data.label, data[, feature.subset.id])
names(data.clean) = c('subject', 'activity', feature.name[feature.subset.id])

## Uses descriptive activity names to name the activities in the data set
label.name = read.table('UCI HAR Dataset/activity_labels.txt')[,2]
data.clean$activity = factor(data.clean$activity, label = tolower(label.name))

## Appropriately labels the data set with descriptive variable names
feature.subset.name = gsub('[-()]', '', feature.name[feature.subset.id])
feature.subset.name = gsub('mean', 'Mean', feature.subset.name)
feature.subset.name = gsub('std', 'Std', feature.subset.name)

colnames(data.clean)[-c(1,2)] = feature.subset.name
write.csv(data.clean, "tidy.csv", row.names = FALSE)

## Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject.
data.clean.mean = aggregate(.~subject+activity, data=data.clean, mean)
data.clean.mean = arrange(data.clean.mean, as.numeric(as.character(subject)), activity)
data.clean.mean[,3:ncol(data.clean.mean)] = signif(data.clean.mean[,3:ncol(data.clean.mean)], digits=7)
write.csv(data.clean.mean, "tidy.mean.csv", row.names = FALSE)

## Last step. According to the instruction, save the data set as a txt file
## created with write.table() using row.name=FALSE. But this txt file won't be
## uploaded to github.
write.table(data.clean.mean, "tidy.mean.txt", row.names = FALSE)
