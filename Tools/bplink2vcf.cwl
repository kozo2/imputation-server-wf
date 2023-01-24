class: CommandLineTool
cwlVersion: v1.0
baseCommand: plink
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/plink:1.90b6.21--h516909a_0
arguments:
  - --maf
  - "0.001"
  - --allow-extra-chr
  - --recode
  - vcf-iid
  - --bfile
  - $(inputs.in_bed.dirname)/$(inputs.in_bed.nameroot)
  - --out
  - $(inputs.out_name)
  - --biallelic-only
  - strict
  - --keep-allele-order
inputs:
  - id: in_bed
    type: File
    secondaryFiles:
      - ^.bim
      - ^.fam
  - id: out_name
    type: string
outputs:
  vcf_out:
    type: File
    secondaryFiles:
      - ^.log
    outputBinding:
      glob: "$(inputs.out_name).vcf"
