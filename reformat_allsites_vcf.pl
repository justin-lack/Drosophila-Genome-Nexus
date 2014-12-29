#This script repairs the reduced allsites VCF files to original format and makes them able to be analyzed using common VCF tools
#!/usr/bin/perl -w
use strict;
use List::Util 'shuffle';

my $a = 0;
my $cmd = "";
my $ID = '.';
my $FILTER = '.';
my $INFO = 'GT:AD:DP:GQ:MLPSAC:MLPSAF:PL';

my @AllFiles = ();
my @Files = ();

#open directory
opendir DIR, "." or die "couldn't open directory\n";
@AllFiles = readdir(DIR);
closedir DIR;

#find correct input files
for ($a = 0; $a < @AllFiles; $a++){
  if ($AllFiles[$a] =~ m'sites.vcf'){
    push (@Files, (split /_sites/, $AllFiles[$a])[0]);
  }
}

my $Reference = 'RefGenome.idx';

$cmd = "bunzip2 " . $Reference . '.bz2';
system($cmd);

my @RefChrom = ();
my @RefPos = ();
my @RefBase = ();
my $i = 0;

for ($i = 0; $i < @Files; $i++) {
  my $VCFin = '';
  my $VCFout = '';

  $VCFin = $Files[$i] . '_sites.vcf';
  $VCFout = $Files[$i] . '_sites_full.vcf';
  $cmd = "bunzip2 " . $VCFin . '.bz2 ';
  system($cmd);

  open C, ">$VCFout";
  print C '##fileformat=VCFv4.1' . "\n" . '##FILTER=<ID=LowQual,Description="Low quality">' . "\n" . '##FORMAT=<ID=AD,Number=.,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">' . "\n" . '##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth (reads with MQ=255 or with bad mates are filtered)">' . "\n" . '##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">' . "\n" . '##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">' . "\n" . '##FORMAT=<ID=MLPSAC,Number=A,Type=Integer,Description="Maximum likelihood expectation (MLE) for the alternate allele count, in the same order as listed, for each individual sample">' . "\n" . '##FORMAT=<ID=MLPSAF,Number=A,Type=Float,Description="Maximum likelihood expectation (MLE) for the alternate allele fraction, in the same order as listed, for each individual sample">' . "\n" . '##FORMAT=<ID=PL,Number=G,Type=Integer,Description="Normalized, Phred-scaled likelihoods for genotypes as defined in the VCF specification">' . "\n" . '##GATKCommandLine=<ID=UnifiedGenotyper,Version=2.6-4-g3e5ff60,Date="Sun Oct 27 09:28:11 CDT 2013",Epoch=1382884091324,CommandLineOptions="analysis_type=UnifiedGenotyper input_file=['."$Files[$i]" . 'realign.bam] read_buffer_size=null phone_home=AWS gatk_key=null tag=NA read_filter=[] intervals=null excludeIntervals=null interval_set_rule=UNION interval_merging=ALL interval_padding=0 reference_sequence=/Volumes/4_TB_RAID_Set_1/DPGP2 read files/DmelRef.fasta nonDeterministicRandomSeed=false disableDithering=false maxRuntime=-1 maxRuntimeUnits=MINUTES downsampling_type=BY_SAMPLE downsample_to_fraction=null downsample_to_coverage=250 baq=OFF baqGapOpenPenalty=40.0 fix_misencoded_quality_scores=false allow_potentially_misencoded_quality_scores=false useOriginalQualities=false defaultBaseQualities=-1 performanceLog=null BQSR=null quantize_quals=0 disable_indel_quals=false emit_original_quals=false preserve_qscores_less_than=6 globalQScorePrior=-1.0 allow_bqsr_on_reduced_bams_despite_repeated_warnings=false validation_strictness=SILENT remove_program_records=false keep_program_records=false unsafe=null disable_auto_index_creation_and_locking_when_reading_rods=false num_threads=1 num_cpu_threads_per_data_thread=1 num_io_threads=0 monitorThreadEfficiency=false num_bam_file_handles=null read_group_black_list=null pedigree=[] pedigreeString=[] pedigreeValidationType=STRICT allow_intervals_with_unindexed_bam=false generateShadowBCF=false logging_level=INFO log_to_file=null help=false version=false genotype_likelihoods_model=SNP pcr_error_rate=1.0E-4 computeSLOD=false annotateNDA=false pair_hmm_implementation=LOGLESS_CACHING min_base_quality_score=10 max_deletion_fraction=0.05 allSitePLs=false min_indel_count_for_genotyping=5 min_indel_fraction_per_sample=0.25 indelGapContinuationPenalty=10 indelGapOpenPenalty=45 indelHaplotypeSize=80 indelDebug=false ignoreSNPAlleles=false allReadsSP=false ignoreLaneInfo=false reference_sample_calls=(RodBinding name= source=UNBOUND) reference_sample_name=null sample_ploidy=1 min_quality_score=1 max_quality_score=40 site_quality_prior=20 min_power_threshold_for_calling=0.95 min_reference_depth=100 exclude_filtered_reference_sites=false heterozygosity=0.001 indel_heterozygosity=1.25E-4 genotyping_mode=DISCOVERY output_mode=EMIT_VARIANTS_ONLY standard_min_confidence_threshold_for_calling=31.0 standard_min_confidence_threshold_for_emitting=31.0 alleles=(RodBinding name= source=UNBOUND) max_alternate_alleles=6 input_prior=[] contamination_fraction_to_filter=0.05 contamination_fraction_per_sample_file=null p_nonref_model=EXACT_INDEPENDENT exactcallslog=null dbsnp=(RodBinding name= source=UNBOUND) comp=[] out=org.broadinstitute.sting.gatk.io.stubs.VariantContextWriterStub no_cmdline_in_header=org.broadinstitute.sting.gatk.io.stubs.VariantContextWriterStub sites_only=org.broadinstitute.sting.gatk.io.stubs.VariantContextWriterStub bcf=org.broadinstitute.sting.gatk.io.stubs.VariantContextWriterStub debug_file=null metrics_file=null annotation=[] excludeAnnotation=[] filter_reads_with_N_cigar=false filter_mismatching_base_and_quals=false filter_bases_not_stored=false">' . "\n" . '##INFO=<ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes, for each ALT allele, in the same order as listed">' . "\n" . '##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency, for each ALT allele, in the same order as listed">' . "\n" . '##INFO=<ID=AN,Number=1,Type=Integer,Description="Total number of alleles in called genotypes">' . "\n" . '##INFO=<ID=BaseQRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt Vs. Ref base qualities">' . "\n" . '##INFO=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth; some reads may have been filtered">' . "\n" . '##INFO=<ID=DS,Number=0,Type=Flag,Description="Were any of the samples downsampled?">' . "\n" . '##INFO=<ID=Dels,Number=1,Type=Float,Description="Fraction of Reads Containing Spanning Deletions">' . "\n" . '##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fishers exact test to detect strand bias">' . "\n" . '##INFO=<ID=HaplotypeScore,Number=1,Type=Float,Description="Consistency of the site with at most two segregating haplotypes">' . "\n" . '##INFO=<ID=InbreedingCoeff,Number=1,Type=Float,Description="Inbreeding coefficient as estimated from the genotype likelihoods per-sample when compared against the Hardy-Weinberg expectation">' . "\n" . '##INFO=<ID=MLEAC,Number=A,Type=Integer,Description="Maximum likelihood expectation (MLE) for the allele counts (not necessarily the same as the AC), for each ALT allele, in the same order as listed">' . "\n" . '##INFO=<ID=MLEAF,Number=A,Type=Float,Description="Maximum likelihood expectation (MLE) for the allele frequency (not necessarily the same as the AF), for each ALT allele, in the same order as listed">' . "\n" . '##INFO=<ID=MQ,Number=1,Type=Float,Description="RMS Mapping Quality">' . "\n" . '##INFO=<ID=MQ0,Number=1,Type=Integer,Description="Total Mapping Quality Zero Reads">' . "\n" . '##INFO=<ID=MQRankSum,Number=1,Type=Float,Description="Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities">' . "\n" . '##INFO=<ID=QD,Number=1,Type=Float,Description="Variant Confidence/Quality by Depth">' . "\n" . '##INFO=<ID=RPA,Number=.,Type=Integer,Description="Number of times tandem repeat unit is repeated, for each allele (including reference)">' . "\n" . '##INFO=<ID=RU,Number=1,Type=String,Description="Tandem repeat unit (bases)">' . "\n" . '##INFO=<ID=ReadPosRankSum,Number=1,Type=Float,Description="Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias">' . "\n" . '##INFO=<ID=STR,Number=0,Type=Flag,Description="Variant is a short tandem repeat">' . "\n" . '##contig=<ID=1,length=347038>' . "\n" . '##contig=<ID=2,length=19517>' . "\n" . '##contig=<ID=3,length=23011544>' . "\n" . '##contig=<ID=4,length=22422827>' . "\n" . '##contig=<ID=5,length=24543557>' . "\n" . '##contig=<ID=6,length=1351857>' . "\n" . '##contig=<ID=7,length=21146708>' . "\n" . '##contig=<ID=8,length=27905053>' . "\n" . '##contig=<ID=9,length=29004656>' . "\n" . '##contig=<ID=10,length=3288761>' . "\n" . '##contig=<ID=11,length=368872>' . "\n" . '##contig=<ID=12,length=2555491>' . "\n" . '##contig=<ID=13,length=2517507>' . "\n" . '##contig=<ID=14,length=10049037>' . "\n" . '##contig=<ID=15,length=204112>' . "\n" . '##contig=<ID=16,length=1267782>' . "\n" . '##reference=file:///Volumes/4_TB_RAID_Set_1/DPGP2 read files/DmelRef.fasta' . "\n" . '#' . "CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$Files[$i]\n";
          
  my @ref = ();
  my @line = ();
  my $file = '';
  my $spot = 1;

  open U, "<$VCFin";
  open Y, "<$Reference";
  while (<U>){
    @line = ();
    chomp;
    last if m/^$/;
    @line = split;

    @ref = ();
    $file = 'Y';
    $_ = (<$file>);
    chomp;
    last if m/^$/;
    @ref = split(' ', $_);
    if ($line[1] == $ref[1]){
      if ($line[2] eq $ref[2]){
	print C "$line[0]\t$line[1]\t$ID\t$line[2]\t$line[3]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
      }
      else {
	if ($line[3] eq '.') {
	  print C "$line[0]\t$line[1]\t$ID\t$ref[2]\t$line[2]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
	}
	else {
	  print C "$line[0]\t$line[1]\t$ID\t$ref[2]\t$line[3]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
	}
      }
    }
    else {
      while ($line[1] > $ref[1]) {
	$file = 'Y';
	$_ = (<$file>);
	chomp;
	last if m/^$/;
	@ref = split(' ', $_);
      }
      if ($line[2] eq $ref[2]){
	print C "$line[0]\t$line[1]\t$ID\t$line[2]\t$line[3]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
      }
      else {
	if ($line[3] eq '.') {
	  print C "$line[0]\t$line[1]\t$ID\t$ref[2]\t$line[2]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
	}
	else {
	  print C "$line[0]\t$line[1]\t$ID\t$ref[2]\t$line[3]\t$line[4]\t$FILTER\t$line[5]\t$INFO\t$line[6]\n";
	}
      }
    }
  }
  close U;
  close Y;
  close C;
  undef @line;
  undef @ref;
  $cmd = "bzip2 " . $VCFout;
  system($cmd);
  $cmd = "rm " . $VCFin;
  system($cmd);
  $cmd = 'purge';
  system($cmd);
}
$cmd = 'bzip2 ' . $Reference;
system($cmd);
