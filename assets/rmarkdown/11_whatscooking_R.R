#This is a plain R file you can copy or run in R
#Adopted from
#https://www.kaggle.com/amhchiu/whats-cooking/bag-of-ingredients-in-r/code 


#install.packages("rpart.plot", repos="http://cran.rstudio.com/")
#install.packages("jsonlite", repos="http://cran.rstudio.com/")
#install.packages("dplyr", repos="http://cran.rstudio.com/")
#install.packages("tm", repos="http://cran.rstudio.com/")
#install.packages("caret", repos="http://cran.rstudio.com/")
#install.packages("ggplot2", repos="http://cran.rstudio.com/")
#install.packages('randomForest', repos="http://cran.rstudio.com/")
install.packages('xgboost', repos="http://cran.rstudio.com/")
library(randomForest)
library(jsonlite)
library(dplyr)
library(plyr)
library(ggplot2)
library(tm) # For NLP; creating bag-of-words
library(caret)
library(rpart)
library(rpart.plot)
library(xgboost)
setwd("~/MGMT6963-2015-master/data/whatscooking")
test <- fromJSON("whatscookingtest.json", flatten = TRUE)
train <- fromJSON("whatscookingtrain.json", flatten = TRUE)

#Let's take a look at the data by type.   
ggplot(data = train, aes(x = cuisine)) + 
  geom_histogram() +
  labs(title = "Cuisines", x = "Cuisine", y = "Number of Recipes")

#We also know how to aggregate to see this. 
table(train$cuisine)

#Let's create the Niave Model
test$cuisine ="italian"

#Create Dataframe For Submission
submission<-test[,c('id','cuisine')]

#Naive Model (This is our benchmark. 0.19268 Accuracy and 693 place)  Boom. we just beat 17 people. 
write.csv(submission, "1_naivemodel.csv", row.names=FALSE)

#Now let's start the process of creating a corpus
MyCorpus <- Corpus(VectorSource(train$ingredients))
MyCorpus2 <- Corpus(VectorSource(test$ingredients))

#Observe the corpus before and after this. 
MyCorpus <- tm_map(MyCorpus, stemDocument, lazy=TRUE)
MyCorpus2 <- tm_map(MyCorpus2, stemDocument, lazy=TRUE)

#This creates a Document Term Matrix. 
ingredientsDTM <- DocumentTermMatrix(MyCorpus)
ingredientsDTM2 <- DocumentTermMatrix(MyCorpus2)

#This removes most of the terms.  We are just going to start with a few. 
sparse <- removeSparseTerms(ingredientsDTM, 0.98)
sparse2 <- removeSparseTerms(ingredientsDTM2, 0.98)

#This goes through the process of changing out term document matrix to a data frame we can use for marketing
ingredientsDTM <- as.data.frame(as.matrix(sparse))
ingredientsDTM2 <- as.data.frame(as.matrix(sparse2))

#Adding this bit of a feature. 
ingredientsDTM$ingredients_count  <- rowSums(ingredientsDTM)
ingredientsDTM$ingredients_count2  <- rowSums(ingredientsDTM2)

#We have a problem though....We only want to use terms 
trainColumns<-names(ingredientsDTM)
testColumns<-names(ingredientsDTM2)

intersect<-intersect(trainColumns,testColumns)

#This removes about 10 columns that aren't in both. 
ingredientsDTM<- ingredientsDTM[,c(intersect)]
ingredientsDTM2<- ingredientsDTM2[,c(intersect)]


ingredientsDTM$cuisine <- as.factor(train$cuisine)

#This is a descision tree model.
set.seed(9347)
cartModelFit <- rpart(cuisine ~ ., data = ingredientsDTM, method = "class")
prp(cartModelFit)

#This generates the class prediction.  
cartPredict<-predict(cartModelFit, newdata = ingredientsDTM2, type = "class")

str(ingredientsDTM)

#This creates our final submission data frame. 
submit2 <- data.frame(id = test$id, cuisine = cartPredict)

#Tree  Now the accuracy is 0.40115.  We have improved!
write.csv(submit2, file = "2_rpart.csv", row.names = FALSE)


#It seems that random forests package doesn't work with "-" in the column name. You can try yourself.
names(ingredientsDTM) <- gsub("-", "", names(ingredientsDTM))
names(ingredientsDTM2) <- gsub("-", "", names(ingredientsDTM2))

#Boom with 1 tree we improved to an accuracy of  0.54354
forestmodel <- randomForest(cuisine ~ ., data=ingredientsDTM, importance=TRUE, ntree=1)
forestPredict<-predict(forestmodel, newdata = ingredientsDTM2, type = "class")

#Create Submssion Data Frame
submit3 <- data.frame(id = test$id, cuisine = forestPredict)
write.csv(submit3, file = "3_forest.csv", row.names = FALSE)

#Double boom with 100 trees we move up even further to  0.74387
forestmodel <- randomForest(cuisine ~ ., data=ingredientsDTM, importance=TRUE, ntree=1000)
forestPredict<-predict(forestmodel, newdata = ingredientsDTM2, type = "class")

#Create Submssion Data Frame
submit4 <- data.frame(id = test$id, cuisine = forestPredict)
write.csv(submit4, file = "4_forest.csv", row.names = FALSE)

#Let's try some more feature engineerning. 
ingredientsDTM$ingredients_count  <- rowSums(ingredientsDTM)

#Another strategy could be to create a corpus from both the training and the test set. 
# From https://www.kaggle.com/yilihome/whats-cooking/simple-xgboost-in-r/code
MyCorpus3  <- c(Corpus(VectorSource(train$ingredients)), Corpus(VectorSource(test$ingredients)))

#This creates a Document Term Matrix. 
ingredientsDTM3 <- DocumentTermMatrix(MyCorpus3)

ingredientsDTM3 <- removeSparseTerms(c_ingredientsDTM, 1-3/nrow(c_ingredientsDTM))


