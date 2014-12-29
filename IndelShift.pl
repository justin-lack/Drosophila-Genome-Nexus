#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';
#Input files should be a gzipped GATK Unified Genotyper all-sites VCF files, with the extension *_sites.vcf.gz and an INDEL vcf file with the extension _INDELS.vcf. Reference contigs should be numbered (i.e., 1, 2, 3...) rather than named conventionally. On line 36 of this script, be sure to change the $Contigs variable to the number of contigs in your reference genome. If you are using a reference genome that is unordered and therefore has many contigs, I can provide another verison of this script that will hadnle this automatically.
#As examples, my input files are named EF12N_sites.vcf.gz, and the indel file is EF12N_INDELS.vcf. The contigs in these VCFs files are 1-16 (so contigs are numbered). These input files should be in the same directory as this script. Then just execute the script!
#
#INPUT

my @IndelIN = ();
my @SNPsIN = ();
my @CoordinatesOUT = ();
my @VCFOUT = ();
my @AllFiles = ();
my @Files = ();
my $z = 0;
my $VCFin = '';
my $INDELSin = '';
my $COORDINATESout = '';
my $VCFout = '';
my $cmd = '';

#open directory
opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($a = 0; $a < @AllFiles; $a++){
  if ($AllFiles[$a] =~ m'sites.vcf.gz'){
    push (@Files, (split '_sites', $AllFiles[$a])[0]);
  }
}

for ($z = 0; $z < @Files; $z++){
  my $RefChrom = 1;
  my $Contigs = 16;   #Set this to the number of contigs in your reference genome (i.e., if you have euchromatin from 2R, 2L, 3R, 3L, and X then this would be 5
  
  $VCFin = $Files[$z] . '_sites.vcf';
  $INDELSin = $Files[$z] . '_INDELS.vcf';
  $COORDINATESout = $Files[$z] . 'IndelCoordinates.out';
  $VCFout = $Files[$z] . '_shifted.vcf';

  $cmd = "gunzip " . $VCFin . '.gz';
  system($cmd);

  open C, ">$VCFout";
  open G, ">$COORDINATESout";

  my @Chrom3 = ();
  my @IndelStart2 = ();
  my @IndelLength2 = ();
  my @IndelType2 = ();

  for ($RefChrom = 1; $RefChrom <= $Contigs; $RefChrom++) {
    my @line = ();
    my @Chrom = ();
    my @Position = ();
    my @Ref = ();
    my @Alt = ();
    my @Qual = ();
    my @Filter = ();
    my @RefAlleleLength = ();
    my @AltAlleleLength = ();
    my @IndelType = ();
    my @IndelLength = ();
    my @IndelStart = ();
    my @IndelStop = ();
    my @Offset = ();
    my @Chrom2 = ();
    my @Position2 = ();
    my @REB18 = ();
    my @Alt2 = ();
    my @Qual2 = ();
    my @Filter2 = ();

  $cmd = "purge";
  system($cmd);

open U, "<$INDELSin";
while (<U>){
  chomp;
  last if m/^$/;
  @line = split;
  next if ($line[0] =~ m/#/);
  last if ($line[0] > $RefChrom);
  if ($line[0] == $RefChrom){
    push @Chrom, $line[0];
    push @Position, $line[1];
    push @Ref, $line[3];
    push @Alt, $line[4];
    push @Qual, $line[5];
    push @Filter, $line[6];
  }
}
close U;

undef @line;
my $x = 0;
my $garbage = 0;
my $size = 0;

for ($x = 0; $x < @Chrom; $x++){
  if ($x == 0){
    push @Chrom2, $Chrom[$x];
    push @Position2, $Position[$x];
    push @REB18, $Ref[$x];
    push @Alt2, $Alt[$x];
    push @Qual2, $Qual[$x];
    push @Filter2, $Filter[$x];
    $garbage = $Position[$x];
    $size = ((length$Ref[$x])-1);
  }
  else{
    if ($Position[$x] > ($garbage + $size)){
      push @Chrom2, $Chrom[$x];
      push @Position2, $Position[$x];
      push @REB18, $Ref[$x];
      push @Alt2, $Alt[$x];
      push @Qual2, $Qual[$x];
      push @Filter2, $Filter[$x];
      $garbage = $Position[$x];
      $size = ((length$Ref[$x])-1);
    }
  }
}

undef @Chrom;
undef @Position;
undef @Ref;
undef @Alt;
undef @Qual;
undef @Filter;

my $j = 0;

for ($j = 0; $j < @Chrom2; $j++){
    push @RefAlleleLength, ((length$REB18[$j]) - 1);
    push @AltAlleleLength, ((length$Alt2[$j]) - 1);
  }

my $m = 0;

for ($m = 0; $m < @RefAlleleLength; $m++){
  if (($RefAlleleLength[$m] != -9) && ($AltAlleleLength[$m] != -9)){
    if ($RefAlleleLength[$m] > 0){
      push @IndelType, '-';
      push @IndelLength, $RefAlleleLength[$m];
    }
    else {
      push @IndelType, '+';
      push @IndelLength, $AltAlleleLength[$m];
    }
  }
}

my $l = 0;
my $offset = 1;

for ($l = 0; $l < @Chrom2; $l++){
  push @IndelStart, ($Position2[$l] + $offset);
  push @Offset, "$offset";
  $offset += ($AltAlleleLength[$l] - $RefAlleleLength[$l]);
}

my $k = 0;

print G "Chrom\tOriginalPos\tIndelType\tAdjustedStart\tRefAllele\tAltAllele\tOffset\tIndelLength\tQuality\tFilter\n";

for ($k = 0; $k < @Chrom2; $k++){
  push @Chrom3, $Chrom2[$k];
  push @IndelType2, $IndelType[$k];
  push @IndelStart2, $IndelStart[$k];
  push @IndelLength2, $IndelLength[$k];
  print G "$Chrom2[$k]\t$Position2[$k]\t$IndelType[$k]\t$IndelStart[$k]\t$REB18[$k]\t$Alt2[$k]\t$Offset[$k]\t$IndelLength[$k]\t$Qual2[$k]\t$Filter2[$k]\n";
}

print "Finished with indel assessment\n";
  }

#INPUT

  my @line2 = ();
  my $chrX = 0;
  my $PositionX = 0;
  my $IDX = 0;
  my $ReferenceX = 0;
  my $AlternateX = 0;
  my $QualityX = 0;
  my $FilterX = 0;
  my $InfoX = 0;
  my $FormatX = 0;
  my $IndividualX = 0;
  my $NewPos = 0;
  my $c = 0;
  my $d = 0;
  my $PosShiftX = 0;
  my $b = 0;
  my $AltPos = 0;
  my $hold = 1;

  open V, "<$VCFin";
  while (<V>){
    chomp;
    last if m/^$/;
    @line2 = split;
    next if ($line2[0] =~ m/#/);
    if ($line2[0] ne '#'){
      $chrX = $line2[0];
      $PositionX = $line2[1];
      $IDX = $line2[2];
      $ReferenceX = $line2[3];
      $AlternateX = $line2[4];
      $QualityX = $line2[5];
      $FilterX = $line2[6];
      $InfoX = $line2[7];
      $FormatX = $line2[8];
      $IndividualX = $line2[9];
      
      #adjust positions for X
      if ($d < @Chrom3) {
	if ($chrX == $hold) {
	  if ($chrX == $Chrom3[$d]) {
	    if ($PositionX < $IndelStart2[$d]){
	      $NewPos = ($PositionX - $PosShiftX);
	      print C "$chrX\t$NewPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
	    }
	    else {
	      if ($IndelType2[$d] eq '+') {
		if (($PositionX >= $IndelStart2[$d]) && ($PositionX < ($IndelStart2[$d] + $IndelLength2[$d]))) {
		  print "skipping stuff\n";
		}
		elsif ($PositionX == ($IndelStart2[$d] + $IndelLength2[$d])) {
		  $AltPos = $NewPos +1;
		  print C "$chrX\t$AltPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
		  $PosShiftX += $IndelLength2[$d];
		  $d++;
		}
		elsif ($PositionX > ($IndelStart2[$d] + $IndelLength2[$d])) {
		  $AltPos = $NewPos + 1 + ($PositionX - ($IndelStart2[$d] + $IndelLength2[$d]));
		  print C "$chrX\t$AltPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
		  $PosShiftX += $IndelLength2[$d];
		  $d++;
		}
	      }
	      elsif ($IndelType2[$d] eq '-') {
		if ($PositionX >= $IndelStart2[$d]) {
		  $PosShiftX -= $IndelLength2[$d];
		  $NewPos = ($PositionX - $PosShiftX);
		  print C "$chrX\t$NewPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
		  $d++;
		}
	      }
	    }
	  }
	  else {
	    $NewPos = ($PositionX - $PosShiftX);
	    print C "$chrX\t$NewPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
	  }
	}
	else {
	  $PosShiftX = 0;
	  $NewPos = ($PositionX - $PosShiftX);
	  print C "$chrX\t$NewPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
	  $hold++;
	}
      }
      else {
	$NewPos = ($PositionX - $PosShiftX);
	print C "$chrX\t$NewPos\t$IDX\t$ReferenceX\t$AlternateX\t$QualityX\t$FilterX\t$InfoX\t$FormatX\t$IndividualX\n";
	$hold++;
      }
    }
  }
  $cmd = "gzip " . $VCFin;
  system($cmd);
  $cmd = "gzip " . $VCFout;
  system($cmd);
}
