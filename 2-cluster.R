
library(survival)
multigene = toupper(unlist(read.table("gene_list.txt",stringsAsFactors=F)))
load("chipdata1.rda")
load("papergene.rda")


pvalue = NULL

      chipdata = eval(parse(text = paste0("chipdata",chipnum)))
      intergene = intersect(multigene,names(chipdata))
      cludata = chipdata[,names(chipdata) %in% intergene]
#cluster here, make 2 clusters
      clu = kmeans(cludata,2,iter.max=100)$cluster
#statistical test of the difference of survival plot based on the 2 clusters
      sdf = survdiff(Surv(survival,state)~clu,data=chipdata)   
#pvalue of the statistical test
      pvalue = c(pvalue, 1 - pchisq(sdf$chisq, length(sdf$n) - 1)) 




paperpvalue = NULL
      chipdata = eval(parse(text = paste0("chipdata",chipnum)))
      intergene = intersect(papergene,names(chipdata))
      cludata = chipdata[,names(chipdata) %in% intergene]
      clu = kmeans(cludata,2,iter.max=100)$cluster
      sdf = survdiff(Surv(survival,state)~clu,data=chipdata)   
      paperpvalue = c(paperpvalue, 1 - pchisq(sdf$chisq, length(sdf$n) - 1)) 
    














