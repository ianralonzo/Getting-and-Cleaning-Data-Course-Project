##  Set working directory

  setwd("C:/UCI HAR Dataset")

##  Preparing to merge the training and test sets
##  to make one data set

  setwd("C:/UCI HAR Dataset/train")

##  Reading Training Data

  X_train <- read.table("X_train.txt")
  names(X_train) <- features$V2

  y_train <- read.table("y_train.txt")
  names(y_train )<- names(y_train) <- "labels"

  subject_train <- read.table("subject_train.txt")
  names(subject_train) <- "subjects"

##  Reading Test Data

  setwd("C:/UCI HAR Dataset/test")

  X_test <- read.table("X_test.txt")
  names(X_test) <- features$V2
  
  y_test <- read.table("y_test.txt")
  names(y_test) <- "labels"
  
  subject_test <- read.table("subject_test.txt")
  names(subject_test) <- "subjects"
  
##  Reading Features and Activity Label Data 
  
  setwd("C:/UCI HAR Dataset")
  features <- read.table("features.txt")["V2"]
  activity_labels <- read.table("activity_labels.txt")["V2"]
  
##  Find the columns corresponding to mean and std data 
  columns_of_means_and_stds <- grep("mean|std",features$V2) 

##  Extracting only the measurements on the mean 
##  and standard deviation for each measurement
 
  means_and_std_colnames <- colnames(X_test)[columns_of_means_and_stds]
  X_test_subset <- cbind(subject_test, y_test, subset(X_test, select=means_and_std_colnames))
  X_train_subset <- cbind(subject_train, y_train, subset(X_train, select= means_and_std_colnames))
  
##  Merges the training and the test sets to create one data set
  
  Xymerged <- rbind(X_test_subset, X_train_subset)
  
##  Creates a second, independent tidy data set with the average of each variable for each activity and each subject
  
  tidydata <- aggregate(Xymerged[,3:ncol(Xymerged)],list(Subject=Xymerged$subjects, Activity=Xymerged$labels), mean)
  tidydata <- tidydata[order(tidydata$Subject),]
  
##  Using descriptive activity names to name the activities in the data set
  
  tidydata$Activity <- activity_labels[tidydata$Activity,]
  write.table(tidydata, file="./tidydatafile.txt", sep="\t", row.names=FALSE)
