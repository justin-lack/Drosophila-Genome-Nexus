#This script uses as input the *_HetRegions.txt outputs from the heterozygosity_windows.pl script, as well as the FR_pi.txt and RG_pi.txt. 
#It then identifies tracts of heterozygosity that excede the thresholds described in INSTRUCTIONS_FILTERING and outputs these tracts.
#The array of chromosome arms (@Chromosome) contains the contigs from the reference genome you wish to examine.
#This should be changed to match the contigs in your target reference genome.

#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT

my @AllFiles = ();
my @HeterozygosityIn = ();
my @HetRegionsOut = ();
my @Chromosome = ('3', '4', '5', '7', '8');
my $z = 0;
my $k = 0;
my $a = 0;
my $outfile = '';

opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($a = 0; $a < @AllFiles; $a++){
  if ($AllFiles[$a] =~ m'HetRegions.txt'){
    push @HeterozygosityIn, $AllFiles[$a];
    push (@HetRegionsOut, (split '_Het', $AllFiles[$a])[0]);
  }
}

for ($z = 0; $z < @HeterozygosityIn; $z++){
  $outfile = $HetRegionsOut[$z] . '_HetFilterTracts.txt';
  open C, ">$outfile";

#INPUT
  for ($k = 0; $k < @Chromosome; $k++) {
    my @line = ();
    my $j = 0;
    my @Chrom = ();
    my @WinStart = ();
    my @HetFreq = ();
    my $a = 0;
    my $b = 0;
    my $end = 0;
    my @ChromPi = ();
    my @RG_five = ();
    my @RG_twenty = ();
    my $start = '';
    
    open V, "<$HeterozygosityIn[$z]";
    while (<V>){
      chomp;
      last if m/^$/;
      @line = split;
      next if ($line[0] =~ m/#/);
      last if ($line[0] > $Chromosome[$k]);
      if ($line[0] eq $Chromosome[$k]) {
	push @Chrom, $line[0];
	push @WinStart, $line[1];
	push @HetFreq, $line[4];
      }
    }
    close V;
    undef @line;

    open W, "<FR_pi.txt";
    while (<W>){
      chomp;
      last if m/^$/;
      @line = split;
      next if ($line[0] =~ m/#/);
      last if ($line[0] > $Chromosome[$k]);
      if ($line[0] eq $Chromosome[$k]) {
	push @ChromPi, $line[0];
	push @RG_five, $line[1];
	push @RG_twenty, $line[2];
      }
    }
    close W;
    undef @line;
    
    while ($j < @WinStart) {
      if ($HetFreq[$j] > $RG_five[$j]) {
	$a = $j;
	while ($a > 0) {
	  if ($HetFreq[$a] <= $RG_twenty[$a]) {
	    last;
	  }
	  else {
	    $a--;
	  }
	}
	while ($j < @WinStart) {
	  if ($HetFreq[$j] <= $RG_twenty[$j]) {
	    last;
	  }
	  else {
	    $j++;
	  }
	}
#	print "$j\n";
	$start = $WinStart[$a] + 1;
	$end = $WinStart[$j-1];
	print C "$Chromosome[$k]\t$start\t$end\n";
      }
      else {
	$j++;
      }
    }
  }
}
