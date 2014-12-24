#!/usr/bin/perl -w
use strict;

#Assumes the bwa and samtools executables have been copied to your system path
#This pipeline assumes all barcodes have been trimmed off of the fastq reads. If barcodes are still present, simply add the '-B 6' (the 6 should be the length of your barcodes) option to the bwa aln command (lines 38 and 40).

my $i = 0;
my $g = 0;
my $cmd = "";
my $mem = 8; #Memory (in gigabytes) allocated to GATK and Picard

my $reference = 'DmelRef'; #Name of reference genome fasta file. File must have the .fasta extension, but leave the file extension off here. If this file is not in the same directory as this script and the fastq read files, then this variable should contain the path to the reference

my $stampy = '/Users/stampy-1.0.21/'; #Path to stampy.py script

my $gatk = '/Users/GenomeAnalysisTK-3.2-2/'; #Path to GenomeAnalysisTK.jar

my $picard = '/Users/picard-tools-1.79/'; #Path to all Picard java modules, which should all be in a single folder

my @FastqFile = ('SRR189073'); #Array of input file names; this script is designed to handle only paired end read files from a single lane. The unique identifier (i.e., SRR306632 for a pair of reads downloaded from the SRA) for each sample file name should be followed by "_1.fastq" or "_2.fastq" (i.e., SRR306632_1.fastq).

#Uncomment next 10 lines if reference genome has not been indexed for BWA, Stampy, or GATK.

#$cmd = "bwa index -a bwtsw " . $reference . ".fasta";
#system($cmd);
#$cmd = "java -Xmx" . $mem . "g -jar " . $picard . "CreateSequenceDictionary.jar REFERENCE=" . $reference . ".fasta OUTPUT=" . $reference . ".dict";
#system($cmd);
#$cmd = "samtools faidx " . $reference . ".fasta";
#system($cmd);
#$cmd = "python2.6 " . $stampy . "stampy.py -G " . $reference . " " . $reference . ".fasta";
#system($cmd);
#$cmd = "python2.6 " . $stampy . "stampy.py -g " . $reference . " -H " . $reference;
#system($cmd);

#Assembly commands

for ($i = 0; $i < @FastqFile; $i++){
  $cmd = "bwa aln " . $reference . ".fasta " . $FastqFile[$i] . "_1.fastq > " . $FastqFile[$i] . "_1.sai";
  system($cmd);
  $cmd = "bwa aln " . $reference . ".fasta " . $FastqFile[$i] . "_2.fastq > " . $FastqFile[$i] . "_2.sai";
  system($cmd);
  $cmd = "bwa sampe -P " . $reference . ".fasta " . $FastqFile[$i] . "_1.sai " . $FastqFile[$i] . "_2.sai " . $FastqFile[$i] . "_1.fastq " . $FastqFile[$i] . "_2.fastq > " . $FastqFile[$i] . ".sam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_1.sai";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_2.sai";
  system($cmd);
  $cmd = "samtools view -bS " . $FastqFile[$i] . ".sam > " . $FastqFile[$i] . ".bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . ".sam";
  system($cmd);
  $cmd = "python2.6 " . $stampy . "stampy.py -g " . $reference . " -h " . $reference . " --bamkeepgoodreads -M " . $FastqFile[$i] . ".bam -o " . $FastqFile[$i] . "_remapped.sam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . ".bam";
  system($cmd);
  $cmd = "samtools view -bS -q 20 " . $FastqFile[$i] . "_remapped.sam > " . $FastqFile[$i] . "_remapped.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_remapped.sam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "CleanSam.jar INPUT=" . $FastqFile[$i] . "_remapped.bam OUTPUT= " . $FastqFile[$i] . "clean.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_remapped.bam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "SortSam.jar SORT_ORDER=coordinate INPUT=" . $FastqFile[$i] . "clean.bam OUTPUT=" . $FastqFile[$i] . "sort.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "clean.bam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "MarkDuplicates.jar INPUT=" . $FastqFile[$i] . "sort.bam OUTPUT=" . $FastqFile[$i] . "dups.bam METRICS_FILE=" . $FastqFile[$i] . "dups.metrics";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "sort.bam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "AddOrReplaceReadGroups.jar RGLB=Lane1 RGPL=Illumina RGPU=TTAGGC RGSM=" . $FastqFile[$i] . " INPUT=" . $FastqFile[$i] . "dups.bam OUTPUT=" . $FastqFile[$i] . "header.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "dups.bam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "BuildBamIndex.jar INPUT=" . $FastqFile[$i] . "header.bam";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T RealignerTargetCreator -R " . $reference . ".fasta -I " . $FastqFile[$i] . "header.bam -o " . $FastqFile[$i] . ".intervals";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T IndelRealigner -R " . $reference . ".fasta -targetIntervals " . $FastqFile[$i] . ".intervals -I " . $FastqFile[$i] . "header.bam -o " . $FastqFile[$i] . "realign.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "header.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . ".intervals";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T UnifiedGenotyper -R " . $reference . ".fasta -mbq 10 -stand_call_conf 31 -stand_emit_conf 31 -ploidy 1 -I " . $FastqFile[$i] . "realign.bam -o " . $FastqFile[$i] . "_round1_SNPs.vcf";
  system($cmd);
$cmd = "rm " . $FastqFile[$i] . "_round1_SNPs.vcf.idx";
system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T UnifiedGenotyper -R " . $reference . ".fasta -mbq 10 -stand_call_conf 31 -stand_emit_conf 31 -ploidy 1 -minIndelFrac 0.51 -minIndelCnt 3 -glm INDEL -I " . $FastqFile[$i] . "realign.bam -o " . $FastqFile[$i] . "_INDELS.vcf";
  system($cmd);
  }
  
$cmd = "perl VCF_filter.pl";
system($cmd);
  
  for ($g = 0; $g < @FastqFile; $g++){
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R " . $reference . ".fasta -V " . $FastqFile[$g] . "_SNPs_filtered.vcf -o " . $FastqFile[$g] . "_SNPs_reference.fasta";
  system($cmd);
  $cmd = "samtools faidx " . $FastqFile[$g] . "_SNPs_reference.fasta";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "CreateSequenceDictionary.jar REFERENCE=" . $FastqFile[$g] . "_SNPs_reference.fasta OUTPUT=" . $FastqFile[$g] . "_SNPs_reference.dict";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T FastaAlternateReferenceMaker -R " . $FastqFile[$g] . "_SNPs_reference.fasta -V " . $FastqFile[$g] . "_INDELS.vcf -o " . $FastqFile[$g] . "_reference.fasta";
  system($cmd);
}
