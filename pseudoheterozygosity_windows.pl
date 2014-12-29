#This script generates the pseudoheterozygosity windows used as input for the script heterozygosity_to_mask.pl.
#Simply place it in the same directory as the gzipped *sites.vcf.gz files of interest, and execute!
#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT
my @AllFiles = ();
my @VCFin = ();
my @HetRegionsOut = ();

opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($a = 0; $a < @AllFiles; $a++){
  if ($AllFiles[$a] =~ m'sites.vcf'){
    push (@VCFin, (split 'sites', $AllFiles[$a])[0]);
  }
}

my $cmd = '';
my $z = 0;

for ($z = 0; $z < @VCFin; $z++){

  $cmd = 'gunzip ' . $VCFin[$z] . 'sites.vcf.gz';
  system($cmd);
  $cmd = 'purge';
  system($cmd);

  my $Chrom = '';
  my $Position = '';
  my $Quality = '';
  my $Genotype = '';
  my $infile = '';
  my $outfile = '';
  
  $infile = $VCFin[$z] . 'sites.vcf';
  $outfile = $VCFin[$z] . '_HetRegions.txt';
  open C, ">$outfile";

#INPUT
  my @line = ();
  my @chromosome = ();
  my @window = ();
  my @hetcounts = ();
  my @totalsites = ();
  my @frequency = ();
  my $prevpos = 0;
  my $hets = 0;
  my $sites = 0;
  my $j = 0;
  my $k = 0;
  my $start = 1;
  my $Individual2 = '';
  my $AlleleRef_Depth = '';
  my $AlleleAlt_Depth = '';
  my $prop = '';
  my $x = 0;
  my $stop = 0;
  my $hold = 3;
  
  open V, "<$infile";
  while (<V>){
    chomp;
    last if m/^$/;
    @line = split;
    next if ($line[0] =~ m/#/);
    last if ($line[0] > 8);
    if ($line[0] =~ m/3|4|5|7|8/){
      if ($line[5] ne '.') {
	if ($line[4] ne '.') {
	  $Chrom = $line[0];
	  $Position = $line[1];
	  $Individual2 = ((split /:/, $line[9])[1]);
	  $AlleleRef_Depth = ((split /,/, $Individual2)[0]);
	  $AlleleAlt_Depth = ((split /,/, $Individual2)[1]);
	  $prop = ($AlleleAlt_Depth/($AlleleAlt_Depth + $AlleleRef_Depth));
	  $Genotype = $prop;
	}
	else {
	  $Chrom = $line[0];
	  $Position = $line[1];
	  $Genotype = 1;
	}
      }
      else {
	$Chrom = $line[0];
	$Position = $line[1];
	$Genotype = 'X';
      }
    }
    
      if ($x == 5000) {
	$cmd = 'purge';
	system($cmd);
	$x = 0;
      }

      if (($Position >= $start) && ($Position <= (4999 + $start))) {
	if ($Genotype ne 'X') {
	  $sites++;
	  if ($Genotype <= 0.75) {
	    $hets++;
	  }
	}
	$prevpos = $Position;
      }
      elsif ($Position > (4999 + $start)) {
	$stop = ($start + 4999);
	$x++;
#	print "window ends at $stop\n";
	push @chromosome, $Chrom;
	push @window, $stop;
	push @hetcounts, $hets;
	push @totalsites, $sites;
	$hets = 0;
	$sites = 0;
	$start += 5000;
	if ($Genotype ne 'X') {
	  $sites++;
	  if ($Genotype <= 0.75) {
	    $hets++;
	  }
	  $prevpos = $Position;
	}
      }
      elsif ($Position < $start) {
	$x++;
#	print "window ends at $prevpos\n";
	push @chromosome, $hold;
	push @window, $prevpos;
	push @hetcounts, $hets;
	push @totalsites, $sites;
	$hold = $Chrom;
	$prevpos = $Position;
	$hets = 0;
	$sites = 0;
	$start = 1;
	if ($Genotype ne 'X') {
	  $sites++;
	  if ($Genotype <= 0.75) {
	    $hets++;
	  }
	}
      }
    }
  }
  close V;
  #  $cmd = 'gzip ' . $VCFin[$z] . '_shifted.vcf';
  #  system($cmd);
  #  $cmd = 'purge';
  #  system($cmd);
    
  my $b = 1;
  my $a = 0;
  my $allsites = 0;
  my $allhets = 0;
  my $HetFreq = 0;

  for ($a = 0; $a < @chromosome; $a++) {
    if ($chromosome[$a+1] eq $chromosome[$a]) {
      if ($b < 20) {
	$allsites += $totalsites[$a];
	$allhets += $hetcounts[$a];
	$b++;
      }
      elsif ($b == 20) {
	$allsites += $totalsites[$a];
	$allhets += $hetcounts[$a];
	if ($allsites == 0) {
	  $HetFreq = 0;
	}
	else {
	  $HetFreq = $allhets/$allsites;
	}
	print C "$chromosome[$a]\t$window[$a]\t$allhets\t$allsites\t$HetFreq\n";
	$allsites = 0;
	$allhets = 0;
	$HetFreq = 0;
	$b = 1;
	$a -= 19;
      }
    }
    elsif ($chromosome[$a+1] ne $chromosome[$a]) {
      $allsites += $totalsites[$a];
      $allhets += $hetcounts[$a];
      if ($allsites == 0) {
	$HetFreq = 0;
      }
      else {
	$HetFreq = $allhets/$allsites;
      }
      print C "$chromosome[$a]\t$window[$a]\t$allhets\t$allsites\t$HetFreq\n";
      $allsites = 0;
      $allhets = 0;
      $HetFreq = 0;
      $b = 1;
    }
  }
  close C;
}
