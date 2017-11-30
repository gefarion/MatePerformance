# MatePerformance
This repository contains the experimental setting for assessing the performance of reflective VMs.  
The repository is organized in the following way:

* The [Data](Data) directory contains a compressed file with all the fresh data of our complete last run for the experiments. 
* The [Report](Report) directory contains all the reporting files. They only need a fresh data file to produce all the results. The reporting is based on [R](https://www.r-project.org/) and its [Knitr](https://yihui.name/knitr/) report generation framework.  
* The [Setup](Setup) directory contains the scripts to build all the necessary language implementations. 

Instructions for Running the Experiments
----------------------------------------

To checkout the code:

    git clone -b papers/TSE2017 https://github.com/charig/MatePerformance.git directoryName
    cd directoryName
    
To build all the implementations needed for running all the experiments by yourself:

    cd Setup
    ./setup.sh
    
*Note that the experimental setup has many dependencies: git, ant, make, mv, rebench, cc, c++, graalvm, pypy. 
Besides, [Graal](http://www.oracle.com/technetwork/oracle-labs/program-languages/downloads/index.html) must be manually downloaded and its corresponding downloaded dir set in [config.inc](Setup/buildScripts/config.inc)*

After building, for running the experiments just execute:

    ./runExperiments.sh

Finally, to produce all the images, tables, and data:

    cd ../Report
    ./compile.sh experiments.Rnw

