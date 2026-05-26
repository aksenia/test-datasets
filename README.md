# test-datasets: `genomic-medicine-sweden/nallo`

This branch contains test data to be used for automated testing with the [genomic-medicine-sweden/nallo](https://github.com/genomic-medicine-sweden/nallo) pipeline.

All PRs require an approval from someone in the nallodev team before merging,

## Content of this repository

- **reference/**
  - `cadd.v1.6.hg38.test_data.zip`: ZIP file containing CADD v1.6 in hg38 reference for test data
  - `cnv.excluded_regions.hg38.bed.gz`: Gzipped BED file containing excluded regions for CNV analysis in hg38 reference
  - `empty.bed`: BED file with no content
  - `expected_cn.hg38.XX.bed`: BED file containing expected copy number data for hg38 reference (XX chromosomes)
  - `expected_cn.hg38.XY.bed`: BED file containing expected copy number data for hg38 reference (XY chromosomes)
  - `hg38.test.fa.gz`: Gzipped FASTA file containing a subset of the hg38 reference
  - `hs38.PAR.bed`: BED file containing PAR (Pseudo-Autosomal Region) data for hs38 reference
  - `pathogenic_repeats.hg38.bed`: BED file containing pathogenic repeat regions for hg38 reference
  - `test_data.bed`: BED file containing test data
  - `vep_cache_test_data.tar.gz`: Gzipped TAR file containing test data for subset of VEP (Variant Effect Predictor) cache

- **testdata/**
  - `HG002_ONT_UL_dorado0.4.0_sup4.1.0_5mCG_5hmCG.fastq.gz`: Gzipped FASTQ file containing test data subset for HG002 ONT UL dorado0.4.0 sup4.1.0 with 5mCG and 5hmCG modifications
  - `HG002_PacBio_Revio.bam`: BAM file containing Revio test data
  - `HG002_PacBio_Revio.fastq.gz`: Gzipped FASTQ file containing Revio test data
  - `snp_dbs.csv`: CSV file containing paths to SNV annotation database files
  - `paraphrase_rules.yaml`: Example paraphrase rules.
