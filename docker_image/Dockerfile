FROM debian:8.5

MAINTAINER Paul Stey

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.3.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
     rm tini.deb && \
    apt-get clean

        
# Add some useful tools and dependencies
RUN apt-get install -y emacs sudo screen cmake m4 hdf5-tools gettext libcurl4-openssl-dev libssl-dev
    

# Add dependencies for Cxx.jl
RUN apt-get install -y libedit-dev libncurses5-dev

    
# Add Debian repo for R 3.3.3
RUN echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480 && \
    apt-get update
 
RUN apt-get install -y libzmq3-dev r-base r-base-dev 

    
# Get mysql client
RUN apt-get update && \
    apt-get install -y mysql-client libmysqlclient-dev

    
# Install julia 0.5.1
RUN mkdir -p /opt/julia-0.5.1 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz | tar -C /opt/julia-0.5.1 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.5.1 /opt/julia-0.5

# Make v0.5 default julia
RUN ln -fs /opt/julia-0.5.1 /opt/julia


# Add user bcbi
RUN useradd --create-home --home-dir /home/bcbi --shell /bin/bash bcbi
RUN adduser bcbi sudo
RUN usermod -a -G sudo bcbi
RUN echo "bcbi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure directories
RUN mkdir -p /home/bcbi/notebooks
RUN chown -R bcbi /home/bcbi/notebooks
VOLUME /home/bcbi/notebooks
WORKDIR /home/bcbi


# Add data directory
ADD data /home/bcbi/data
ADD utils /home/bcbi/utils
ADD gate /home/bcbi/gate
            
# Include shell script for starting Jupyter
ADD run_jupyter.sh /home/bcbi
RUN chmod +x /home/bcbi/run_jupyter.sh
RUN chown bcbi /home/bcbi/run_jupyter.sh


USER bcbi
ENV USER=bcbi
ENV HOME=/home/bcbi
ENV PATH /opt/conda/bin:/opt/julia/bin:$PATH

RUN julia -e 'Pkg.add("IJulia");          \
              Pkg.add("RCall");           \
              Pkg.add("DataFrames");      \
              Pkg.add("ScikitLearn");     \
              Pkg.add("GLM");             \
              Pkg.add("DataTables");      \
              Pkg.add("Requests");        \
              Pkg.add("BioMedQuery");     \
              Pkg.add("MySQL");           \
              Pkg.add("DecisionTree");    \
              Pkg.add("Lasso");           \
              Pkg.add("Gadfly");          \
              Pkg.add("PyPlot");          \
              Pkg.add("GLMNet");          \ 
              Pkg.add("Cxx");             \
              Pkg.add("PlotlyJS");        \
              Pkg.add("MixedModels");     \
              Pkg.add("Mamba");           \
              Pkg.add("HypothesisTests"); \
              Pkg.add("Clustering");      \
              Pkg.add("RDatasets");       \
              Pkg.add("Plots")'


RUN mkdir -p /home/bcbi/R/x86_64-pc-linux-gnu-library/3.3
RUN chmod 775 /home/bcbi/R/x86_64-pc-linux-gnu-library/3.3
RUN chown bcbi /home/bcbi/R/x86_64-pc-linux-gnu-library/3.3
        
RUN R -e 'install.packages(c("devtools",        \
                             "lme4",            \
                             "tidyverse",       \
                             "randomForests",   \
                             "glmnet",          \
                             "arules",          \
                             "arulesSequences", \
                             "gbm",             \  
                             "Rcpp"),           \
                              repos = "http://cran.r-project.org", \
                              lib = "/home/bcbi/R/x86_64-pc-linux-gnu-library/3.3")'
    
RUN R -e 'devtools::install_github("IRkernel/IRkernel"); \
          IRkernel::installspec(name = "ir33", displayname = "R 3.3")'
    
EXPOSE 8888 3306
    
#ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

