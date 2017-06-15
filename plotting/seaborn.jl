
using Seaborn
using Pandas
using PyPlot
using PyCall

@pyimport numpy

#for some strange reason loading doesn't work the first time
tips = nothing
try
    tips = load_dataset("tips");
catch
    tips = load_dataset("tips");
end


head(tips)

g = regplot(x="total_bill", y="tip", data=tips)
title("Total Bill vs. Tip") #current active figure PyPlot
# alternatively
# g[:figure][:axes][1][:set_title]("Total Bill vs. Tip")


f, (ax1, ax2,ax3)  = subplots(1, 3, sharey=true)
regplot(x="size", y="tip", data=tips, ax=ax1);
regplot(x="size", y="tip", data=tips, x_jitter=.05, ax=ax2);
regplot(x="size", y="tip", data=tips, x_estimator=numpy.mean, ax=ax3);

anscombe = load_dataset("anscombe");
head(anscombe)

lmplot(x="x", y="y", data=query(anscombe, "dataset == 'II'"),
           ci=nothing, scatter_kws=Dict("s"=> 80));

lmplot(x="x", y="y", data=query(anscombe, "dataset == 'II'"),
           ci=nothing, scatter_kws=Dict("s"=> 80), order =2);

jointplot(x="total_bill", y="tip", data=tips, kind="reg")
savefig("./test.svg")

lmplot(x="total_bill", y="tip", hue="smoker", data=tips);

lmplot(x="total_bill", y="tip", col="day", data=tips,
           aspect=.5);
