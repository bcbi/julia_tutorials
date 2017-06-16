# ggplot is a high level plotting library developed by Hadley Wickham and it is
# built on the concept of The Grammar of Graphics. The idea is to build up 
# plots layer by layer. It has almost everything you need to produce static
# publication-ready plots. 

library(ggplot2)
library(GGally)
library(grid)
library(gridExtra)
library(RColorBrewer)

############
# The Basics
############

# 1. The Setup
# - tell ggplot which dataset to plot
head(diamonds)
ggplot(diamonds)
# - tell ggplot which variable to plot on the x axis
ggplot(diamonds, aes(x = carat))
# - tell ggplot which variable to plot on the y axis
ggplot(diamonds, aes(x = carat, y = price))

# 2. The Layers (geoms)
# - scatter plot
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point()
# - scatter plot with color and smoothing lines
ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() +
  geom_smooth()
# - same as above, but specify the color aesthetics inside of the geoms
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut)) + 
  geom_smooth(aes(color = cut))
# - change the smoothing lines to a single line for all the data
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut)) + 
  geom_smooth()
# - make the shape of the points vary with the cut variable
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut, shape = cut))

# 3. The Labels
# - add custom labels to the plot
ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  labs(title="Scatterplot", x="Carat", y="Price")

# 4. The Theme
# - change the font properties of labels and legend title
ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() + 
  labs(title = "Scatterplot", x = "Carat", y = "Price") +
  theme(plot.title = element_text(size = 30, face = "bold"), 
        axis.text.x = element_text(size = 15), 
        axis.text.y = element_text(size = 15),
        axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25)) + 
  scale_color_discrete(name="Cut of diamonds")
# - change scale_color_discrete to scale_color_continuous if the legend shows a continuous variable
# - change scale_color_discrete to scale_shape_discrete if the legend shows a shape attribute
# - change scale_color_discrete to scale_fill_discrete if the legend shows a fill attribute

# 5. The Facets
# - add subplots based on a variable using a formula
#   - the LHS corresponds to rows, the RHS corresponds to columns
ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() + 
  labs(title = "Scatterplot", x = "Carat", y = "Price") +
  theme(plot.title = element_text(size = 30, face = "bold"), 
        axis.text.x = element_text(size = 15), 
        axis.text.y = element_text(size = 15),
        axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25)) + 
  scale_color_discrete(name = "Cut of diamonds") +
  facet_grid( ~ cut)
ggplot(diamonds, aes(x = carat, y = price, color = cut)) + 
  geom_point() + 
  labs(title = "Scatterplot", x = "Carat", y = "Price") +
  theme(plot.title = element_text(size = 30, face = "bold"), 
        axis.text.x = element_text(size = 15), 
        axis.text.y = element_text(size = 15),
        axis.title.x = element_text(size = 25),
        axis.title.y = element_text(size = 25)) + 
  scale_color_discrete(name = "Cut of diamonds") +
  facet_grid(color ~ cut)


#############################
# Different Plots and Options
#############################

head(mtcars)

# Bar Charts
# - by default, ggplot makes a "counts" barchart: it counts the frequency of items in the x aesthetic
plot1 <- ggplot(mtcars, aes(x = cyl)) + 
  geom_bar() + 
  labs(title = "Frequency bar chart")
print(plot1)
# - if you want to plot an absolute number given by a y aesthetic, set stat = "identity"
identity <- data.frame(cyl = c(4, 6, 8), nums = c(1:3))
plot2 <- ggplot(identity, aes(x = cyl, y = nums)) + 
  geom_bar(stat = 'identity') + 
  labs(title="Static bar chart")
print(plot2)

# Multiple Plots in a Single Grid
# - from the gridExtra library
grid.arrange(plot1, plot2, ncol = 2)

# Bar Positions
bar <- ggplot(mtcars, aes(x = cyl)) 
bar1 <- bar + 
  geom_bar(position="dodge", aes(fill = factor(vs))) 
bar2 <- bar +  
  geom_bar(aes(fill = factor(vs)))
grid.arrange(bar1, bar2, ncol=2)

# Flip Coordinates
ggplot(identity, aes(x = cyl, y = nums)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  labs(title = "Coordinates are flipped")

# Adjusting the X and Y axis limits
# There are 3 ways to change the X and Y axis limits.
# - coord_cartesian(xlim = c(x1,x2))        (zoomed in)
# - xlim(c(x1,x2))                          (delete datapoints outside limits)
# - scale_x_continuous(limits = c(x1,x2))   (delete datapoints outside limits)
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut)) + 
  geom_smooth(aes(color = cut)) + 
  coord_cartesian(ylim = c(0, 10000)) + 
  labs(title = "Option 1: Coord_cartesian zoomed in")

ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut)) + 
  geom_smooth(aes(color = cut)) + 
  ylim(c(0, 10000)) + 
  labs(title = "Option 2: Smoothing lines have changed")

# Change Themes
# - theme_gray()
# - theme_bw()
# - theme_linedraw()
# - theme_light()
# - theme_minimal()
# - theme_classic()
# - theme_void()
ggplot(diamonds, aes(x = carat, y = price)) + 
  geom_point(aes(color = cut)) + 
  geom_smooth(aes(color = cut)) + 
  ylim(c(0, 10000)) + 
  labs(title = "bw Theme") +
  theme_bw()

# Change Legend Position
p1 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  geom_smooth() + 
  theme(legend.position="none") + 
  labs(title="legend.position='none'")
p2 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  geom_smooth() + 
  theme(legend.position="top") + 
  labs(title="legend.position='top'")
p3 <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + 
  geom_point() + 
  geom_smooth() + 
  labs(title="legend.position='coords inside plot'") + 
  theme(legend.justification=c(1,0), legend.position=c(1,0))
grid.arrange(p1, p2, p3, ncol=3)

# Annotation
my_grob <- grobTree(textGrob("This text is at x=0.1 and y=0.9, relative to...\n Anchor point is at 0,0", 
                             x = 0.1,  
                             y = 0.9, 
                             hjust = 0,
                             vjust = 1,
                             gp = gpar(col = "firebrick", fontsize = 12, fontface = "bold")))
ggplot(mtcars, aes(x=cyl)) + 
  geom_bar() + 
  annotation_custom(my_grob) + labs(title="Annotation Example")

# Saving a Plot to an Image File
# - saves the last plot
ggsave("~/Desktop/myggplot.png")
# - saves a stored ggplot
ggsave("~/Desktop/myggplot2.png", plot = p1) 

# Density Charts
ggplot(mtcars, aes(mpg)) + 
  geom_density() + 
  labs(title="Density plot")
ggplot(mtcars, aes(mpg)) + 
  geom_density(aes(fill = factor(cyl), alpha = 0.5)) + 
  labs(title="Density plot with factors")

# Tile Charts
# - prepare the data
corr <- round(cor(mtcars), 2)
df <- melt(corr)
# - create a basic correlation plot
gg <- ggplot(df, aes(x=Var1, y=Var2, fill=value, label=value)) + 
  geom_tile() + 
  theme_bw() + 
  geom_text(aes(label=value, size=value), color="white") + 
  labs(title="mtcars - Correlation plot") + 
  theme(text=element_text(size=20), legend.position="none")
# - use different color scales using the R Color Brewer package
p2 <- gg + scale_fill_distiller(palette="Reds")
p3 <- gg + scale_fill_gradient2()
# - plot all three
grid.arrange(gg, p2, p3, ncol=3)

# Scatterplot Matrix
ggpairs(mtcars[, 1:4], aes(alpha = 0.4))
ggpairs(iris, aes(color = Species, alpha = 0.4))


#############
# Challenge 2
#############
# - Create a histogram of the num_lab_procedures

# - Create the same histogram, but separate out the classes with different colors



###########
# Resources
###########
# Documentation: http://ggplot2.org
# R Graphics Cookbook: https://ase.tufts.edu/bugs/guide/assets/R%20Graphics%20Cookbook.pdf
# Cheatsheet: https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf