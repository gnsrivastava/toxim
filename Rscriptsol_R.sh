#!/bin/bash

R --vanilla << "EOF"

library(randomForest)

#import datasets from working directory
load ("sol.Rdata")
test <- read.csv("sol_top40", sep=',')
test1 <- test[2:41]

#####RANDOM FOREST STARTS HERE#########

#fit and predict casual

rf.pred2<-predict(fit, test1)
write.table(rf.pred2, file = "Prediction_score.txt", sep = "\t")

EOF
