
using Gadfly
using DataFrames, RDatasets

function linescatter()
    x = [1, 2, 3, 4]
    y = [10, 15, 13, 17]
    plot(x=x,y=y, Geom.line)
end
linescatter()

function multiple_scatter_traces()
    x=1:4
    l1 = layer(x = x, y = [10, 15, 13, 17],  Geom.point)
    l2 = layer(x = x, y = [16, 5, 11, 9], Geom.line)
    l3 = layer(x = x, y = [12, 9, 15, 12], Geom.point, Geom.line)
    l4 = layer(x = x, y = [5, 10, 8, 12], Geom.line)
    plot(l1, l2, l3, l4)
end
multiple_scatter_traces()

function data_labels()
    x = 1:5
    y1 = [1, 6, 3, 6, 1]
    y2 = [4, 1, 7, 1, 4]
    y1_labels = ["A-1", "A-2", "A-3", "A-4", "A-5"]
    y2_labels = ["B-a", "B-b", "B-c", "B-d", "B-e"]

    l1 = layer(x = x, y = y1, label=y1_labels, Geom.label, Geom.point)
    l2 = layer(x = x, y = y2, label=y2_labels, Geom.label, Geom.point) 
    plot(l1,l2)
end
data_labels()

function area1()
end
area1()

function matrix_subplots()

end

matrix_subplots()

function advanced_layouts()

end
advanced_layouts()

function grouped_bar_example()

end

grouped_bar_example()

function stacked_bar_example()
    
end()
stacked_bar_example()

function two_hists()

end

two_hists()

function box_plot()
   
end
box_plot()

function data_frame_scatter()
    iris = dataset("datasets", "iris");
    display(head(iris))
end

data_frame_scatter()
