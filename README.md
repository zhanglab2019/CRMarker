# CRMarker
CRMarker is a searchable and predictable database of cancer markers.

##The program of transcriptome data analysis containing prognostic data is shown below. 
Run in numbered order, you can use them to obtain two p-values (log-rank test and Cox model)
for each gene of each cancer data. If all of them are less than 0.05, we consider this gene 
as a prognostic gene.

1-normalize_new_chip.R;
2-cluster.R;
3-survivalprepare.R;
4-survivalanalysis.R;

##On the basis of preparing the multiple network interaction data mentioned in this database
( http://crmarker.hnnu.edu.cn/), based on the principle of "guilt-by-association", if you run the data 
according to the  following two programs, you can predict the potential cancer biomarkers.
We believe that the higher the frequency of the predicted marker, the higher the credibility.

5-predict_dia_marker.pl;
6-predict_pro_marker.pl

