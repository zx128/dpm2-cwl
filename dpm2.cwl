#!/usr/bin/env cwl-runner

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#
baseCommand: [sh]
arguments:
- -c
#- cat .netrc && 
#  echo "/opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb) 
#  -p min_lat '$(inputs.min_lat)'
#  -p max_lat '$(inputs.max_lat)'
#  -p min_lon '$(inputs.min_lon)'
#  -p max_lon '$(inputs.max_lon)'
#  -p master_date '$(inputs.master_date)'
#  -p start_date '$(inputs.start_date)'
#  -p end_date '$(inputs.end_date)'
#  -p track_number '$(inputs.track_number)'"
#  /opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb) -f $(inputs.parameters.path)
- if [ ! -d $HOME/dpm2 ]; then cp -rp /home/jovyan/dpm2 $HOME; fi &&
  /opt/conda/bin/papermill $(inputs.input_nb) $(inputs.output_nb)
   -p p_int '$(inputs.p_int)'
   -p p_str '$(inputs.p_str)'
hints:
  "cwltool:Secrets":
    secrets:
      - urs_user
      - urs_pass
requirements:
  DockerRequirement:
    dockerPull: hysds1/dpm2:20220221
  #EnvVarRequirement:
  #  envDef:
  #    HOME: /home/jovyan
  InitialWorkDirRequirement:
    listing:
      - entryname: .netrc
        entry: |
          machine urs.earthdata.nasa.gov login $(inputs.urs_user) password $(inputs.urs_pass)
          macdef init
      - entryname: merged_stack
        entry: $(inputs.merged_stack)
        writable: true
  NetworkAccess:
    class: NetworkAccess
    networkAccess: true
  ResourceRequirement:
    class: ResourceRequirement
    coresMin: 8
    # the next 3 are in mebibytes
    ramMin: 64000
    tmpdirMin: 200000
    outdirMin: 100000
inputs:
  urs_user: string
  urs_pass: string
  input_nb: string
  output_nb: string
  p_int: int
  p_float: float
  p_str: string
  merged_stack:
    type: Directory
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: stdout_run_dpm2.txt
stderr: stderr_run_dpm2.txt
