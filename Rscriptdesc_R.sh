#!/bin/bash

R --vanilla << "EOF"

load ("desc5.Rdata")

library (randomForest)


accuracies <-c()
data <- read.csv (file = "desc_top100", sep = ",")
test = data[,2:101]

accuracies <-c()
print("prediction of classes in blindset model constructed using top 100 descriptors")
prediction = predict(rf_mtry5, test, type="prob")
table(prediction)
write.table (prediction, file = "Blind_pred_desc.txt", sep = "\t")

EOF
