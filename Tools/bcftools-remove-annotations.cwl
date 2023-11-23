#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-remove-annotations
label: bcftools-remove-annotations
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bcftools:1.18--h8b25389_0
  ShellCommandRequirement: {}

baseCommand: [ bcftools, annotate, -Oz ]

inputs:
  remove:
    type: string[]
    doc: List of annotations (e.g. ID,INFO/DP,FORMAT/DP,FILTER) to remove (or keep with "^" prefix)
    inputBinding: 
      position: 2
      prefix: --remove
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