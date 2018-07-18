# MatePerformance
This repository contains the experimental setting for assessing the performance of our reflective VMs: [TruffleMATE](https://github.com/charig/TruffleMATE/tree/papers/phdThesis) and [RTruffleMATE](https://github.com/charig/rtrufflemate/tree/papers/phdThesis).

The repository is organized in the following way:

* The [Data](Data) directory contains a compressed file with all the fresh data of our complete last run for the experiments. 
* The [Report](Report) directory contains all the reporting files. They only need a fresh data file to produce all the results. The reporting is based on [R](https://www.r-project.org/) and its [Knitr](https://yihui.name/knitr/) report generation framework.  
* The [Setup](Setup) directory contains the scripts to build all the necessary language implementations. 

Instructions for Running the Experiments
----------------------------------------

To checkout the code:

    git clone -b papers/phdThesis https://github.com/charig/MatePerformance.git directoryName
    cd directoryName
    
To build all the implementations needed for running all the experiments by yourself:

    cd Setup
    ./setup.sh
    
*Note that the experimental setup has many dependencies: git, ant, make, mv, rebench, cc, c++, graalvm, pypy. 
For [Graal](http://www.oracle.com/technetwork/oracle-labs/program-languages/downloads/index.html) and [PyPy](https://pypy.org/download.html), they must be downloaded and then their corresponding downloaded dir set in [config.inc](Setup/buildScripts/config.inc)*

After building, for running the experiments just execute:

    ./runExperiments.sh

Finally, to produce all the images, tables, and data:

    cd ../Report
    ./compile.sh experiments.Rnw

