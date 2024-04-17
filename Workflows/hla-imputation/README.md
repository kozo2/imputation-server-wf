# HLA imputation workflow

This workflow executes HLA Genotype Imputation workflows using [HIBAG](https://bioconductor.org/packages/release/bioc/html/HIBAG.html).

## Dependencies

- cwltool
- Docker

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



## Running HLA imputation workflow


## The output files of the workflow


