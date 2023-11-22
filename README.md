
<img src="https://github.com/genome-analytics-japan/imputation-server-logo/blob/main/logo_color.png" width=50%>


# The NBDC-DDBJ imputation server workflows
This repository contains the following workflows:
- [Genotype imputation workflow](./Workflows/beagle-imputation-scatter-region.cwl)
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
