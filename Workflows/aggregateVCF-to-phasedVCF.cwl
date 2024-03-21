#!/usr/bin/env cwl-runner

class: Workflow
id: aggregateVCF-to-phasedVCF
label: aggregateVCF-to-phasedVCF
cwlVersion: v1.1

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}

inputs:
  samples_file:
    type: File
    doc: File of samples to include (or exclude with "^" prefix)

  input_vcf:
    type: File
    doc: input VCF file

  prefix:
    type: string
    doc: Output file prefix

  gt_missingness_rate:
    type: float
    doc: cut-off of GT missingness rate

  hwe:
    type: float
    doc: cut-off of HWE

  mac:
    type: int
    doc: cut-off of MAC

  map:
    type: File
    doc: Genetic map file

  region:
    type: string

  beagle_java_options:
    type: string?
    default: -Xmx450g

  beagle_nthreads:
    type: int
    default: 64

  _remove_tags:
    type: string[]
    default: ["^INFO/AC", "^INFO/AN"]

  _fill_tags:
    type: string[]
    default: ["AN", "AC", "HWE", "ExcHet", "AF", "MAF", "INFO/MAC=MAC"]


steps:
  stats_input:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: input_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).00_input
    out:
      - stats

  extract_samples:
    run: ../Tools/bcftools-extract-samples.cwl
    in:
      samples_file: samples_file
      input_vcf: input_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).extract_samples
    out:
      - output_vcf

  stats_extract_samples:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: extract_samples/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).01_extract_samples
    out:
      - stats

  remove_tags:
    run: ../Tools/bcftools-remove-annotations.cwl
    in:
      remove: _remove_tags
      input_vcf: extract_samples/output_vcf
      tmpprefix: prefix
      prefix: 
        valueFrom: $(inputs.tmpprefix).remove_tags
    out:
      - output_vcf

  fill_tags:
    run: ../Tools/bcftools-fill-tags.cwl
    in:
      tags: _fill_tags
      input_vcf: remove_tags/output_vcf
      tmpprefix: prefix
      prefix: 
        valueFrom: $(inputs.tmpprefix).fill_tags
    out:
      - output_vcf

  filter_PASS:
    run: ../Tools/bcftools-filter-PASS.cwl
    in:
      input_vcf: fill_tags/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).filter-PASS
    out:
      - output_vcf

  stats_filter_PASS:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: filter_PASS/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).02_filter_PASS
    out:
      - stats

  exclude_multiallelic_sites:
    run: ../Tools/bcftools-exclude-multiallelic-sites.cwl
    in:
      input_vcf: filter_PASS/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).exclude_multiallelic_sites
    out:
      - output_vcf

  stats_exclude_multiallelic_sites:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: exclude_multiallelic_sites/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).03_exclude_multiallelic_sites
    out:
      - stats

  filter_GT_missingness_rate:
    run: ../Tools/bcftools-filter-GT-missingness-rate.cwl
    in:
      input_vcf: exclude_multiallelic_sites/output_vcf
      gt_missingness_rate: gt_missingness_rate
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).filter_GT_missingness_rate
    out:
      - output_vcf

  stats_filter_GT_missingness_rate:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: filter_GT_missingness_rate/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).04_filter_GT_missingness_rate
    out:
      - stats

  filter_HWE:
    run: ../Tools/bcftools-filter-HWE.cwl
    in:
      input_vcf: filter_GT_missingness_rate/output_vcf
      hwe: hwe
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).filter_HWE
    out:
      - output_vcf

  stats_filter_HWE:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: filter_HWE/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).05_filter_HWE
    out:
      - stats

  filter_MAC:
    run: ../Tools/bcftools-filter-MAC.cwl
    in:
      input_vcf: filter_HWE/output_vcf
      mac: mac
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).filter_MAC
    out:
      - output_vcf

  stats_filter_MAC:
    run: ../Tools/bcftools-stats.cwl
    in:
      input_vcf: filter_MAC/output_vcf
      tmpprefix: prefix
      prefix:
        valueFrom: $(inputs.tmpprefix).06_filter_MAC
    out:
      - stats

  beagle_phasing:
    run: ../Tools/beagle-phasing.cwl
    in:
      gt: filter_MAC/output_vcf
      map: map
      region: region
      nthreads: beagle_nthreads
      java_options: beagle_java_options
      tmpprefix: prefix
      outprefix:
        valueFrom: $(inputs.tmpprefix).beagle_phasing
    out:
      - vcf
      - log

  beagle_bref3:
    run: ../Tools/beagle-bref3.cwl
    in:
      vcf: beagle_phasing/vcf
      tmpprefix: prefix
      outprefix:
        valueFrom: $(inputs.tmpprefix).beagle_phasing
    out:
      - bref3


outputs:
  output_vcf:
    type: File
    outputSource: beagle_phasing/vcf
  beagle_phasing_log:
    type: File
    outputSource: beagle_phasing/log
  output_bref3:
    type: File
    outputSource: beagle_bref3/bref3
  stats_00:
    type: File
    outputSource: stats_input/stats
  stats_01:
    type: File
    outputSource: stats_extract_samples/stats
  stats_02:
    type: File
    outputSource: stats_filter_PASS/stats
  stats_03:
    type: File
    outputSource: stats_exclude_multiallelic_sites/stats
  stats_04:
    type: File
    outputSource: stats_filter_GT_missingness_rate/stats
  stats_05:
    type: File
    outputSource: stats_filter_HWE/stats
  stats_06:
    type: File
    outputSource: stats_filter_MAC/stats
