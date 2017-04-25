## Plotting with Julia

<span style="font-size:0.6em; color:gray">Isabel Restrepo, PhD</span> |
<span style="font-size:0.6em; color:gray">PHP 2561, Brown University</span> |
<span style="font-size:0.6em; color:gray">April 25, 2017</span>


<span style="font-size:0.6em; color:gray"> Slides: https://gitpitch.com/bcbi/julia_tutorials/master?p=plotting </span>

---
## Libraries

### Plots.jl

Highlevel, poweful library that wraps many plotting backends

https://juliaplots.github.io/

+++
#### Pros
* Flexibility - use your favorite backend library to produce your plots
* Consistency - change backend without changing your code
* Smart - use features such as recipes and layouts
* Great Documentation

+++
#### Cons
* Does not support every possible backend
* In some cases some features may not be implemented

---
## Gladfly.jl

A Julia implementation inspired by the "Grammar of Graphics" and ggplot2. Primary author: Daniel C Jones

+++
### Pros:
* Clean look Lots of features
* Flexible when combined with Compose.jl (inset plots, etc)
* Familiar to R users

+++
### Cons:
* Does not support 3D
* Slow time-to-first-plot
* Lots of dependencies
* No interactivity

---
## PyPlot.jl

A Julia wrapper around the popular python package PyPlot (Matplotlib). It uses PyCall.jl to pass data with minimal overhead.

+++
### Pros:
* Tons of functionality
* 2D and 3D
* Mature library
* Standalone or inline
* Well supported in Plots
* Familiar to python users

+++
### Cons:
* Uses python
* Dependencies frequently cause setup issues
* Inconsistent output depending on Matplotlib version

---
## PlotlyJS/Plotly

Both libraries have basically identical interface, one uses local resources, the other the cloud.
Plotly.js is built on top of d3.js and stack.gl to create a high-level, declarative charting library. plotly.js ships with 20 chart types, including 3D charts, statistical graphs, and SVG maps.
PlotlyJS is the corresponding Julia interface. This package constructs plotly graphics using all local resources. To interact or save graphics to the Plotly cloud, use the plotly.jl library.

+++
### Pros:
* Tons of functionality/Super configurable
* 2D and 3D
* Mature library
* Interactivity (even when inline)
* Standalone or inline
* Great looking plots

+++
### Cons:
* No custom shapes
* JSON may limit performance
