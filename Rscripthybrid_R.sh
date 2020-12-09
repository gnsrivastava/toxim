#!/bin/bash

R --vanilla << "EOF"

library (randomForest)

set.seed(7)

load ("hybrid88.Rdata")


accuracies <-c()
data <- read.csv (file = "hybrid", sep = ",")
test = data[,2:1121]

print("prediction of classes in blindset model constructed using top 1021 FP and desc")
prediction = predict(rf_mtry88, test, type="prob")
table(prediction)
write.table (prediction, file = "Blind_pred_hybrid.txt", sep = "\t")

EOF
