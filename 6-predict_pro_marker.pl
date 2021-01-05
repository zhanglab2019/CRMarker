#!/usr/bin/perl -w
$f1="~/predict/over_net_pro_gen.txt";
$f2="~/predict/not_search_pro_gen.txt";
$f3="~/predict/over_net_pro_mirna.txt";
$f4="~/predict/not_search_pro_mirna.txt";
$f5="~/predict/over_net_pro_lncrna.txt";
$f6="~/predict/not_search_pro_lncrna.txt";
$f7="~/interaction_data/interaction_data_ppi.txt";
$f8="~/interaction_data/interaction_data_mirna_gene.txt";
$f9="~/interaction_data/interaction_data_lncrna_gene.txt";
$f10="~/interaction_data/interaction_data_mirna_lncrna.txt";

open I, "$f1";
while(<I>){
	chomp;
	$pro_gen{$_}++;
}
close I;

open I, "$f2";
while(<I>){
	chomp;
	$n_pro_gen{$_}++;
}
close I;

open I, "$f3";
while(<I>){
	chomp;
	$pro_mir{$_}++;
}
close I;

open I, "$f4";
while(<I>){
	chomp;
	$n_pro_mir{$_}++;
}
close I;

open I, "$f5";
while(<I>){
	chomp;
	$pro_lnc{$_}++;
}
close I;

open I, "$f6";
while(<I>){
	chomp;
	$n_pro_lnc{$_}++;
}
close I;

open I, "$f7";
while(<I>){
	next if $.==1;
	chomp;
	($gen1,$gen2)=split /\t/;
	if((exists $n_pro_gen{$gen1})&(exists $pro_gen{$gen2})){
		$pre_gen{$gen1}{$gen2}++;
	}
	elsif((exists $pro_gen{$gen1})&(exists $n_pro_gen{$gen2})){
		$pre_gen{$gen2}{$gen1}++;
	}
}
close I;

open I, "$f8";
while(<I>){
	next if $.==1;
	chomp;
	($mir1,$gen3)=split /\t/;
	$mir1=~s/hsa-//g;
	$mir1=~s/miR/mir/g;
	if((exists $n_pro_mir{$mir1})&(exists $pro_gen{$gen3})){
		$pre_mir{$mir1}{$gen3}++;
	}
	elsif((exists $pro_mir{$mir1})&(exists $n_pro_gen{$gen3})){
		$pre_gen{$gen3}{$mir1}++;
	}
}
close I;

open I, "$f9";
while(<I>){
	next if $.==1;
	chomp;
	($lnc1,$gen4)=split /\t/;
#	$mir1=~s/hsa-//g;
#	$mir1=~s/miR/mir/g;
	if((exists $n_pro_lnc{$lnc1})&(exists $pro_gen{$gen4})){
		$pre_lnc{$lnc1}{$gen4}++;
	}
	elsif((exists $pro_lnc{$lnc1})&(exists $n_pro_gen{$gen4})){
		$pre_gen{$gen4}{$lnc1}++;
	}
}
close I;

open I, "$f10";
while(<I>){
	next if $.==1;
	chomp;
	($mir2,$lnc2)=split /\t/;
	$mir2=~s/hsa-//g;
	$mir2=~s/miR/mir/g;
	if((exists $n_pro_mir{$mir2})&(exists $pro_lnc{$lnc2})){
		$pre_mir{$mir2}{$lnc2}++;
	}
	elsif((exists $pro_mir{$mir2})&(exists $n_pro_lnc{$lnc2})){
		$pre_lnc{$lnc2}{$mir2}++;
	}
}
close I;

open O, ">~/predict/predict_pro_gen_sup.txt"; 
for $g(sort keys %pre_gen){
	undef @sup;
	undef $nb;
	for $g2(sort keys %{$pre_gen{$g}}){
		push @sup,$g2;
		$nb=scalar @sup;
	}
		$gen_sup=join ",",@sup;
		print O "$g\t$nb\t$gen_sup\n";
}
close O;

open O, ">~/predict/predict_pro_mirna_sup.txt"; 
for $m(sort keys %pre_mir){
	undef @sup;
	undef $nb;
	for $m2(sort keys %{$pre_mir{$m}}){
		push @sup,$m2;
		$nb=scalar @sup;
	}
		$mir_sup=join ",",@sup;
		print O "$m\t$nb\t$mir_sup\n";
}
close O;

open O, ">~/predict/predict_pro_lncrna_sup.txt"; 
for $n(sort keys %pre_lnc){
	undef @sup;
	undef $nb;
	for $n2(sort keys %{$pre_lnc{$n}}){
		push @sup,$n2;
		$nb=scalar @sup;
	}
		$lnc_sup=join ",",@sup;
		print O "$n\t$nb\t$lnc_sup\n";
}
close O;
