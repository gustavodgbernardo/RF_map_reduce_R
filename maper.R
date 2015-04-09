args <- commandArgs(TRUE)
num.tree <- as.numeric(args[1])
num.vars <- as.numeric(args[2])

f <- file(description="stdin")
input <- read.csv(f,sep=",",header=F,stringsAsFactors=F,na.strings = "\\N")

for (i in 1:num.tree) {
  id.row <- sample(1:nrow(input),replace = T)
  set.seed(i)
  id.col <- c(sample(1:(ncol(input)-1),num.vars),ncol(input))
  input_train <-data.frame(model = i,vars = paste(id.col,collapse="|") ,tipo = "train",input[id.row,id.col])
  input_valid <-data.frame(model = i,vars =paste(id.col,collapse="|") ,tipo = "OOB", input[-id.row,id.col])    
  write.table(rbind(input_train,input_valid),stdout(),row.names=F,col.names=F,quote=F,sep=",")
}
