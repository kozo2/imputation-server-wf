#!/usr/bin/env cwl-runner

class: Workflow
id: beagle-imputation-per-region
label: beagle-imputation-per-region
cwlVersion: v1.1

requirements:
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

$namespaces:
  edam: http://edamontology.org/

inputs:
  gt:
    type: File
    doc: Target VCF file

  gp:
    type: string
    doc: A flag controling whether output genotype probability (true or false)
    default: true

  nthreads:
    type: int
    doc: Number of threads
    default: 16

  region_list:
    type:
      type: array
      items:
        - type: record
          fields:
            region:
              type: string
              doc: Target region (<chrom> or <chrom>:<start>-<end>)
            ref_vcf:
              type: File
              doc: Reference VCF file
            ref_bref3:
              type: File
              doc: Reference BREF3 file
            map:
              type: File
              doc: Genetic map file
            conform_gt_prefix:
              type: string
              doc: Output prefix for conform-gt
            beagle_prefix:
              type: string
              doc: Output prefix for beagle

steps:
  per-region:
    label: beagle-imputation-per-region
    run: beagle-imputation-per-region.cwl
    in:
      gt: gt
      region_list: region_list
      ref_vcf: 
        valueFrom: $(inputs.region_list.ref_vcf)
      ref_bref3: 
        valueFrom: $(inputs.region_list.ref_bref3)
      map: 
        valueFrom: $(inputs.region_list.map)
      region: 
        valueFrom: $(inputs.region_list.region)
      conform-gt-prefix: 
        valueFrom: $(inputs.region_list.conform_gt_prefix)
      beagle-prefix: 
        valueFrom: $(inputs.region_list.beagle_prefix)
      gp: gp
      nthreads: nthreads
    scatter:
      - region_list
    scatterMethod: dotproduct
    out: [conform-gt-vcf, conform-gt-log, beagle-vcf, beagle-log, beagle-tbi]

outputs:
  # conform-gt
  conform-gt-vcf:
    type: File[]
    outputSource: per-region/conform-gt-vcf
  conform-gt-log:
    type: File[]
    outputSource: per-region/conform-gt-log

  # beagle-imputation
  beagle-vcf:
    type: File[]
    outputSource: per-region/beagle-vcf
  beagle-log:
    type: File[]
    outputSource: per-region/beagle-log

  # beagle-vcf-index
  beagle-tbi:
    type: File[]
    outputSource: per-region/beagle-tbi

