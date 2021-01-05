#Rscript this file
#### Rscript normalize_new_chip.R GSE10846
name<-commandArgs(T); 
message(name);

gs<-as.matrix(read.delim(filename,sep=""),header=T,sep="\t")); ##for GSE33814##
gs[,1]->rn;
gs[,-1]->gs;
colnames(gs)->cn;
gs<-matrix(as.numeric(gs),byrow=F,nr=nrow(gs));
colnames(gs)<-cn;
rownames(gs)<-rn;
ind <- which(rownames(gs) != "--Control");
gs <- gs[ind,];

###input sample inf##
smp<-as.matrix(read.table(filename,sep=""),header=T));
gs[,smp[,1]]->gs;

###deal with probe
gn <- unique(rownames(gs));
gn_ind <- lapply(gn, function(x){which(rownames(gs)==x)});
names(gn_ind)<- gn;
l <- apply(gs, 1, function(x){length(which(is.na(x)))/length(x)});
l <- unlist(l);
gn_na <- lapply(gn_ind, function(x){tmp <- mean(l[x])});
gn_na <- unlist(gn_na);
gn_selected <- gn[which(gn_na < 0.8)];
gs <- gs[which(!is.na(match(rownames(gs), gn_selected))),];

##function
collapseGenes <- function(exprs.mat){
	gene.uni <- unique(rownames(exprs.mat));
	Ncol <- ncol(exprs.mat);
	gene.exprs <- lapply(gene.uni, function(gid){
			ind <- which(rownames(exprs.mat)==gid);
			if(length(ind)>1){
			return(apply(exprs.mat[ind,],2,function(x){median(x, na.rm=T)})); 
			}else{
			return(exprs.mat[ind,]);
			}
			})
	RowName <- gene.uni;
	ColName <- names(gene.exprs[[1]]);
	gene.exprs <- matrix(unlist(gene.exprs),byrow=T,ncol=Ncol);
	dimnames(gene.exprs) <- list(RowName,ColName);
	gene.exprs;
}
gs <- collapseGenes(gs);
# write.table(gs,file=paste(name,"_1_no_normalized.txt",sep=""),sep="\t",col.names=T,row.names=T,quote=F);
library(limma);
gs <- normalizeQuantiles(gs);
library(impute);
gs <- impute.knn(gs, k=10)[[1]];
m <- median(gs);
if(m > 16){
	gs <- log2(gs);
}

###output gene list for common gene_index####
#write.table(rownames(gs),file=filename,sep=""),sep="\t",col.names=F,row.names=F,quote=F);

###output chip file after normalization.txt for future use ####
write.table(gs,file="filename_normalization.txt",sep=""),sep="\t",col.names=T,row.names=T,quote=F);


###data preparation
chipdata1 = read.table("filename_normalization.txt",header=T,na.string=c("n","na"))
chipdata1 = chipdata1[chipdata1$normal_cancer == 1 & !is.na(chipdata1$state) & !is.na(chipdata1$survival),]
chipdata1 = subset(chipdata1,select = -normal_cancer)
save(chipdata1,file="chipdata1.rda")



