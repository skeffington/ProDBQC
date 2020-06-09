# ProDBQC
Proteomic database quality control pipeline


When working with non-model organisms it's hard to know how good your protein databases are, but the consequences of bad databases can be low numbers of identifications and inaccurate identifications in proteomic experiments. This tool aims to allow researchers to benchmark their databases, by estimating the proportion of unique spectra that are identified.

It is currently a collection of script to run in conjunction with other publically available software, but I am working on a fully integraded Docker Image. This will also be made available with a GUI via the Cyverse Discovery Environment.

*Step 1*
Choose the data set you wish to assess your database with. Ideally you should repeat the process with several datasets, and you might find you get different results with differenta samples. For example if you isolate a cellular compartment with strange properties in your species of interest, gene models for proteins found there might not be as well predicted as those for conserved, abundant proteins in a total soluble protein extract. Convert the data to mgf format using a tool such as MSConvert.

*Step 2*
Use pepnovo+ to de novo sequnce your mgf file. This can be easily achieved using the GUI version 'de novo GUI'. Use the ion tolerances you would typically use in a database search for data from your instrument. Export the results, setting a minimum pepnovo score of 50. This step removes low quality spectra from the data, and makes data from different organisms and preparation pipelines more comparable.

*Step 3*

