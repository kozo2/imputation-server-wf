# HLA imputation workflow

This workflow executes HLA Genotype Imputation workflows using [HIBAG](https://bioconductor.org/packages/release/bioc/html/HIBAG.html).

## Dependencies

- cwltool
- Docker or Singularity

## Setting up CWL files

```
$ git clone https://github.com/ddbj/imputation-server-wf
$ mkdir hla_imputation_workflow
$ cd hla_imputation_workflow
$ cp ./imputation-server-wf/Workflows/hla-imputation/filterChrom-runhibag.cwl ./hla_imputation_workflow/
$ cp ./imputation-server-wf/Workflows/hla-imputation/plinkChromosomeFilter.cwl ./hla_imputation_workflow/
$ cp ./imputation-server-wf/Workflows/hla-imputation/runhibag.cwl ./hla_imputation_workflow/
```

## Getting HIBAG model files

The HIBAG model file (.RData file) used by the HLA imputation server can be obtained from https://hibag.s3.amazonaws.com/hlares_index.html .
There are many HIBAG prediction models specific to genotyping platforms that have been made publicly available.
One of those model files can be obtained in your local directory as follows.

```
$ wget https://hibag.s3.amazonaws.com/download/HLARES/HumanOmni2.5-Asian-HLA4-hg19.RData
$ mv HumanOmni2.5-Asian-HLA4-hg19.RData ./hla_imputation_workflow/
```

## Running HLA imputation workflow

To run HLA imputation workflow, in addition to the aforementioned CWL files and HIBAG model file,
PLINK files (bed, bim, fam) are also required.
A sample of the PLINK files can be obtained as follows.

```
$ wget https://zenodo.org/api/records/10579034/files-archive
$ mv files-archive data.zip
$ unzip data.zip
$ ls 1KG*
1KG.JPT.bed  1KG.JPT.bim  1KG.JPT.fam

$ mv 1KG* ./hla_imputation_workflow/
```

Next, create a job file for `cwltool` command under the directory `./hla_imputation_workflow` as follows.
Here, we will save the job file as `job.yml`.

```
in_bed:
  class: File
  path: ./1KG.JPT.bed
in_chromosome_number: "6"
filter_chrom_out_name: "test_chrom6"
out_name: "testout"
in_modelfile:
  class: File
  path: ./HumanOmni2.5-Asian-HLA4-hg19.RData
```

In the end, `cd` to `hla_imputation_workflow` directory and execute the `cwltool` command to run the HLA imputation workflow.

```
$ cd ./hla_imputation_workflow
$ # In case of using Docker
$ cwltool filterChrom-runhibag.cwl job.yml
$ # In case of using Singularity
$ # cwltool --singularity filterChrom-runhibag.cwl job.yml
```

## The output files of the workflow

After executing the aforementioned `cwltool` command,
the imputation result for each seven HLA types (A, B, C, DPB1, DQA1, DQB1, DRB1) will be output as tab-separated .txt files prefixed with the value specified by the `out_name` key in the `job.yml` file.

```
$ ls testout_*
testout_HLAtype_A.txt  testout_HLAtype_B.txt  testout_HLAtype_C.txt  testout_HLAtype_DPB1.txt  testout_HLAtype_DQA1.txt  testout_HLAtype_DQB1.txt  testout_HLAtype_DRB1.txt
```

```
$ head testout_HLAtype_DPB1.txt
sample.id	allele1	allele2	prob	matching
TEST_NA18939	02:01	05:01	0.937311493471671	0.00487707061828105
TEST_NA18940	02:01	04:02	0.873745928871509	0.000535270826977663
TEST_NA18941	05:01	05:01	0.984670563843337	0.010013967083308
TEST_NA18942	05:01	05:01	0.975494861001102	0.00776541213187363
TEST_NA18943	02:01	05:01	0.951212372668975	0.00513960569306974
TEST_NA18944	02:01	05:01	0.964456372385099	0.00661156496859131
TEST_NA18945	02:01	05:01	0.968827639355896	0.004009182177215
TEST_NA18946	04:02	05:01	0.824115422668776	0.00251995925483433
TEST_NA18947	09:01	09:01	0.992542036272476	0.000113868381664084
```
