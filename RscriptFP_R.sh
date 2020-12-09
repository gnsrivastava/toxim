#!/bin/bash

R --vanilla << "EOF"

load("fp88.Rdata")

library(randomForest)


accuracies <-c()
data <- read.csv (file = "fingerprints_top10per", sep = ",")
test = data[,2:1021]

print("prediction of classes in blindset model constructed using top 10per FP")
prediction = predict(rf_mtry88, test, type="prob")
table(prediction)
write.table (prediction, file = "Blind_pred_FP.txt", sep = "\t")

EOF
