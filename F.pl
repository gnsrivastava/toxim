#!/usr/bin/perl

chomp ($inputfile = <$ARGV[0]>);
#Fingerprint calculations

system("java -jar PaDEL-Descriptor.jar removesalt -standardizetautomers -tautomerlist tautomerlist_SMIRKS.txt -convert3d -fingerprints -maxruntime -1 -log -usefilenameasmolname maxcpdperfile 0 -dir $inputfile -file fingerprints");

open(IN, "fingerprints") || die "Cannot open file fingerprints_IN!\n";
open(HEADER, ">Header") || die "Cannot open file Header\n";

chomp(my $line7 = <IN>);
print HEADER "$line7";

close IN;
close HEADER;

system ("sed '1d' fingerprints > fingerprints1");
open(HEADER, "Header") || die "Cannot open file Header\n";
open(IN1, "fingerprints1") || die "Cannot open file fingerprints1_IN1!\n";
open(OUT, ">fingerprints2") || die "Cannot open file fingerprints2_OUT!\n";

chomp(my $line7=<HEADER>);
print OUT "$line7\n";

while (chomp(my $line8=<IN1>))
{
   $line8 =~ s/\"\,/.sdf,/g;
   $line8 =~ s/\"//g;
  print OUT "$line8\n";
}

close OUT;
close IN1;
close HEADER;

system ("mv fingerprints2 fingerprints");
system ("sed 's/,/ /g' fingerprints > fingerprints_top0.5per1");
system ("./transpose.awk fingerprints_top0.5per1 > fingerprints_top0.5per2");
system ("head -1 fingerprints_top0.5per2 > header");
system ("grep -w -f FP_Top10per fingerprints_top0.5per2 > fingerprints_top0.5per3");
system ("cat header fingerprints_top0.5per3 > fingerprints_top0.5per4");
system ("./transpose.awk fingerprints_top0.5per4 > fingerprints_top0.5per5");
system ("sed 's/ /,/g' fingerprints_top0.5per5 > fingerprints_top0.5per6");
system ("rm fingerprints_top0.5per1 fingerprints_top0.5per2 header fingerprints_top0.5per3 fingerprints_top0.5per4 fingerprints_top0.5per5");
system ("mv fingerprints_top0.5per6 fingerprints_top10per");

# Descriptor Calculation
open (IN2, "script.py") || die "Cannot open file script.py!";
open (OF, ">script_1.py") || die "Cannot open the file script_1.py\n";

while (chomp ($line = <IN2>))
{
	if ($line =~ /\"file\"/)
        {
		$line =~ s/\"file\"/\"$inputfile\"/g;
                print OF "$line\n";
        }
	else
	{
		print OF "$line\n";
	}
}
system ("sh source.sh");
close IN2;
close OF;

open(FILE, "desc.txt") || die "Cannot open the file desc.txt!";

#RoundOff to 1 decimal point
open(OUT,">final_desc")|| die "Cannot open the file output final_desc!\n";

while(chomp($line1 = <FILE>))
{     
    $line1 =~ s/\(//g;  
	@ar = split	(", ", $line1);	
	for ($i = 0; $i < 196; $i ++)
	{ 
		printf OUT "%.1f",$ar[$i];
		if ($i != 195)
			{
				print OUT ",";
			}
	}
	print OUT "\n";
	
}
close FILE;

#Creating the final total descriptor file
system ("sed '1d' fingerprints > fingerprintsn");
open (ME1, "fingerprintsn") || die "Cannot open fingerprintsn!\n";
open(OUT, "final_desc") || die "Cannot open file final_desc!\n";
open(OUT1, ">desc") || die "Cannot open file desc!\n";
print OUT1 "Name,MinAbsPartialCharge,NumRadicalElectrons,HeavyAtomMolWt,MaxAbsEStateIndex,MaxAbsPartialCharge,MaxEStateIndex,MinPartialCharge,ExactMolWt,MolWt,NumValenceElectrons,MinEStateIndex,MinAbsEStateIndex,MaxPartialCharge,BalabanJ,BertzCT,Chi0,Chi0n,Chi0v,Chi1,Chi1n,Chi1v,Chi2n,Chi2v,Chi3n,Chi3v,Chi4n,Chi4v,HallKierAlpha,Ipc,Kappa1,Kappa2,Kappa3,LabuteASA,PEOE_VSA1,PEOE_VSA10,PEOE_VSA11,PEOE_VSA12,PEOE_VSA13,PEOE_VSA14,PEOE_VSA2,PEOE_VSA3,PEOE_VSA4,PEOE_VSA5,PEOE_VSA6,PEOE_VSA7,PEOE_VSA8,PEOE_VSA9,SMR_VSA1,SMR_VSA10,SMR_VSA2,SMR_VSA3,SMR_VSA4,SMR_VSA5,SMR_VSA6,SMR_VSA7,SMR_VSA8,SMR_VSA9,SlogP_VSA1,SlogP_VSA10,SlogP_VSA11,SlogP_VSA12,SlogP_VSA2,SlogP_VSA3,SlogP_VSA4,SlogP_VSA5,SlogP_VSA6,SlogP_VSA7,SlogP_VSA8,SlogP_VSA9,TPSA,EState_VSA1,EState_VSA10,EState_VSA11,EState_VSA2,EState_VSA3,EState_VSA4,EState_VSA5,EState_VSA6,EState_VSA7,EState_VSA8,EState_VSA9,VSA_EState1,VSA_EState10,VSA_EState2,VSA_EState3,VSA_EState4,VSA_EState5,VSA_EState6,VSA_EState7,VSA_EState8,VSA_EState9,FractionCSP3,HeavyAtomCount,NHOHCount,NOCount,NumAliphaticCarbocycles,NumAliphaticHeterocycles,NumAliphaticRings,NumAromaticCarbocycles,NumAromaticHeterocycles,NumAromaticRings,NumHAcceptors,NumHDonors,NumHeteroatoms,NumRotatableBonds,NumSaturatedCarbocycles,NumSaturatedHeterocycles,NumSaturatedRings,RingCount,MolLogP,MolMR,fr_Al_COO,fr_Al_OH,fr_Al_OH_noTert,fr_ArN,fr_Ar_COO,fr_Ar_N,fr_Ar_NH,fr_Ar_OH,fr_COO,fr_COO2,fr_C_O,fr_C_O_noCOO,fr_C_S,fr_HOCCN,fr_Imine,fr_NH0,fr_NH1,fr_NH2,fr_N_O,fr_Ndealkylation1,fr_Ndealkylation2,fr_Nhpyrrole,fr_SH,fr_aldehyde,fr_alkyl_carbamate,fr_alkyl_halide,fr_allylic_oxid,fr_amide,fr_amidine,fr_aniline,fr_aryl_methyl,fr_azide,fr_azo,fr_barbitur,fr_benzene,fr_benzodiazepine,fr_bicyclic,fr_diazo,fr_dihydropyridine,fr_epoxide,fr_ester,fr_ether,fr_furan,fr_guanido,fr_halogen,fr_hdrzine,fr_hdrzone,fr_imidazole,fr_imide,fr_isocyan,fr_isothiocyan,fr_ketone,fr_ketone_Topliss,fr_lactam,fr_lactone,fr_methoxy,fr_morpholine,fr_nitrile,fr_nitro,fr_nitro_arom,fr_nitro_arom_nonortho,fr_nitroso,fr_oxazole,fr_oxime,fr_para_hydroxylation,fr_phenol,fr_phenol_noOrthoHbond,fr_phos_acid,fr_phos_ester,fr_piperdine,fr_piperzine,fr_priamide,fr_prisulfonamd,fr_pyridine,fr_quatN,fr_sulfide,fr_sulfonamd,fr_sulfone,fr_term_acetylene,fr_tetrazole,fr_thiazole,fr_thiocyan,fr_thiophene,fr_unbrch_alkane,fr_urea\n";
$i=1;
$hash={};
while(chomp($line=<ME1>))
{

	@arr = split(",",$line);
	$hash->{$i}=$arr[0];
	$i++;
}
	
$i1=1;

while(chomp($line1=<OUT>))
{
	print OUT1 "$hash->{$i1},$line1\n";
	$i1++;
}

close ME1;
close OUT;
close OUT1;

system ("sh RscriptFP_R.sh");

system ("cut -d\",\" -f1 fingerprints_top10per > molid");
system ("sed 's/\"//g' Blind_pred_FP.txt > Blind_pred_FP1");
system ("sed 's/NT/\t\tNT/g' Blind_pred_FP1 > Blind_pred_FP2");
system ("cut -f 2- Blind_pred_FP2 > Blind_pred_FP3");
system ("paste molid Blind_pred_FP3 > Blind_pred_FP4");
system ("rm -fr Blind_pred_FP Blind_pred_FP1 Blind_pred_FP2 Blind_pred_FP3 molid");
system ("mv Blind_pred_FP4 Blind_pred_FP.txt");
system ("tail -1 Blind_pred_FP.txt > score_file");
system ("sed 's/\t/,/g' score_file > FP_score");

# This is to calculate solubility
system("sed 's/,/ /g' desc > desc_top0.5per1");
system("./transpose.awk desc_top0.5per1 > desc_top0.5per2");
system("head -1 desc_top0.5per2 > header");
system("grep -w -f Top_40 desc_top0.5per2 > desc_top0.5per3");
system("cat header desc_top0.5per3 > desc_top0.5per4");
system("./transpose.awk desc_top0.5per4 > desc_top0.5per5");
system("sed -i 's/ /,/g' desc_top0.5per5");
system("rm desc_top0.5per1 desc_top0.5per2 header desc_top0.5per3 desc_top0.5per4");
system("mv desc_top0.5per5 sol_top40");

# Calculating Blind prediction scores
system ("sh Rscriptsol_R.sh");

# processing the blind prediction file
system ("sed 's/\"//g' Prediction_score.txt > Prediction_score1");
system ("sed 's/x/\tPrediction score/g' Prediction_score1 > Prediction_score2");
system ("rm -fr Prediction_score.txt Prediction_score1 Prediction_score.txt");
system ("cut -f 2- Prediction_score2 > sol1_score");
system ("tail -1 sol1_score > sol_score");
open(FILE2, "sol_score") || die "Cannot open the file desc.txt!";

#RoundOff to 1 decimal point
open(OUT2,">sol_score1")|| die "Cannot open the file output final_desc!\n";

while(chomp($line2 = <FILE2>))
{     
 		printf OUT2 "%.3f",$line2;


	
}
close FILE2;
close OUT2;
system ("rm -fr Prediction_score.txt Prediction_score1 Prediction_score.txt sol_score");
# This is to calculate permeability

system("sed 's/,/ /g' desc > desc_top0.5per1");
system("./transpose.awk desc_top0.5per1 > desc_top0.5per2");
system("head -1 desc_top0.5per2 > header");
system("grep -w -f Top_5 desc_top0.5per2 > desc_top0.5per3");
system("cat header desc_top0.5per3 > desc_top0.5per4");
system("./transpose.awk desc_top0.5per4 > desc_top0.5per5");
system("sed -i 's/ /,/g' desc_top0.5per5");
system("rm desc_top0.5per1 desc_top0.5per2 header desc_top0.5per3 desc_top0.5per4");
system("mv desc_top0.5per5 permeability_top5");

# Calculating Blind prediction scores
system ("sh Rscriptper_R.sh");

# processing the blind prediction file
system ("sed 's/\"//g' Prediction_score.txt > Prediction_score1");
system ("sed 's/x/\tPrediction score/g' Prediction_score1 > Prediction_score2");
system ("cut -f 2- Prediction_score2 > per_score1");
system ("tail -1 per_score1 > per_score");
open(FILE3, "per_score") || die "Cannot open the file desc.txt!";

#RoundOff to 1 decimal point
open(OUT3,">per_score1")|| die "Cannot open the file output final_desc!\n";

while(chomp($line3 = <FILE3>))
{     
 		printf OUT3 "%.3f",$line3;


	
}
close FILE3;
close OUT3;
system ("rm -fr Prediction_score.txt Prediction_score1 Prediction_score.txt per_score");
system ("paste -d ',' FP_score sol_score1 per_score1 > score_file1");
system ("cut -f1 -d',' score_file1 > molid");
system ("cut -d ',' -f 3- score_file1 > scores");
system ("paste -d',' molid scores > score_file");
system ("cat final_header score_file > scores_fp.txt");
system ("mv scores_fp.txt prediction/");
system ("rm Blind_pred_FP.txt desc desc.txt final_desc fingerprints.log FP_score molid Prediction_score2  scores sol1_score fingerprints fingerprintsn permeability_top5 score_file sol_score1 fingerprints1 fingerprints_top10per Header per_score1 score_file1 script_1.py sol_top40");
