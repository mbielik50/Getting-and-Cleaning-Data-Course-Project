# Install and load data.table and reshape2 package in order to retrieve data

install.packages("data.table")
library(data.table)

install.packages("reshape2")
library(reshape2)

# Read X_test & y_test data.
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")


# Read activity_labels - subsetting for second column only
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# Read features - subsetting for second column only
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Read subject_test
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Define which features are mean and standard deviation
extract_features <- grepl("mean|std", features)

#Add feature names to x_test data
names(x_test) = features

# Limit x_test data to only mean and standard deviation
x_test = x_test[,extract_features]

# Add activity labels to y_test
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")

# Add Suject lable to subject_test
names(subject_test) = "Subject"

# Merge subject_test, y_test, x_test
test_data <- cbind(subject_test, y_test, x_test)


#################


# Read X_train & y_train data.
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Read subject_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Add feature names to x_train data
names(x_train) = features

# Limit x_train data to only mean and standard deviation
x_train = x_train[,extract_features]

# Add activity labels to y_train
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")

# Add Suject lable to subject_train
names(subject_train) = "Subject"

# Merge subject_train, y_train, x_train
training_data <- cbind(subject_train, y_train, x_train)

# Merge test and train data
merged_data = rbind(test_data, training_data)


# Melt merged_data 
mergemelt = melt(merged_data, id = c("Subject", "Activity_ID", "Activity_Label"), measure.vars = setdiff(colnames(merged_data), c("Subject", "Activity_ID", "Activity_Label")))

# Apply mean function and create tidy_data set
tidy_data   = dcast(mergemelt, Subject + Activity_Label ~ variable, mean)

#Write tidy data file
write.table(tidy_data, file = "./tidy_data.txt")