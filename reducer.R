args <- commandArgs(TRUE)
mincriterion  <- as.numeric(args[1])
minbucket  <- as.numeric(args[2])
maxdepth  <- as.numeric(args[3])

suppressPackageStartupMessages(library(ROCR))
suppressPackageStartupMessages(library(party))

gini <- function(equation){
  tree <- ctree(as.formula(equation), data=train,controls = ctree_control(mincriterion = mincriterion,minbucket= minbucket,maxdepth= maxdepth))
  obs <- OOB[,ncol(OOB)]
  prev <- predict(tree,newdata=OOB,type="response")
  pred = prediction(prev, obs)      
  perf2 <- performance(pred,"auc")
  GINI <- 2*attr(perf2,'y.values')[[1]]-1
  return(GINI)
}

f <- file(description="stdin")
input <- try(read.csv(f,sep=",",header=F,stringsAsFactors=F,na.strings = "\\N"),silent =T)
if (attr(input,"class") != "try-error"){
  for (i in (unique(input[,1]))){
    id.train <- which((input[,1]==i) & (input[,3]=="train"))
    id.valid <- which((input[,1]==i) & (input[,3]=="OOB"))
    vars <- unlist(strsplit(unique(input[id.train,2]),"\\|"))
    train <-  input[id.train,4:ncol(input)]  
    names(train) <- c(paste0("V",vars[-ncol(train)]),"bad")
    OOB <- input[id.valid,4:ncol(input)]
    names(OOB) <- c(paste0("V",vars[-ncol(OOB)]),"bad")
    vars.model <- paste0("V",vars[-ncol(train)])
    comp.total <- paste0("bad~",paste(vars.model,collapse="+"))
    comb <- sapply(1:length(vars.model),function(x) paste0("bad~",paste(vars.model[-x],collapse="+")))
    gini.total <- gini(comp.total)
    gini.parcial <-sapply(comb,gini)
    compare <- data.frame(vars.model,gini.total,gini.parcial,row.names = NULL)
    compare$diff <-  compare$gini.total - compare$gini.parcial
    write.table(compare[,c(1,4)],stdout(),row.names=F,col.names=F,quote=F,sep=",")
  }
}





