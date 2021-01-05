genelist = toupper(unlist(read.table("gene_list.txt",stringsAsFactors=F)))
load("survdata1.rda")
load("papergene.rda")
allgene = toupper(unlist(read.table("all_genes_list.txt")))


#for each gene, check in how many chips it is significant regarding survival time
commongene = data.frame(gene = Reduce(union,list(survdata1$gene)),score = 0,stringsAsFactors=F)
      eval(parse(text=paste0("tmpdata=survdata",chipnum)))
      for (i in 1:nrow(commongene)) {
            if (commongene$gene[i] %in% tmpdata$gene)
                  if(tmpdata$pvalue[tmpdata$gene == commongene$gene[i]] < 0.1)
                        commongene[i,2] = commongene[i,2] + 1   
      }


mean(commongene$score[commongene$gene %in% genelist])
mean(commongene$score[commongene$gene %in% papergene])
mean(commongene$score[commongene$gene %in% allgene])

sum(commongene$score[commongene$gene %in% genelist] != 0)/length(genelist)
sum(commongene$score[commongene$gene %in% papergene] != 0)/length(papergene)
sum(commongene$score[commongene$gene %in% allgene] != 0)/length(allgene)


commongenelist = intersect(commongene$gene,genelist)
commongene$score[commongene$gene %in% commongenelist]
mean(commongene$score[commongene$gene %in% commongenelist])
head(sort(commongene$score,decreasing=T))
mean(commongene$score)
sum(commongene$score[commongene$gene %in% commongenelist] != 0)/length(commongenelist)
sum(commongene$score != 0)/nrow(commongene)

