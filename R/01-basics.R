#####################
# Installing Packages
#####################

install.packages(c('readr', 'dplyr', 'reshape2'))
install.packages('e1071')
install.packages('caret', 'car')
install.packages('ggplot2', 'GGally', 'gridExtra', 'RColorBrewer')
install.packages(c('shiny', 'maps', 'mapproj', 'quantmod'))


###################
# Loading Libraries
###################

library(readr)
library(dplyr)
library(reshape2)


########
# Basics
########

# Variable assignment
x <- 10.5
y <- 2
z = 17

# Basic Math Operations
1+2
x-y
4*y
z/y
z%%2


############
# Data Types
############

# Numeric: decimal or integer number
class(x)
class(y)
is.integer(x)
is.integer(y)                 

# Integer
yi <- as.integer(y)
class(yi)
is.integer(yi)
xi <- as.integer(x)
as.integer('5.27')            # can coerce strings to integers

# Logical/boolean
t <- TRUE
f <- FALSE
t - f                         # TRUE evaluates to 1 and FALSE evaluates to 0
TRUE + TRUE
l <- x > y                    # create a logical from an evaluated expression
class(l)
t & f                         # logical operations and, or, negation
t | f
!t
help("&")

# Character
a <- 'dog'
b <- 'cat'
c <- '3.14'
paste0(b,a)                    # concatenate strings
substr(a, start = 1, stop = 2) # substring
sub('g', 'e', a)               # find and replace part of string

# Factor: like character, but used for categorical variables where there are a set of known possible values
as.factor(a)
as.factor(c(a, b, c))


#########
# Vectors
#########

v <- c(1, 2, 3)
u <- c(1.5, 1.6, 1.7)
w <- c('dog', 'cat', 'bird')
s <- c('dog', 1)               # vector must have same type - coerce numeric to character

# Initialize and grow vectors
p <- c()
p <- c(p, 1)
p <- c(p, c('a', 'b', 'c'))
length(p)
p[5:6] <- c('d', 'e')
t <- c(v, u, w)


# Indexing a vector: identical to Julia, uses 1-based indexing
t[1]                            # get first element
t[1] <- 'ostrich'               # assign to first element
# Removing an element
t <- t[-1]

# Slicing and subsetting a vector
t[1:2]                          # get subset of vector (1st and 2nd element)
t[4:length(t)]
animals <- c("dog", "cat", "fish", "mouse", "potato")
mammals_indcs <- c(1, 2, 4)
animals[mammals_indcs] 

# Vector arithmetic: elementwise
v + 5
v * 2
v + u
v * u

# Concatenation
cbind(u, v)
rbind(u, v)


######
# List
######

# Generic container
alist = list(v, u)

# Concatenating a list to another list
alist = c(alist, list(w))
alist = c(alist, w)

# List slicing
alist[1]                
alist[c(1, 2)]

# Member reference
alist[[1]]                   
alist[[1]][2]

# Member assignment
alist[[1]][2] <- 10   

# Named lists
blist <- list(bob = c(2, 3, 5), 
              john = c('aa', 'bb')) 

# Named list slicing
blist['bob']
blist[c('john', 'bob')]

# Named list member reference
blist[['bob']]
blist$bob


##########
# Matrices
##########

# Matrices are traversed column-wise by default in R

A <- matrix(c(2, 4, 3, 1, 5, 7),      # the data elements 
            nrow=2,                    # number of rows 
            ncol=3,                    # number of columns 
            byrow = TRUE)              # fill matrix by rows 
dim(A)

# Index a matrix: same as indexing a vector, but there are two dimensions
A[2, 3]
A[2,]
A[ ,3]
A[, c(1, 3)]

# Assign row and column names to access them by name
dimnames(A) = list(c("row1", "row2"),            # row names 
                   c("col1", "col2", "col3"))    # column names 
A['row2', 'col3']
A['row2', ]
A[, 'col3']

# Matrix Construction
B <- t(A)                         # transpose of matrix A
C <- matrix(c(7, 4, 2),
            nrow = 3,
            ncol = 1)
cbind(B, C)                       # combine matrices that have the same number of rows or cols
rbind(A, t(C))

# Matrix Deconstruction/Flattening
c(B)

# Matrix Operations
dim(A)
dim(B)
A * A
A %*% B
rowMeans(A)
rowSums(A)
colMeans(A)
colSums(A)
svd(A)
I <- diag(4)
eigen(I)

# The Matrix package supports dense and sparse matrices

#############
# Data Frames
#############

f <- c(2, 3, 5) 
g <- c("aa", "bb", "cc") 
h <- c(TRUE, FALSE, TRUE) 
df <- data.frame(nums = f, 
                 chars = g, 
                 logics = h) 
df
glimpse(df)

# Built in R Datasets
mtcars
head(mtcars)
glimpse(mtcars)
mtcars[1,2]
mtcars["Mazda RX4", "cyl"] 
nrow(mtcars); ncol(mtcars)

# Column vector
mtcars$cyl

# Row slice
mtcars['Mazda RX4', ]
mtcars[1:4,]


###########
# Resources
###########

# R Main Site: https://www.r-project.org
# R Documentation: https://www.rdocumentation.org
# CRAN Repository of Libraries: https://cran.r-project.org