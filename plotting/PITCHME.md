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

---
### Let's start with PlotlyJS

Create a Julia notebook called plotlyjs_basics

+++

### Import

```julia
using PlotlyJS
```

+++
```julia
function linescatter1()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers")
    trace2 = scatter(;x=2:5, y=[16, 5, 11, 9], mode="lines")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers")
    plot([trace1, trace2, trace3])
end
linescatter1()
```

+++
```julia
function linescatter3()
    trace1 = scatter(;x=1:5, y=[1, 6, 3, 6, 1],
                      mode="markers+text", name="Team A",
                      textposition="top center",
                      text=["A-1", "A-2", "A-3", "A-4", "A-5"],
                      marker_size=12, textfont_family="Raleway, sans-serif")

    trace2 = scatter(;x=1:5+0.5, y=[4, 1, 7, 1, 4],
                      mode="markers+text", name= "Team B",
                      textposition="bottom center",
                      text= ["B-a", "B-b", "B-c", "B-d", "B-e"],
                      marker_size=12, textfont_family="Times New Roman")

    data = [trace1, trace2]

    layout = Layout(;title="Data Labels on the Plot", xaxis_range=[0.75, 5.25],
                     yaxis_range=[0, 8], legend_y=0.5, legend_yref="paper",
                     legend=attr(family="Arial, sans-serif", size=20,
                                 color="grey"))
    plot(data, layout)
end
linescatter3()
```

+++
```julia
function linescatter5()

    country = ["Switzerland (2011)", "Chile (2013)", "Japan (2014)",
               "United States (2012)", "Slovenia (2014)", "Canada (2011)",
               "Poland (2010)", "Estonia (2015)", "Luxembourg (2013)",
               "Portugal (2011)"]

    votingPop = [40, 45.7, 52, 53.6, 54.1, 54.2, 54.5, 54.7, 55.1, 56.6]
    regVoters = [49.1, 42, 52.7, 84.3, 51.7, 61.1, 55.3, 64.2, 91.1, 58.9]

    # notice use of `attr` function to make nested attributes
    trace1 = scatter(;x=votingPop, y=country, mode="markers",
                      name="Percent of estimated voting age population",
                      marker=attr(color="rgba(156, 165, 196, 0.95)",
                                  line_color="rgba(156, 165, 196, 1.0)",
                                  line_width=1, size=16, symbol="circle"))

    trace2 = scatter(;x=regVoters, y=country, mode="markers",
                      name="Percent of estimated registered voters")
    # also could have set the marker props above by using a dict
    trace2["marker"] = Dict(:color => "rgba(204, 204, 204, 0.95)",
                           :line => Dict(:color=> "rgba(217, 217, 217, 1.0)",
                                         :width=> 1),
                           :symbol => "circle",
                           :size => 16)

    data = [trace1, trace2]
    layout = Layout(Dict{Symbol,Any}(:paper_bgcolor => "rgb(254, 247, 234)",
                                     :plot_bgcolor => "rgb(254, 247, 234)");
                    title="Votes cast for ten lowest voting age population in OECD countries",
                    width=600, height=600, hovermode="closest",
                    margin=Dict(:l => 140, :r => 40, :b => 50, :t => 80),
                    xaxis=attr(showgrid=false, showline=true,
                               linecolor="rgb(102, 102, 102)",
                               titlefont_font_color="rgb(204, 204, 204)",
                               tickfont_font_color="rgb(102, 102, 102)",
                               autotick=false, dtick=10, ticks="outside",
                               tickcolor="rgb(102, 102, 102)"),
                    legend=attr(font_size=10, yanchor="middle",
                                xanchor="right"),
                    )
    plot(data, layout)
end
linescatter5()
```
