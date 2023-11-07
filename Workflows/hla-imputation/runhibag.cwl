class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: InlineJavascriptRequirement
baseCommand: ["bash", "/opt/run-hibag.sh"]
hints:
  DockerRequirement:
    dockerPull: kozo2/dockerhibag:latest
arguments:
  - $(inputs.in_bed.dirname+"/"+inputs.in_bed.nameroot)
  - $(inputs.out_name)
  - $(inputs.in_modelfile)
inputs:
  - id: in_bed
    type: File
    secondaryFiles:
      - ^.bim
      - ^.fam
  - id: out_name
    type: string
  - id: in_modelfile
    type: File
outputs:
  hibag_out:
    type: File[]
    outputBinding:
      glob: "$(inputs.out_name)*.txt"
  hibag_log:
    type: File[]
    outputBinding:
      glob: "$(inputs.out_name)*.log"
      