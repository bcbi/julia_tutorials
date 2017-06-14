## Plotting and Visualization in Julia


### Materials:

* Introductory Slides: [![Intro Slides](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/bcbi/julia_tutorials/master?grs=github&t=white&p=plotting)
* PlotlyJS.jl Notebook Viewer
* Plots.jl Notebook Viewer
* Seaborn.jl Notebook Viewer
* (For instructors) To locally view the notebooks as slide you can install the notebook extension [RISE](https://github.com/damianavila/RISE)


### Files in this diresctory:

* PITCHME.md -- slides diplayed at gitpich.com
* PITCHME.yaml -- slides configuration
* plots_basics.ipynb - Jupyter notebook introducing Plots.jl
* plots_basics.jl - Julia script matching the corresponding notebook
* plotlyjs_basics.ipynb - Jupyter notebook introducing PlotlyJS.jl
* plotlyjs_basics.jl - Julia script matching the corresponding notebook
* seaborn_basics.ipynb - Jupyter notebook introducing Seaborn.jl
* seaborn_basics.jl - Julia script matching the corresponding notebook


### Dependencies:

```julia
# Packages to add - you may already have some of them
Pkg.add("PyPlot")
Pkg.add("Plots")
Pkg.add("StatPlots")
Pkg.add("PlotlyJS")
Pkg.add("Gadfly")
Pkg.add("Seaborn")
Pkg.add("Pandas")


# Test all used packages
using Plots
using StatPlots
using DataFrames, RDatasets
using PlotlyJS
using Gadfly

using Seaborn
using Pandas
using PyPlot
using PyCall
```
