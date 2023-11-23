#!/usr/bin/env cwl-runner

class: CommandLineTool
id: beagle-phasing
label: beagle-phasing
cwlVersion: v1.1

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  DockerRequirement:
    dockerPull: ghcr.io/ddbj/beagle-5.2:1.1.0
    
baseCommand: [ java ]

inputs:

  java_options:
    type: string?
    default: -Xmx450g
    inputBinding:
      position: 1
      shellQuote: false

  gt:
    type: File
    doc: Target VCF file
    inputBinding:
      prefix: gt=
      separate: false
      position: 5

  map:
    type: File
    doc: Genetic map file
    inputBinding:
      prefix: map=
      separate: false
      position: 6

  region:
    type: string
    inputBinding:
      prefix: chrom=
      separate: false
      position: 7

  nthreads:
    type: int
    default: 64
    inputBinding:
      prefix: nthreads=
      separate: false
      position: 10

  outprefix:
    type: string
    inputBinding:
      prefix: out=
      separate: false
      position: 11

outputs:
  - id: vcf
    type: File
    outputBinding:
      glob: $(inputs.outprefix).vcf.gz
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.outprefix).log

arguments:
  - position: 2
    prefix: -jar
    valueFrom: /usr/local/share/beagle-5.2_21Apr21.304-0/beagle.jar
  - position: 8
    prefix: impute=
    separate: false
    valueFrom: "false"
