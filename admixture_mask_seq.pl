#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT

my @line = ();
my @FilterLine = ();
my @Chrom = ();
my @Start = ();
my @Stop = ();
my $cmd = '';
my @Sequence = ();
my @AllFiles = ();
my @SeqFiles = ();

#open directory
opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($a = 0; $a < @AllFiles; $a++){
  if ($AllFiles[$a] =~ m'.seq'){
    push @SeqFiles, $AllFiles[$a];
  }
}

$cmd = 'mkdir unmasked_admixture';
system($cmd);

open X, "<admixture_filter_tracts.txt";
while (<X>){
  chomp;
  last if m/^$/;
  @line = split;
  next if ($line[0] =~ m/#/);
  if ($line[0] ne '#'){
    push @FilterLine, $line[0];
    push @Chrom, $line[1];
    push @Start, $line[2];
    push @Stop, $line[3];
  }
}

close X;
undef @line;
my $i = 0;
my $c = 0;
my $d = 0;
my $hold = '';
my $outfile = '';
my $infile = '';
my @filebank = 'null';

for ($d = 0; $d < @SeqFiles; $d++) {
  for ($i = 0; $i <@Chrom; $i++) {
    if (($SeqFiles[$d] =~ m/$Chrom[$i]/) && ($SeqFiles[$d] =~ m/$FilterLine[$i]/)) {
      $outfile = $FilterLine[$i] . '_' . $Chrom[$i] . '.seq';
      $infile = $FilterLine[$i] . '_' . $Chrom[$i] . '.seq';
      open Y, "<$infile";
      while (<Y>){
	chomp;
	last if m/^$/;
	@line = split;
	next if ($line[0] =~ m/#/);
	if ($line[0] ne '3'){
	  push @Sequence, (split //, $line[0]);
	}
      }
      $cmd = 'mv -n ' . $infile . ' unmasked_admixture';
      system($cmd);
      open C, ">$outfile";
      my $a = 0;
      for ($a = 0; $a < @Sequence; $a++) {
	if (($a >= ($Start[$i] - 1)) && ($a <= ($Stop[$i] + 1))) {
	  print C 'N';
	}
	else {
	  if ($a == ($Stop[$i] + 2)) {
	    print C "$Sequence[$a]";
	  }
	  else {
	    print C "$Sequence[$a]";
	  }
	}
      }
      undef @Sequence;
      close C;
      close Y;
      undef @line;
      $cmd = 'purge';
      system($cmd);
    }
  }
}
