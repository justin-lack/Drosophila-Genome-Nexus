#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT

my @line = ();
my @line1 = ();
my @line2 = ();
my @chr = ();
my @start = ();
my @stop = ();
my @length = ();

open V, "<ibd_pop_filtered.txt";
#scalar (<V>);
while (<V>){
  chomp;
  last if m/^$/;
  @line = split;
  if ($line[0] ne '#'){
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

open C, ">ibd_pop_region_filtered.txt";

my $c = 0;
my $d = 0;
my $b = 0;
my $total = 0;

print C "Line1\tLine2\tChromosome\tStart\tStop\tLength\tNewStart\tNewStop\n";

for ($d = 0; $d < @line1; $d++){
  if ($chr[$d] eq 'Chr3L') {
    if ((($start[$d] >= 19400001) && ($stop[$d] <= 24543557))) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t0\t0\n";
    }
    elsif (($stop[$d] >= 19400001) && ($stop[$d] <= 24543557)) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t19400000\n";
    }
    else {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
    }
  }
  elsif ($chr[$d] eq 'Chr3R') {
    if ((($start[$d] >= 1) && ($stop[$d] <= 4900000)) || (($start[$d] >= 5500001) && ($stop[$d] <= 9700000)) || (($start[$d] >= 15000001) && ($stop[$d] <= 27905053))) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t0\t0\n";
    }
    elsif ($start[$d] <= 4900000) {
      if ($stop[$d] <= 5500000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t4900001\t$stop[$d]\n";
      }
      elsif (($stop[$d] >= 5500001) && ($stop[$d] <=9700000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t4900001\t5500000\n";
      }
      elsif ($stop[$d] >= 9700001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\tcomplex\tcomplex\n";
      }
    }
    elsif (($start[$d] >= 4900001) && ($start[$d] <= 5500000)) {
      if (($stop[$d] >= 5500001) && ($stop[$d] <= 9700000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t5500000\n";
      }
      elsif (($stop[$d] >= 4900001) && ($stop[$d] <= 5500000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 9700001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\tcomplex\tcomplex\n";
      }
    }
    elsif (($start[$d] >= 5500001) && ($start[$d] <= 9700000)){
      if ($stop[$d] <= 15000000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t9700001\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 15000001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t9700001\t15000000\n";
      }
    }
    elsif (($start[$d] >= 9700001) && ($start[$d] <= 15000000)) {
      if ($stop[$d] >= 15000000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t15000000\n";
      }
      elsif (($stop[$d] >= 9700001) && ($stop[$d] <= 15000000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
    }
    else {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
    }
  }
  elsif ($chr[$d] eq 'ChrX') {
    if ((($start[$d] >= 1) && ($stop[$d] <= 2500000)) || (($start[$d] >= 20600001) && ($stop[$d] <= 22422827))) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t0\t0\n";
    }
    elsif ($start[$d] <= 2500000) {
      if ($stop[$d] <= 20600000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t2500001\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 20600001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t2500001\t20600000\n";
      }
    }
    elsif (($start[$d] >= 2500001) && ($start[$d] <= 20600000)) {
      if (($stop[$d] >= 2500001) && ($stop[$d] <= 20600000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 20600001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t20600000\n";
      }
    }
    else {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
    }
  }
  elsif ($chr[$d] eq 'Chr2R') {
    if ((($start[$d] >= 1) && ($stop[$d] <= 5800000)) || (($start[$d] >= 20000001) && ($stop[$d] <= 21146708))) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t0\t0\n";
    }
    elsif ($start[$d] <= 5800000) {
      if ($stop[$d] <= 20000000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t5800001\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 20000001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t5800001\t20000000\n";
      }
    }
    elsif (($start[$d] >= 5800001) && ($start[$d] <= 20000000)) {
      if (($stop[$d] >= 5800001) && ($stop[$d] <= 20000000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 20000001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t20000000\n";
      }
    }
    else {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
    }
  }
  elsif ($chr[$d] eq 'Chr2L') {
    if ((($start[$d] >= 1) && ($stop[$d] <= 800000)) || (($start[$d] >= 10900001) && ($stop[$d] <= 12000000)) || (($start[$d] >= 17700001) && ($stop[$d] <= 23011544))) {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t0\t0\n";
    }
    elsif ($start[$d] <= 800000) {
      if ($stop[$d] <= 10900000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t800001\t$stop[$d]\n";
      }
      elsif (($stop[$d] >= 10900001) && ($stop[$d] <=12000000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t800001\t10900000\n";
      }
      elsif ($stop[$d] >= 12000001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\tcomplex\tcomplex\n";
      }
    }
    elsif (($start[$d] >= 800001) && ($start[$d] <= 10900000)) {
      if (($stop[$d] >= 10900001) && ($stop[$d] <= 12000000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t10900000\n";
      }
      elsif (($stop[$d] >= 800001) && ($stop[$d] <= 10900000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 12000001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\tcomplex\tcomplex\n";
      }
    }
    elsif (($start[$d] >= 10900001) && ($start[$d] <= 12000000)) {
      if ($stop[$d] <= 17700000) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t12000001\t$stop[$d]\n";
      }
      elsif ($stop[$d] >= 17700001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t12000001\t17700000\n";
      }
    }
    elsif (($start[$d] >= 12000001) && ($start[$d] <= 17700000)) {
      if ($stop[$d] >= 17700001) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t17700000\n";
      }
      elsif (($stop[$d] >= 12000001) && ($stop[$d] <= 17700000)) {
	print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
      }
    }
    else {
      print C "$line1[$d]\t$line2[$d]\t$chr[$d]\t$start[$d]\t$stop[$d]\t$length[$d]\t$start[$d]\t$stop[$d]\n";
    }
  }
}
