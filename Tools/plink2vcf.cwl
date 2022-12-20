class: CommandLineTool
cwlVersion: v1.0
baseCommand: plink
hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/plink:1.90b6.21--h516909a_0
arguments:
  - --allow-extra-chr
  - --recode
  - vcf-iid
  - --file
  - $(inputs.in_ped.dirname)/$(inputs.in_ped.nameroot)
  - --out
  - $(inputs.out_name)
  - --biallelic-only
  - strict
  - --keep-allele-order
inputs:
  - id: in_ped
    type: File
    secondaryFiles:
      - ^.ped
      - ^.map
  - id: out_name
    type: string
outputs:
  vcf_out:
    type: File
    secondaryFiles:
      - ^.log
    outputBinding:
      glob: "$(inputs.out_name).vcf"
