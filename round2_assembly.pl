#!/usr/bin/perl -w
use strict;

#assumes the bwa and samtools executables have been copied to your system path
#For this second round, each set of fastq read files has its own unique reference genome (produced automatically from the round1_assembly.pl script), and this reference genome must be in the same folder as this script and all the files.
#This pipeline assumes all barcodes have been trimmed off of the fastq reads. If barcodes are still present, simply add the '-B 6' (the 6 should be the length of your barcodes) option to the bwa aln command (lines 34 and 36).

my $i = 0;
my $cmd = "";
my $ploidy = '2'; #set to 1 if haploid, 2 if diploid, etc.

my $mem = 8; #memory (in gigabytes) allocated to GATK and Picard

my $stampy = '/Users/stampy-1.0.21/'; #path to stampy.py script

my $gatk = '/Users/GenomeAnalysisTK-3.2-2/'; #path to GenomeAnalysisTK.jar

my $picard = '/Users/picard-tools-1.79/'; #path to all Picard java modules

my @FastqFile = ('SRR189073'); #array of input file names; this script is designed to handle only paired end read files from a single lane downloaded from the SRA. The sample file name (i.e., SRR306632) would then be followed by "_1.fastq" or "_2.fastq".

#Assembly commands

for ($i = 0; $i < @FastqFile; $i++){
  $cmd = "bwa index -a bwtsw " . $FastqFile[$i] . "_reference.fasta";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $picard . "CreateSequenceDictionary.jar REFERENCE=" . $FastqFile[$i] . "_reference.fasta OUTPUT=" . $FastqFile[$i] . "_reference.dict";
  system($cmd);
  $cmd = "samtools faidx " . $FastqFile[$i] . "_reference.fasta";
  system($cmd);
  $cmd = "python2.6 " . $stampy . "stampy.py -G " . $FastqFile[$i] . "_reference " . $FastqFile[$i] . "_reference.fasta";
  system($cmd);
  $cmd = "python2.6 " . $stampy . "stampy.py -g " . $FastqFile[$i] . "_reference -H " . $FastqFile[$i] . "_reference";
  system($cmd);
  $cmd = "bwa aln " . $FastqFile[$i] . "_reference.fasta " . $FastqFile[$i] . "_1.fastq > " . $FastqFile[$i] . "_1.sai";
  system($cmd);
  $cmd = "bwa aln " . $FastqFile[$i] . "_reference.fasta " . $FastqFile[$i] . "_2.fastq > " . $FastqFile[$i] . "_2.sai";
  system($cmd);
  $cmd = "bwa sampe -P " . $FastqFile[$i] . "_reference.fasta " . $FastqFile[$i] . "_1.sai " . $FastqFile[$i] . "_2.sai " . $FastqFile[$i] . "_1.fastq " . $FastqFile[$i] . "_2.fastq > " . $FastqFile[$i] . ".sam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_1.sai";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "_2.sai";
  system($cmd);
  $cmd = "samtools view -bS " . $FastqFile[$i] . ".sam > " . $FastqFile[$i] . ".bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . ".sam";
  system($cmd);
  $cmd = "python2.6 " . $stampy . "stampy.py -g " . $FastqFile[$i] . "_reference -h " . $FastqFile[$i] . "_reference --bamkeepgoodreads -M " . $FastqFile[$i] . ".bam -o " . $FastqFile[$i] . "_remapped.sam";
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
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T RealignerTargetCreator -R " . $FastqFile[$i] . "_reference.fasta -I " . $FastqFile[$i] . "header.bam -o " . $FastqFile[$i] . ".intervals";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T IndelRealigner -R " . $FastqFile[$i] . "_reference.fasta -targetIntervals " . $FastqFile[$i] . ".intervals -I " . $FastqFile[$i] . "header.bam -o " . $FastqFile[$i] . "realign2.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . "header.bam";
  system($cmd);
  $cmd = "rm " . $FastqFile[$i] . ".intervals";
  system($cmd);
  $cmd = "java -Xmx" . $mem . "g -jar " . $gatk . "GenomeAnalysisTK.jar -T UnifiedGenotyper -R " . $FastqFile[$i] . "_reference.fasta -mbq 10 -stand_call_conf 31 -stand_emit_conf 31 -ploidy " . $ploidy . " -out_mode EMIT_ALL_SITES -I " . $FastqFile[$i] . "realign2.bam -o " . $FastqFile[$i] . "_sites.vcf";
  system($cmd);
  }
