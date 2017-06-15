
using PyPlot

function linescatter()
    x = [1, 2, 3, 4]
    y = [10, 15, 13, 17]
    plot(x,y)
end
linescatter()

function multiple_scatter_traces()
    x=1:4
    y1 = [10, 15, 13, 17]
    y2 = [16, 5, 11, 9]
    y3 = [12, 9, 15, 12]
    y4 = [5, 10, 8, 12]
    plot(y1, label="marker", "o")
    hold(true)
    plot(y2, label="line+marker", "-o")
    plot(y3, label="line", "-")
    plot(y4, label="dash", "--")
end
multiple_scatter_traces()

function data_labels()
    x = 1:5
    y1 = [1, 6, 3, 6, 1]
    y2 = [4, 1, 7, 1, 4]
    y1_labels = ["A-1", "A-2", "A-3", "A-4", "A-5"]
    y2_labels = ["B-a", "B-b", "B-c", "B-d", "B-e"]

    f, ax = subplots(1, 1)
    title("Data Labels on the Plot")
    plot(x, y1, label="Team A")
    plot(x, y2, label="Team B")
    ax[:legend](loc="upper left", shadow=true)
   
    for idx= 1:length(x)
        ax[:annotate](s=y1_labels[idx], xy = (x[idx], y1[idx]))
        ax[:annotate](s=y2_labels[idx], xy = (x[idx], y2[idx]))
        idx = idx + 1
    end    
end
data_labels()

function area1()
    fig, ax = subplots()
    y1=[0, 2, 3, 5] #, fill="tozeroy")
    y2=[3, 5, 1, 7] #, fill="tonexty")
    plot(y1, label="lines")
    plot(y2, label="lines")
    ax[:legend](loc="upper center", shadow=true)
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
