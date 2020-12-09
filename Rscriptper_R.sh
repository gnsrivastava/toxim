#!/bin/bash

R --vanilla << "EOF"

library(pls)
library(MASS)

load ("per.Rdata")
test <- read.csv("permeability_top5", sep=',')
test1 <- test[2:6]

#fit and predict casual

pls.pred2<-predict(train1, test1, ncomp=4)
pls.eval<-data.frame(pred=pls.pred2[,1,1])
write.table (pls.eval, file = "Prediction_score.txt", sep = "\t")

EOF
