#Download data
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/Admin/Documents/data.zip")
unzip(zipfile="data.zip")
activity_labels<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/activity_labels.txt")
features<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/features.txt")
label<-features$V2[grep("(mean|std)\\(\\)",features$V2)]
label<-gsub("[()]","",as.vector(label))
#Test set
subject_test<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/test/X_test.txt")[grep("(mean|std)\\(\\)",features$V2)]
y_test<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/test/y_test.txt")
test<-cbind(subject_test,y_test,X_test)
colnames(test)<-c("Subject_name","Activity",label)
#Train set
subject_train<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/train/X_train.txt")[grep("(mean|std)\\(\\)",features$V2)]
y_train<-read.table("C:/Users/Admin/Documents/UCI HAR Dataset/train/y_train.txt")
train<-cbind(subject_train,y_train,X_train)
colnames(train)<-c("Subject_name","Activity",label)
#Merge data
data<-rbind(test,train)
#Activity label
for (i in 1:6){
  data$Activity[data$Activity==activity_labels$V1[i]]<-as.character(activity_labels$V2[i])
}
#Create new tidy data
datamelt<-melt(data,id=c("Subject_name","Activity"))
newdata<-dcast(datamelt,Subject_name+Activity~variable,fun.aggregate=mean)
#Create text file
write.table(newdata,file="tidydata.txt",row.names = F)
