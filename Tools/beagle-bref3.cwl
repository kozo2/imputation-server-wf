#!/usr/bin/env cwl-runner

class: CommandLineTool
id: beagle-imputation
label: beagle-imputation
cwlVersion: v1.1

$namespaces:
  edam: http://edamontology.org/

requirements:
  DockerRequirement:
    dockerPull: ghcr.io/ddbj/beagle-5.2:1.1.0
    
baseCommand: [ java ]

inputs:

  vcf:
    type: File
    doc: Reference VCF file
    inputBinding:
      position: 3

  outprefix:
    type: string

outputs:
  - id: bref3
    type: stdout

stdout: $(inputs.outprefix).bref3

arguments:
  - position: 2
    prefix: -jar
    valueFrom: /tools/bref3.28Jun21.220.jar
