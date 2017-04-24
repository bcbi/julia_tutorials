## BioMedQuery.jl

<span style="font-size:0.6em; color:gray">Isabel Restrepo</span> |
<span style="font-size:0.6em; color:gray">PHP 2561, Brown University</span> |
<span style="font-size:0.6em; color:gray">April 25, 2017</span>

---

### Set up before class

* Install Docker

* Make sure Docker Daemon is running

* Download Docker Image bcbi/julia_edu

```
pull bcbi/julia_edu:latest
```

* Anyone who didn't get to do these steps before class?

---
### Finish setting up (in class)

* Make a directory where you will save your Jupyter notebooks. E.g.,

```
cd ~
mkdir php_2561/tutorial_notebooks
```

* Run docker image while sharing your notebook directory

```
docker run -it --name bcbi_julia_edu -p 8888:8888  -v ~/php_2561/tutorial_notebooks:/home/bcbi/notebooks bcbi/julia_edu:latest
```

---
### ...

* Run Jupyter: Inside the container,

```
./run_jupyter.sh
```

* To open Jupyter visti http:/localhost:8888


---
### What is BioMedQuery.jl?

[BioMedQuery.jl](https://github.com/bcbi/BioMedQuery.jl) is Julia package with utilities to interact
with BioMedical Databases and APIs. Supported databases/APIS include:

* Entrez Programming Utilities (E-utilities)
* Unified Medical Language System (UMLS)
* Clinical Trials (dot) Gov
* Medical Text Indexer (MTI)

---
### Where can I find documentation?

Documentation lives [here](http://bcbi.github.io/BioMedQuery.jl/stable/)

---
### What if the functionality I'm looking for doesn't exist?

Submit a [pull request!](https://github.com/bcbi/BioMedQuery.jl/pulls)

---
## Entrez Utilities (eutils)

BiomedQuery.Entrez provides an interface to some of the functionality in the [Entrez Utility API](https://www.ncbi.nlm.nih.gov/books/NBK25501/).

The following E-utils functions have been implemented:

<span style="font-size:0.6em; color:gray"> ESearch <span> |
<span style="font-size:0.6em; color:gray"> EFetch <span> |
<span style="font-size:0.6em; color:gray"> ELink <span> |
<span style="font-size:0.6em; color:gray"> ESummary <span> 

---
The following utility functions are available to handle and store NCBI responses

- EParse - Convert XML response to Julia Dict
- Saving NCBI Responses to XML
- Saving EFetch to a SQLite database
- Saving EFetch to a MySQL database

The following utility functions are available to query the database

- All PMIDs
- All MESH descriptors for an article
