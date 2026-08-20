# Download somalier sites
wget https://github.com/brentp/somalier/files/3412456/sites.hg38.vcf.gz -O data/sites.hg38.vcf.gz
tabix data/sites.hg38.vcf.gz

# Download CoLoRSdb
wget https://zenodo.org/records/11511513/files/CoLoRSdb.GRCh38.v1.0.0.pbsv.jasmine.vcf.gz -O data/CoLoRSdb.GRCh38.v1.0.0.pbsv.jasmine.vcf.gz
wget https://zenodo.org/records/11511513/files/CoLoRSdb.GRCh38.v1.0.0.pbsv.jasmine.vcf.gz.tbi -O data/CoLoRSdb.GRCh38.v1.0.0.pbsv.jasmine.vcf.gz.tbi

# Download reference genome
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz -O data/GRCh38_no_alt_analysis_set.fasta.gz
gunzip -c data/GRCh38_no_alt_analysis_set.fasta.gz > data/GRCh38_no_alt_analysis_set.fasta

# Download ONT HG002 haplotagged bam
aws s3 cp --no-sign-request s3://ont-open-data/giab_2025.01/analysis/wf-human-variation/hac/HG002/PAW70337/output/SAMPLE.haplotagged.cram HG002_ONT.haplotagged.cram
aws s3 cp --no-sign-request s3://ont-open-data/giab_2025.01/analysis/wf-human-variation/hac/HG002/PAW70337/output/SAMPLE.haplotagged.cram HG002_ONT.haplotagged.cram.crai

# Add aligned PacBio HG002, HG003, HG004 manually, from Nallo run, as
# data/HG002_aligned_haplotagged.bam (m84011_220902_175841_s1.hifi_reads.bam)
# data/HG003_aligned_haplotagged.bam (m84010_220919_235306_s2.hifi_reads.bam)
# data/HG004_aligned_haplotagged.bam (m84010_220919_232145_s1.hifi_reads.bam)
# data/HG002_aligned_haplotagged.bam.bai
# data/HG003_aligned_haplotagged.bam.bai
# data/HG004_aligned_haplotagged.bam.bai

# Download VEP cache
wget https://ftp.ensembl.org/pub/release-116/variation/indexed_vep_cache/homo_sapiens_vep_116_GRCh38.tar.gz -O data/homo_sapiens_vep_116_GRCh38.tar.gz

# Download gnomad
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chr16.vcf.bgz -O data/gnomad.genomes.v4.1.sites.chr16.vcf.bgz
wget https://storage.googleapis.com/gcp-public-data--gnomad/release/4.1/vcf/genomes/gnomad.genomes.v4.1.sites.chrX.vcf.bgz -O data/gnomad.genomes.v4.1.sites.chrX.vcf.bgz
tabix -@ 36 data/gnomad.genomes.v4.1.sites.chr16.vcf.bgz
tabix -@ 36 data/gnomad.genomes.v4.1.sites.chrX.vcf.bgz
