#!/usr/bin/env cwl-runner

class: Workflow
id: beagle-imputation-per-region
label: beagle-imputation-per-region
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

inputs:
  ref_vcf:
    type: File
    doc: Reference VCF file

  ref_bref3:
    type: File
    doc: Reference file

  map:
    type: File
    doc: Genetic map file

  gt:
    type: File
    doc: Target VCF file

  region:
    type: string
    doc: Target region (<chrom> or <chrom>:<start>-<end>)

  conform-gt-prefix:
    type: string
    doc: Output prefix for conform-gt

  beagle-prefix:
    type: string
    doc: Output prefix for beagle

  gp:
    type: string
    doc: A flag controling whether output genotype probability
    default: true

  nthreads:
    type: int
    doc: Number of threads
    default: 16


steps:
  conform-gt:
    label: conform-gt
    run: ../Tools/conform-gt.cwl
    in:
      ref: ref_vcf
      gt: gt
      region: region
      outprefix: conform-gt-prefix
    out: [vcf, log]

  beagle-imputation:
    label: beagle-imputation
    run: ../Tools/beagle-imputation.cwl
    in: 
      ref: ref_bref3
      gt: conform-gt/vcf
      map: map
      region: region
      gp: gp
      nthreads: nthreads
      outprefix: beagle-prefix
    out: [vcf, log]

  beagle-vcf-index: 
    label: beagle-vcf-index
    run: ../Tools/bcftools-index-t.cwl
    in: 
      vcf: beagle-imputation/vcf
    out: [tbi]

outputs:
  # conform-gt
  conform-gt-vcf:
    type: File
    outputSource: conform-gt/vcf
  conform-gt-log:
    type: File
    outputSource: conform-gt/log

  # beagle-imputation
  beagle-vcf:
    type: File
    outputSource: beagle-imputation/vcf
  beagle-log:
    type: File
    outputSource: beagle-imputation/log

  # beagle-vcf-index
  beagle-tbi:
    type: File
    outputSource: beagle-vcf-index/tbi

