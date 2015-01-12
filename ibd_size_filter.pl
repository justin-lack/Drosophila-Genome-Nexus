#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT

@line = ();

open V, "<ibd_pop_region_filtered.txt";
#scalar (<V>);
while (<V>){
  chomp;
  last if m/^$/;
  @line = split;
  if ($line2[0] ne '#'){
    push @line1, $line[0];
    push @line2, $line[1];
    push @chr, $line[2];
    push @start, $line[3];
    push @stop, $line[4];
    push @length, $line[5];
  }
}
close V;

undef @line;

#filter out comparisons <5000000

open C, ">ibd_pop_region_size_filtered.txt";

my $c = 0;
my $d = 0;
my $b = 0;
my $total = 0;

for ($d = 0; $d < @line1; $d++){
  if ($d == 0) {
    $total = $length[$d];
    $c++;
  }
  else {
    if (($line1[$d] eq $line1[$d-1]) && ($line2[$d] eq $line2[$d-1])) {
      $total += $length[$d];
      $c++;
    }
    else {
      if ($total >= 5000000) {
	$b = $d - $c;
	while ($b < $d) {
	  print C "$line1[$b]\t$line2[$b]\t$chr[$b]\t$start[$b]\t$stop[$b]\t$length[$b]\n";
	  $b++;
	}
	$c = 0;
	$total = $length[$d];
	$c++;
      }
      else {
	$c = 0;
	$total = $length[$d];
	$c++;
      }
    }
  }
}
