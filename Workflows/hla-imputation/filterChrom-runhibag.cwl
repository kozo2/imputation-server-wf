cwlVersion: v1.0
class: Workflow
# for filterchrom
inputs:
  - id: in_bed
    type: File
    secondaryFiles:
      - ^.bim
      - ^.fam
  - id: in_chromosome_number
    type: string
  - id: filter_chrom_out_name
    type: string
# for runhibag
  - id: out_name
    type: string
  - id: in_modelfile
    type: File

outputs:
  hibag_out:
    type: File[]
    outputSource: runhibag/hibag_out
  hibag_log:
    type: File[]
    outputSource: runhibag/hibag_log

steps:
  filterchrom:
    run: plinkChromosomeFilter.cwl
    in:
      in_bed: in_bed
      in_chromosome_number: in_chromosome_number
      out_name: filter_chrom_out_name
    out: [vcf_out]

  runhibag:
    run: runhibag.cwl
    in:
      in_bed: filterchrom/vcf_out
      out_name: out_name
      in_modelfile: in_modelfile
    out: [hibag_out, hibag_log]
