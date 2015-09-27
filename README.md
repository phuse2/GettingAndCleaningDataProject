##This R file reads in the training and test datasets from the UCI HAR Database, cleans them, and performs analysis
###The database consists of test and training sets for the features and labels, as well as other files which explain the encoding of the labels as well as include subject data
###The features are a set of measurements performed on each subject in a different physical state, and each column includes a different statistical measure (eg. mean, median, standard deviation...) for each performend measurement
###The labels are descriptions of the activity performed during each measurement

##Process:
###The raw features are read into R for the test and training sets and merged
###The encoded label vectors are read in for the test and training sets and merged
###The feature matrix and label vector are merged to create a single dataset
###Using the provided lookup table, the encoded labels are converted to meaningful names eg.RUNNING, SITTING
###The feature matrix is filtered to include only those features for "mean" and "standard deviation", and not other statistical variables on each measurement
###A second dataset is created that includes the average value of each feature across each activity label (eg. the average of feature vector 1 for the activity RUNNING)
###This new dataset is written to a .txt file