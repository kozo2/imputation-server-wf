#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-fill-tags
label: bcftools-fill-tags
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bcftools:1.18--h8b25389_0
  ShellCommandRequirement: {}

baseCommand: [ bcftools, +fill-tags, -Oz ]

inputs:
  tags:
    type: string[]
    doc: list of output tags, "all" for all tags
    inputBinding: 
      position: 5
      prefix: --tags
      itemSeparator: ","

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
  - position: 4
    valueFrom: "--"