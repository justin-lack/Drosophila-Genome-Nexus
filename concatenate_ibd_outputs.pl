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
  if ($AllFiles[$i] =~ m/_data/){
    push @FasFiles, $AllFiles[$i];
  }
}

#fold each file
for ($i = 0; $i < @FasFiles; $i++){
  $cmd = 'cat ' . $FasFiles[$i] . ' >> ibd_out.txt';
  system($cmd);
}
