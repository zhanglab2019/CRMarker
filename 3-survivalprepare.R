
library(survival)
genelist = read.table("genelist.txt",stringsAsFactors=F)
names(genelist) = c("gene","chipnum")
load("chipdata1.rda")


#calculate the coefficient and corresponding pvalue in the cox model
  chipdata = eval(parse(text = paste0("chipdata",chipnum)))
  survdata = data.frame(gene = rep(0,ncol(chipdata)-2), coef = rep(0,ncol(chipdata)-2), pvalue = rep(0,ncol(chipdata)-2))
  for (gene in 1:(ncol(chipdata)-2)) {
    fit = coxph(Surv(survival,state) ~ chipdata[,gene], data = chipdata)
    survdata$gene[gene] = names(chipdata)[gene]
    survdata$coef[gene] = summary(fit)$coefficients[1]
    survdata$pvalue[gene] = summary(fit)$coefficients[5]      
  }
  eval(parse(text = paste0("survdata",chipnum,"= survdata"))) 
  eval(parse(text = paste0("save(survdata",chipnum, ",file=\"survdata",chipnum,".rda\")")))


