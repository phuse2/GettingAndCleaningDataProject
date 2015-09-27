#Function that will be used to select only columns containing "mean" or "std"
findMeanOrStd <- function(x) {
      if(length((grep('mean',x))>0) || length(grep('std',x))>0) {
            TRUE
      } else {
            FALSE     
      }
}

#Sets working directory to correct folder (on my machine)
setwd("Coursera/Getting_and_cleaning_data/Course_Project")

##Paths to data files within my working directory
#test and train data features and labels
xtest.path <- 'UCI HAR Dataset/test/X_test.txt'
ytest.path <- 'UCI HAR Dataset/test/y_test.txt'
xtrain.path <- 'UCI HAR Dataset/train/X_train.txt'
ytrain.path <- 'UCI HAR Dataset/train/y_train.txt'

#feature names and label encodings
features.path <- 'UCI HAR Dataset/features.txt'
labels.path <- 'UCI HAR Dataset/activity_labels.txt'

#test subject markers
subs.test.path <- 'UCI HAR Dataset/test/subject_test.txt'
subs.train.path <- 'UCI HAR Dataset/train/subject_train.txt'

#Read in Data
xtest <- read.table(xtest.path)     #test data features
ytest <- read.table(ytest.path)     #test data labels
xtrain <- read.table(xtrain.path)   #training data features
ytrain <- read.table(ytrain.path)   #training data labels

features <- read.table(features.path)     #feature names
labels <- read.table(labels.path)         #label encodings

subs.test <- read.table(subs.test.path)    #subject codings test data
subs.train <- read.table(subs.train.path) #subject codings train data

#merge training and test sets
feature.data <- rbind(xtrain,xtest)
label.data <- rbind(ytrain,ytest)

#rename columns in feature.data to actual feature names
colnames(feature.data) <- features[,2]

#select columns from feature.data that only include 'mean' or 'std' data
#using function above
feature.indices <- sapply(colnames(feature.data),findMeanOrStd)
feature.data <- feature.data[,feature.indices]

#Sub in appropriate label names for codes
label.data[,1] <- apply(label.data, 1,function(x) labels[which(labels[,1]==x),2])

#combine label data and feature data in one data frame
feature.data <- cbind(label.data,feature.data)
colnames(feature.data)[1] <- "Activity"

#split data frame by activity and take column means for each activity
data.by.activity <- split(feature.data, feature.data$Activity)
column.means <- lapply(data.by.activity, function(x) colMeans(x[,2:ncol(x)]))

#recombine split data frames into one tidy data set and attach activities as a
#column (for printing with rownames = FALSE)
column.means <- data.frame(do.call("rbind",column.means))
column.means <- cbind(rownames(column.means),column.means)

#Output .txt file with activities as rows and measurement mean and std's 
#as colums
write.table(column.means,'measurement_means_by_activity.txt',row.names = FALSE)
