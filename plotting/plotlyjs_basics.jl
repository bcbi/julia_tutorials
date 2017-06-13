
using PlotlyJS
using DataFrames, RDatasets

function linescatter()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17])
    plot(trace1)
end
linescatter()

function multiple_scatter_traces()
    trace1 = scatter(;x=1:4, y=[10, 15, 13, 17], mode="markers", name="marker only")
    trace2 = scatter(;x=1:4, y=[16, 5, 11, 9], mode="lines", name="line")
    trace3 = scatter(;x=1:4, y=[12, 9, 15, 12], mode="lines+markers", name="line+marker")
    trace4 = scatter(;x=1:4, y=[5, 10, 8, 12], mode="lines", line_dash="dash", name="dash")
    plot([trace1, trace2, trace3, trace4])
end
multiple_scatter_traces()

function data_labels()
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
data_labels()

function area1()
    trace1 = scatter(;x=1:4, y=[0, 2, 3, 5], fill="tozeroy")
    trace2 = scatter(;x=1:4, y=[3, 5, 1, 7], fill="tonexty")
    plot([trace1, trace2])
end
area1()

function matrix_subplots()
    z = rand(10,10)
    trace0 = scatter(; y=z)

    trace1 = heatmap(; z=z, showscale=false)
    trace2 = contour(; z=z)
    trace3 = surface(; z=z)
    p = [plot(trace1) plot(trace2)]
end

matrix_subplots()

function advanced_layouts()
    trace1 = scatter(;y=rand(10), mode="markers")
    trace2 = bar(;y=rand(10), xaxis="x2", yaxis="y2")
    trace3 = scatter(;y=rand(10), xaxis="x3", yaxis="y3")

    data = [trace1, trace2, trace3]
    xdomains = [[0,0.3], [0.33, 0.53] , [0.56, 0.78], [0.8, 1] ]
    ydomains = [[0,1],   [0, 0.27] , [0.33, 0.63], [0.66, 1] ]
    layout = Layout(; xaxis_domain=xdomains[1], 
                    xaxis2_domain=xdomains[2], yaxis2_domain=ydomains[2],yaxis2_anchor="x2", xaxis2_anchor="y2",
                    xaxis3_domain=xdomains[2], yaxis3_domain=ydomains[3],yaxis3_anchor="x3", xaxis3_anchor="y3"
                    )
    plot(data, layout)
end
p1 = advanced_layouts()


function grouped_bar_example()
    trace1 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[20, 14, 23],
                  name="SF Zoo")
    trace2 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[12, 18, 29],
                  name="LA Zoo")
    data = [trace1, trace2]
    layout = Layout(;barmode="group")
    plot(data, layout)
end

grouped_bar_example()

function stacked_bar_example()
    trace1 = bar(;x=["giraffes", "orangutans", "monkeys"],
                  y=[20, 14, 23],
                  name="SF Zoo")
    trace2 = bar(x=["giraffes", "orangutans", "monkeys"],
                 y=[12, 18, 29],
                 name="LA Zoo")
    data = [trace1, trace2]
    layout = Layout(;barmode="stack")
    plot(data, layout)
end
stacked_bar_example()

function two_hists()
    x0 = randn(500)
    x1 = x0+1

    trace1 = histogram(x=x0, opacity=0.75)
    trace2 = histogram(x=x1, opacity=0.75)
    data = [trace1, trace2]
    layout = Layout(barmode="overlay")
    plot(data, layout)
end

two_hists()

function box_plot()
    x0 = ["day 1", "day 1", "day 1", "day 1", "day 1", "day 1",
          "day 2", "day 2", "day 2", "day 2", "day 2", "day 2"]
    trace1 = box(;y=[0.2, 0.2, 0.6, 1.0, 0.5, 0.4, 0.2, 0.7, 0.9, 0.1, 0.5, 0.3],
                  x=x0,
                  name="kale",
                  marker_color="#3D9970")
    trace2 = box(;y=[0.6, 0.7, 0.3, 0.6, 0.0, 0.5, 0.7, 0.9, 0.5, 0.8, 0.7, 0.2],
                  x=x0,
                  name="radishes",
                  marker_color="#FF4136")
    trace3 = box(;y=[0.1, 0.3, 0.1, 0.9, 0.6, 0.6, 0.9, 1.0, 0.3, 0.6, 0.8, 0.5],
                  x=x0,
                  name="carrots",
                  marker_color="#FF851B")
    data = [trace1, trace2, trace3]
    layout = Layout(;yaxis=attr(title="normalized moisture", zeroline=false),
                    boxmode="group")
    plot(data, layout)
end
box_plot()

function data_frame_scatter()
    iris = dataset("datasets", "iris");
    display(head(iris))
    my_trace = scatter(iris, x=:SepalLength, y=:SepalWidth, mode="markers", group=:Species)
    plot(my_trace)
    p = Plot(iris, x=:SepalLength, y=:SepalWidth, mode="markers", marker_size=8, group=:Species)
    _p = JupyterPlot(p) #In Atom use _p = ElectronPlot(p)
    display(_p)
end

data_frame_scatter()
