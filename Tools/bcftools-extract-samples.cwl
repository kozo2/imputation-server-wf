#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-extract-samples
label: bcftools-extract-samples
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bcftools:1.18--h8b25389_0
  ShellCommandRequirement: {}

baseCommand: [ bcftools, view, -Oz ]

inputs:
  samples_file:
    type: File
    doc: File of samples to include (or exclude with "^" prefix)
    inputBinding:
      prefix: --samples-file     
      position: 2

  input_vcf:
    type: File
    doc: input VCF file
    inputBinding:
      position: 3

  prefix:
    type: string
    doc: Output file prefix

outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: $(inputs.prefix).vcf.gz

arguments:
  - position: 1
    prefix: -o
    valueFrom: $(inputs.prefix).vcf.gz