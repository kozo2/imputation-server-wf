#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-exclude-multiallelic-sites
label: bcftools-exclude-multiallelic-sites
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bcftools:1.18--h8b25389_0
  ShellCommandRequirement: {}

baseCommand: [ bcftools, filter, -Oz, --exclude, COUNT(ALT)>1 ]

inputs:
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
