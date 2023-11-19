class: CommandLineTool
cwlVersion: v1.0
baseCommand: plink
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/plink:1.90b6.21--h516909a_0
arguments:
  - --bfile
  - $(inputs.in_bed.dirname)/$(inputs.in_bed.nameroot)
  - --chr
  - $(inputs.in_chromosome_number)
  - --make-bed
  - --out
  - $(inputs.out_name)
inputs:
  - id: in_bed
    type: File
    secondaryFiles:
      - ^.bim
      - ^.fam
  - id: in_chromosome_number
    type: string
  - id: out_name
    type: string
outputs:
  vcf_out:
    type: File
    secondaryFiles:
      - ^.log
      - ^.bim
      - ^.fam
    outputBinding:
      glob: "$(inputs.out_name).bed"
