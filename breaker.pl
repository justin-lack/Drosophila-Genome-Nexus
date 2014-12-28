#!/usr/bin/perl -w
use strict;

my $i = 0;
my $cmd = "";


my @AllFiles = ();
my @FasFiles = ();





#open directory (SWITCH CHROMOSOME ARM HERE)
opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($i = 0; $i < @AllFiles; $i++){
  if ($AllFiles[$i] =~ m/seq/){
    push @FasFiles, $AllFiles[$i];
  }
}

#fold each file
for ($i = 0; $i < @FasFiles; $i++){
  $cmd = "fold -w 1000 " . $FasFiles[$i] . " > " . $FasFiles[$i] . "1k";
  system($cmd);
}
