#Upload dataset
data = read.csv('Boston_Housing.csv')
set.seed(123)

#Preprocessing: important phase where all the variables NA located on this model, will be removed
data <- na.omit(data)

#Standardization of the data: all the observations are taken into consideration; the mean of the columns is subtracted; then they are divided by the standard deviation of the column;
data_scaled <- cbind(scale(data[,1:13]),data[,14])

# TrainSet 80/20
size <- floor(0.8 *  nrow(data_scaled))

#All the normalized data is recovered in a random manner
train_ind <- sample(seq_len(nrow(data_scaled)), size = size)

train <- data_scaled[train_ind, ]
xtrain <- train[,1:13] #consider the 13 features
ytrain <- train[,14] 

# Create all the variables that haven't been selected
# Test values
test <- data_scaled[-train_ind,]
xtest <- test[,1:13]
ytest <- test[,14]

lambda.array <- seq(from = 0.01, to = 100, by = 0.01)

#Library that allows to utilise lasso
library(glmnet)
# alpha=1 if you want lasso regression
lassoFit <- glmnet(xtrain,ytrain, alpha=1, lambda=lambda.array)
summary(lassoFit)

# Lambda in realtion with the coefficients
plot(lassoFit, xvar = 'lambda', label=T)

#Goodness of fit
plot(lassoFit, xvar = 'dev', label = T)

# Predicted Values
y_predicted_lasso <- predict(lassoFit, s=min(lambda.array), newx = xtest)

# SSE(sum of squared error), SST (sum of squared total)
sst <- sum((ytest - mean(ytest))^2)
sse <- sum((y_predicted_lasso - ytest)^2)

#rsquare_lasso is the variance of our model
rsquare_lasso <- 1 - (sse/sst)

