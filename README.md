# The NBDC-DDBJ imputation server workflows
This repository contains the following workflows:
- [Genotype imputation workflow](./Workflows/beagle-imputation-scatter-region.cwl)
- [Imputation reference panel construction workflow](./Workflows/aggregateVCF-to-phasedVCF.cwl)
- [File format conversion workflow (PLINK to VCF)](./Tools/plink2vcf.cwl)
- [File format conversion workflow (binary-PLINK to VCF)](./Tools/bplink2vcf.cwl)

## Genotype imputation workflow

### Inputs of this workflow
The workflow for the genotype imputation takes two genotype datasets as inputs. The first is an experimentally observed genotype dataset (referred to as target dataset), and the second is a reference panel genotype dataset. Our workflow assumes that both genotype datasets are stored in the variant call format (VCF). We recommend users to apply quality control (QC) steps, such as missing call rate and Hardy-Weinberg equilibrium filters, to the target dataset before using this workflow. Regarding non-pseudoautosomal region on the X chromosome, this workflow assumes that male haploid genotypes are coded as “homozygous diploid”, and that the male “homozygous diploid” and female heterozygous diploid genotypes are recoded in a single unphased VCF file, according to an existing imputation workflow (https://www.protocols.io/view/genotype-imputation-workflow-v3-0-e6nvw78dlmkj/v2).

There are 2 mandatory input files.

| Input name | Content  |
|---|---|
| gt  | Target genotype dataset (a VCF file)  |
| region_list  | Reference panel dataset (a config file that defines chunks and specifies paths to reference panel dataset (VCF and BREF3 files) |

There are 2 optional input parameters.

| Input name | Content  |
|---|---|
| gp  | Whether the posterior probability of possible genotypes is included in the output file (default is false)  |
| nthreads  |  Number of threads (default value of 16)  |

### Steps of this workflow

| Step name | Content  |
|---|---|
| conform-gt | The first step of the workflow detects polymorphic markers shared between the target and reference datasets using the conform-gt program (version 24May16) |
| beagle-imputation | The second step performs pre-phasing and genotype imputation using the beagle program version 5.2 (21Apr21.304) |
| beagle-vcf-index | The third step calculates the index for the imputed genotype files using bcftools (version 1.9) |

The workflow assumes that pre-phasing and genotype imputation were performed using the same reference panel dataset. These three steps can be executed in parallel by splitting genomic regions into chunks. The definition of chunks is configurable by editing a text file, whereas default configurations define a chunk for each whole chromosome.

### Outputs of this workflow
The output of the workflow includes the VCF files and their index files (TBI format). The VCF file contains the expected number of non-reference alleles (referred to as allele dosage) in the DS tag. Estimated allele frequencies and imputation qualities are recorded in the INFO column of the VCF files. 

| Output name | Content  |
|---|---|
| conform-gt-vcf | Results of the step 1 (a VCF file per chunk) |
| conform-gt-log | Log of the step 1 (a text file per chunk) |
| beagle-vcf | Results of the step 2 (a VCF file per chunk) |
| beagle-log | Log of the step 2 (a text file per chunk) |
| beagle-tbi | Results of the step 3 (a TBI index file per chunk) |

## Imputation reference panel construction workflow
This workflow constructs an imputation reference panel (phased VCF file) from an aggregate (unphased) VCF file.

The workflow applies the following variant filtering:
- FILTER (column in the VCF) = PASS
- bi-allelic sites (remove multi-allelic sites)
- GT missingness rate (e.g., <5%)
- HWE exact test p value (e.g, > 1e-10)
- minor allele count (MAC) (e.g, ≥ 2)

After variant filtering, phasing was performed using Beagle 5.2, followed by the convertion of the phased VCF file to a BREF3 file. 


### Inputs of this workflow
There are 7 mandatory input files.

| Input name | Content  |
|---|---|
| input_vcf  | Input aggregate (unphased) VCF file |
| samples_file | File of samples to include |
| gt_missingness_rate | Cut-off of GT missingness rate |
| hwe | Cut-off of HWE exact test p value |
| mac | Cut-off of minor allele count |
| map | Genetic map file (download from [here](https://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/)) |
| region | Chromosomal region |

There are 1 optional input parameter.

| Input name | Content  |
|---|---|
| beagle_nthreads |  Number of threads for phasing (default value of 64)  |


### Steps of this workflow

| Step name | Content  |
|---|---|
| stats_input | Calculate stats of the input VCF file (bcftools v1.18) |
| extract_samples | Extract genotype data of target samples (bcftools v1.18) |
| stats_extract_samples | Calculate stats of the VCF file after extracting target samples (bcftools v1.18) |
| remove_tags | Remove INFO tags except for INFO/AN and INFO/AC (bcftools v1.18) |
| fill_tags | Calculate INFO/AN, INFO/AC, INFO/HWE, INFO/ExcHet, INFO/AF, INFO/MAF, and INFO/MAC (bcftools v1.18) |
| filter_PASS | Exclude variants where FILTER (column in the VCF) is not 'PASS' (bcftools v1.18) |
| stats_filter_PASS | Calculate stats of the VCF file after excluding variants where FILTER (column in the VCF) is not 'PASS' (bcftools v1.18) |
| exclude_multiallelic_sites | Exclude multi-allelic variants (bcftools v1.18) |
| stats_exclude_multiallelic_sites | Calculate stats of the VCF file after excluding multi-allelic variants (bcftools v1.18) |
| filter_GT_missingness_rate | Exclude variants with low GT missingness rate (bcftools v1.18) |
| stats_filter_GT_missingness_rate | Calculate stats of the VCF file after excluding variants with low GT missingness rate (bcftools v1.18) |
| filter_HWE | Exclude variants with low HWE exact P-value (bcftools v1.18) |
| stats_filter_HWE | Calculate stats of the VCF file after excluding variants with low HWE exact P-value (bcftools v1.18) |
| filter_MAC | Exclude variants with low MAC (bcftools v1.18) |
| stats_filter_MAC | Calculate stats of the VCF file after excluding variants with low MAC (bcftools v1.18) |
| beagle_phasing | Haplotype phasing using Beagle version 5.2 (21Apr21.304) |
| beagle_bref3 | Convert the phased VCF to BREF3 using bref3 (version 28Jun21.220) |

### Outputs of this workflow
The output of the workflow includes the phased VCF and BREF3 files, which can be used in the genotype imputation workflow as described above. 

| Output name | Content  |
|---|---|
| output_vcf | A phased VCF file |
| beagle_phasing_log | A log file of haplotype phasing |
| output_bref3 | A phased BREF3 file |
| stats_00 | A file containing stats of the input VCF file |
| stats_01 | A file containing stats of the VCF file after extracting target samples |
| stats_02 | A file containing stats of the VCF file after excluding variants where FILTER (column in the VCF) is not 'PASS' |
| stats_03 | A file containing stats of the VCF file after excluding multi-allelic variants |
| stats_04 | A file containing stats of the VCF file after excluding variants with low GT missingness rate |
| stats_05 | A file containing stats of the VCF file after excluding variants with low HWE exact P-value |
| stats_06 | A file containing stats of the VCF file after excluding variants with low MAC |


## File format conversion workflow (PLINK to VCF)
### Inputs of this workflow

This workflow converts PLINK file to VCF file.

There are 2 mandatory inputs.

| Input name | Content  |
|---|---|
| in_ped  | Target PLINK (PED) file path |
| out_name | Output VCF file name |


## File format conversion workflow (binary-PLINK to VCF)
### Inputs of this workflow

This workflow converts binary-PLINK file to VCF file.

There are 2 mandatory inputs.

| Input name | Content  |
|---|---|
| in_bed  | Target binary-PLINK (BED) file path |
| out_name | Output VCF file name |
