# Intro to Julia

This repository houses the materials used for introductory classes on using Julia for:
* Statistics
* Biomedical Queries using Entrez, UMLS and ClinicalTrials.gov
* Plotting with PlotlyJS

The Dockerfile can be used to create a Debian image with Anaconda Python 3.6, Julia 0.5.1, and R 3.3.2.
Also included in this Debian image are many of the more popular packages for these languages (e.g., Scikit-Learn, pandas, numpy, dplyr, ggplot2, Rcpp, lme4, arules, arulesSequences, DataFrames.jl, GLM.jl, PlotlyJS.jl, Cxx.jl, RCall.jl).


## Building the image locally

```
    cd docker_image
    docker build -t bcbi/julia_edu:0.5 .
```

## Getting the image from bcbi's repo

```
    pull bcbi/julia_edu:0.5
```


## Running the image interatively

```
    docker run -it --name bcbi_julia_edu -p 8888:8888  -v ~/bcbi/edu/notebooks:/home/bcbi/notebooks bcbi/julia_edu:0.5
```

#### Note:

* ~/bcbi/edu/notebooks is a shared directory where jupyter notebooks live. You may specify your directory of preference


## Run the jupyter notebook

Once inside the container run

```
    ./run_jupyter.sh
```

## Open a second interactive bash session

If jupyter is running in your session, you may need a second bash session to interact with your container. You may do so running:

```
    docker exec -it bcbi_edu_julia /bin/bash
```

## Exit a running container

CTRL+P immediately followed by CTRL+Q.
