#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#This script filters the first round SNP vcf files based on the the proportion of all reads at a given site that match the alternate base call, with a minimum of 75% being acceptable. It filters all round 1 SNP vcf files in the working directory.

#INPUT

my $Output_name = "";
my $outfile = "";
my $m = 0;
my $i = 0;
my $g = 0;

my @AllFiles = ();
my @InFiles = ();

#open directory
opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($i = 0; $i < @AllFiles; $i++){
  if ($AllFiles[$i] =~ m/_round1_SNPs.vcf/){
    push @InFiles, $AllFiles[$i];
  }
}

for ($g = 0; $g < @InFiles; $g++) {

my @line = ();
my @Chrom = ();
my @Position = ();
my @ID = ();
my @Ref = ();
my @Alt = ();
my @Qual = ();
my @Filter = ();
my @Info = ();
my @Format = ();
my @Individual = ();
my @Genotype = ();
my @Allele_Depth = ();
my @Depth = ();
my @Genotype_Quality = ();
my @MLPSAC = ();
my @MLPSAF = ();
my @Penalized_Likelihood = ();
my @AlleleRef_Depth = ();
my @AlleleAlt_Depth = ();

  $Output_name = ((split /_/, $InFiles[$g])[0]);
  $outfile = $Output_name . "_SNPs_filtered.vcf";

open U, "<$InFiles[$g]";
#scalar (<U>);
while (<U>){
  chomp;
  last if m/^$/;
  @line = split;
  next if ($line[0] =~ m/#/);
  if ($line[0] ne '#'){
    push @Chrom, $line[0];
    push @Position, $line[1];
    push @ID, $line[2];
    push @Ref, $line[3];
    push @Alt, $line[4];
    push @Qual, $line[5];
    push @Filter, $line[6];
    push @Info, $line[7];
    push @Format, $line[8];
    push @Individual, $line[9];
  }
}
close U;

my $j = 0;

for ($j = 0; $j < @Chrom; $j++){
  push (@Genotype, (split /:/, $Individual[$j])[0]);
  push (@Allele_Depth, (split /:/, $Individual[$j])[1]);
  push (@Depth, (split /:/, $Individual[$j])[2]);
  push (@Genotype_Quality, (split /:/, $Individual[$j])[3]);
  push (@MLPSAC, (split /:/, $Individual[$j])[4]);
  push (@MLPSAF, (split /:/, $Individual[$j])[5]);
  push (@Penalized_Likelihood, (split /:/, $Individual[$j])[6]);
#  print "$Allele_Depth[$j]\n";
}

my $l = 0;

for ($l = 0; $l < @Chrom; $l++){
  push (@AlleleRef_Depth, (split /,/, $Allele_Depth[$l])[0]);
  push (@AlleleAlt_Depth, (split /,/, $Allele_Depth[$l])[1]);
  print "$AlleleRef_Depth[$l]\n";
}
  
my $k = 0;
open G, ">$outfile";
print G "##fileformat=VCFv4.1\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$outfile\n";

for ($k = 0; $k < @Chrom; $k++){
  if (($AlleleAlt_Depth[$k]/($AlleleAlt_Depth[$k] + $AlleleRef_Depth[$k])) > 0.75){
      print G "$Chrom[$k]\t$Position[$k]\t$ID[$k]\t$Ref[$k]\t$Alt[$k]\t$Qual[$k]\t$Filter[$k]\t$Info[$k]\t$Format[$k]\t$Individual[$k]\n";
    }
}
}
