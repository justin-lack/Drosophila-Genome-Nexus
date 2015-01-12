#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

#INPUT

my @line = ();
my @Ind_1 = ();
my @Pop1 = ();
my @Ind_2 = ();
my @Pop2 = ();
my @Chr = ();
my @Start = ();
my @Stop = ();
my @Length = ();
my $Input = 'ibd_out.txt';
my $Output = 'ibd_pop_filtered.txt';

open U, "<$Input";
#scalar (<U>);
while (<U>){
  chomp;
  last if m/^$/;
  @line = split;
  if ($line[1] ne '#'){
    push @Pop1, $line[0];
    push @Ind_1, $line[1];
    push @Pop2, $line[2];
    push @Ind_2, $line[3];
    push @Chr, $line[4];
    push @Start, $line[5];
    push @Stop, $line[6];
    push @Length, $line[7];
#    print "$line[0]\n";
  }
}
close U;

my $l = 0;
open G, ">$Output";
for ($l = 0; $l < @Chr; $l++){
  if ($Pop1[$l] eq $Pop2[$l]){
    print G "$Ind_1[$l]\t$Pop1[$l]\t$Ind_2[$l]\t$Pop2[$l]\t$Chr[$l]\t$Start[$l]\t$Stop[$l]\t$Length[$l]\t$Ind_1[$l]" . '_' . "$Ind_2[$l]\n";
  }
}
