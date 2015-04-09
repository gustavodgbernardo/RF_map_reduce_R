suppressPackageStartupMessages(library(data.table))
f <- file(description="stdin")
input <- read.csv(f,sep=",",header=F,stringsAsFactors=F,na.strings = "\\N")

rf_selection <- data.frame(data.table(input)[,mean(V2),by=V1])
id <- sort(rf_selection[,2],index.return=T,decreasing = T)$ix
write.table(rf_selection[id,],stdout(),row.names=F,col.names=F,quote=F,sep=",")
