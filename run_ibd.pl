#!/usr/bin/perl
use warnings ;
use strict ;
use Parallel::ForkManager;						### this needs to be installed in terminal type 'sudo cpan Parallel::ForkManager' 

my $dir = '/Volumes/data/ID5_V2/' ;				### this would be changed to the directory that holds the fasta files. Any other way of getting this list is fine. 
my @files = `ls $dir` ; 
my $OUTPUT_DIR = 'PATH/TO/OUTPUT/DIR/' ;

foreach ( @files ) { 
	chomp $_ ; 
	print STDERR $_, "\n" ;
}

my $manager = new Parallel::ForkManager( 8 ) ;	### this is the number of simultaneous instances to run of the ibd program on a 12 core machine you would get the best possible results by setting this to 12
foreach my $l1 ( 0..$#files-1 ) {  
	$manager->start and next;
	
	foreach my $l2 ( $l1+1..$#files ) { 
		### have to have the find_ibd_regions executable in teh same directory as this script
		### if you don't care to store the output besides the ibd calls direct the stderr output to /dev/null 
		system ( "./find_ibd_regions -1 ${dir}$files[$l1] -2 ${dir}$files[$l2] -i ${OUTPUT_DIR}/$files[$l1]_$files[$l2]_ibd_data.txt -d ${OUTPUT_DIR}/$files[$l1]_$files[$l2]_pairwise_divergence.txt" );		
	}
	
	$manager->finish;
}
$manager->wait_all_children;

