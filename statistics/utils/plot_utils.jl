# PlotlyJS Examples
using PlotlyJS

# NOTE: By default, here is the PlotyJS color palette. This
# may prove useful when hard-coding colors is desired.
# #1F77B4
# #FF7F0E
# #2CA02C
# #D62728
# #9575D2
# #8C564B
# #E377C0
# #7F7F7F
# #BCBD22
# #17BECF


function hist2{T<:Real}(x1::AbstractArray{T,1};
                        col = "#87CEEB",
                        bargap = 0.05,
                        alpha = 0.99,
                        title = "",
                        plot_bgcolor = "white")

    trace1 = histogram(x = x1,
                       opacity = alpha,
                       marker_color = col,
                       nbinsx = 50)

    layout = Layout(barmode = "overlay",
                    bargap = bargap,
                    title = title,
                    plot_bgcolor = plot_bgcolor,
                    xaxis = attr(gridcolor = "#E2E2E2"),
                    yaxis = attr(gridcolor = "#E2E2E2"))
    plot(trace1, layout)
end

## Example use
# hist2(randn(50_000))



function hist2{T<:Real, S<:Real}(x1::AbstractArray{T,1},
                                 x2::AbstractArray{S,1};
                                 bargap = 0.05,
                                 alpha = 0.8,
                                 plot_bgcolor = "white")

    trace1 = histogram(x = x1,
                       opacity = alpha,
                       marker_color = "#1F77B4",
                       nbinsx = 50)
    trace2 = histogram(x = x2,
                       opacity = alpha,
                       marker_color = "#FF7F0E",
                       nbinsx = 50)
    data = [trace1, trace2]

    layout = Layout(barmode = "overlay",
                    bargap = bargap,
                    plot_bgcolor = plot_bgcolor,
                    xaxis = attr(gridcolor = "#E2E2E2"),
                    yaxis = attr(gridcolor = "#E2E2E2"))

    plot(data, layout)
end

## Example use
# hist2(randn(3000), randn(3000) .+ 2);


function scatterplot{T<:Real}(y1::AbstractArray{T,1}, col = "#87CEEB")
    trace1 = scatter(y = y1,
                     mode = "markers",
                     marker_color = col)

    layout1 = Layout(plot_bgcolor = "white",
                     xaxis = attr(gridcolor = "#E2E2E2"),
                     yaxis = attr(gridcolor = "#E2E2E2"))

    plot(trace1, layout1)
end

## Example use
# scatterplot(randn(1000));



function scatterplot{T<:Real, S<:Real}(x1::AbstractArray{T,1},
                                       y1::AbstractArray{S,1}, col = "#87CEEB")
    trace1 = scatter(x = x1,
                     y = y1,
                     mode = "markers",
                     marker_color = col)

    layout1 = Layout(plot_bgcolor = "white",
                     xaxis = attr(gridcolor = "#E2E2E2"),
                     yaxis = attr(gridcolor = "#E2E2E2"))

    plot(trace1, layout1)
end


## Example use
# x = randn(1000);
# y = 2.0 + 1.5x .+ randn(1000);
# #
# scatterplot(x, y);
