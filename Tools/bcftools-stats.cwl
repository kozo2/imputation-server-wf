#!/usr/bin/env cwl-runner

class: CommandLineTool
id: bcftools-stats
label: bcftools-stats
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/bcftools:1.18--h8b25389_0
  ShellCommandRequirement: {}

baseCommand: [ bcftools, stats ]

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
  stats:
    type: stdout

stdout: $(inputs.prefix).stats.txt

