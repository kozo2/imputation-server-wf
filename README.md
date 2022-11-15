# imputation-server-jp

## Workflow Available Imputation Algorithm.

| Program  | Version  |
|---|---|
| conform-gt  | 24May16  |
| Beagle 5.2  | 21Apr21.304  |
| bcftools  | 1.9  |

More workflow detail is [https://sc.ddbj.nig.ac.jp/advanced_guides/imputation_server](https://sc.ddbj.nig.ac.jp/advanced_guides/imputation_server)

## Workflow CWL Definition

[beagle-imputation-scatter-region.cwl](./Workflows/beagle-imputation-scatter-region.cwl)

## Input

The web user interface enables the
 users to specify these parameters graphically.

### Mandatory parameters

There are 2 mandatory input parameters.

| Parameter  | Content  |
|---|---|
| gt  | Target genotype dataset (VCF Format)  |
| region_list  |  Reference panel dataset (Dataset containing phased haplotypes) |

### Optional parameters

There are 2 optional input parameters.

| Parameter  | Content  |
|---|---|
| gp  |  The posterior probability of possible genotypes is included in the output file (default is false)  |
| nthreads  |  Number of threads (default value of 16)  |

## Result

- Generated config file
  - This is used as input parameters for imputation workflow

