This directory contains scripts to create, for each tract, a tract set (DSI 
Studio .trk.gz file) and a tract density image from the seed and ROI images 
created during the manual part of the protocol. The full path and filename of 
the .fib file must be supplied at the command line when each script is run.

We make strong assumptions about the directory structure and the names of 
files. See ../get_dir_names.sh. Also, all seed and ROI filenames must start 
with the short name of the structure, e.g. "bcc". Directory names are the same 
as the long name of the structure, e.g. "body_corpus_callosum". The remaining 
part of the filename which encodes hemisphere L/R and region number 1/2/3/etc 
is specific to each structure. Filename specifications are here: 
https://my.vanderbilt.edu/tractem/getting-started/tutorial/ 

Output is stored in the postproc/STRUCTURE subdirectories under the directory 
where the .fib file is located.

The run_all.sh script shows how different situation-specific subscripts are 
called for each tract in the protocol.
