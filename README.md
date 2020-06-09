# ProDBQC
Proteomic database quality control pipeline


When working with non-model organisms it's hard to know how good your protein databases are, but the consequences of bad databases can be low numbers of identifications and inaccurate identifications in proteomic experiments. This tool aims to allow researchers to benchmark their databases, by estimating the proportion of unique spectra that are identified. 

It is currently a collection of script to run in conjunction with other publically available software, but I am working on a fully integraded Docker Image. This will also be made available with a GUI via the Cyverse Discovery Environment.

**Step 1**  
Choose the data set you wish to assess your database with. Ideally you should repeat the process with several datasets, and you might find you get different results with differenta samples. For example if you isolate a cellular compartment with strange properties in your species of interest, gene models for proteins found there might not be as well predicted as those for conserved, abundant proteins in a total soluble protein extract. Convert the data to mgf format using a tool such as MSConvert. we'll call it 'input.mgf'.

**Step 2**  
Use pepnovo+ to de novo sequnce your mgf file. This can be easily achieved using the GUI version 'de novo GUI'. Use the ion tolerances you would typically use in a database search for data from your instrument. Export the results, setting a minimum pepnovo score of 50. This step removes low quality spectra from the data, and makes data from different organisms and preparation pipelines more comparable.

**Step 3**  
Extrat a list of names for the high quality spectra you exported. This is effectively just taking the second column of the output. You can do it in excel, or with a regular expression in a text editor such as Notepad++ (eg Find: ^[^\t]*\t([^\t]*)\t.*  Replace with: $1). Save the list as a new file (HQ_ids.txt). Make sure the line endings in the file are appropriate for the operating system where you are going to use the scripts (eg. if moving from a windows machine to run the scripts on a linux machine, change the line endings. This can also be done in Notepad++).

**Step 4**  
Make a new mgf file containing the high quality spectra only. Use the script 'HQextract.pl' to do this:

```
Perl HQextract.pl HQ_ids.txt input.mgf HQ.mgf 2
```

2 is the mode of the program. In mode 2 it will extract spectra in the ID list. In mode 1 it will extract spectra not in the ID list.

**Step 5**
Cluster the spectra. Spectra from the same peptide are likely represented multiple times in your data. 
Use  this method for clustering: https://github.com/spectra-cluster/spectra-cluster-cli
After unpacking the zip file, run as follows with your data:

```
java -jar ./spectra-cluster-cli-1.1.2-bin/spectra-cluster-cli-1.1.2.jar -filter immonium_ions -output_path ./HQ_clusters HQ.mgf
```

**Step 6**
Extract one spectra from each cluster and make a new mgf file. Use the provided perl script to get the IDs of the clusters you want:

```
perl -S extract1spec_cluster.pl HQ_clusters HQ_cluster_ids.txt
```

And this script again to make the new mgf file, which should now contain a non-redundant set of high quality spectra:

```
Perl HQextract.pl HQ_cluster_ids.txt input.mgf HQ_nr.mgf 2
```

**Step7**
Analyse with your favourite search engine using your database of interest. It could be Mascot, MSGF+, MaxQuant, Comet or others. In the output of the search you can find the proportion of the input spectra that were identified. Good databases generally allow you to identify over 70% of the spectra prepared in this way. Ideally you should develop your own benchmarks relevent for your data. 

There are of course various reasons why high quality spectra might no be identified, the most prominent being modifications not included in your search paramters. Thus you can also use this method to tune your search parameters to maximise peptide and PTM identifications. 

