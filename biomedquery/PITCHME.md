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
### ...Finish setting up (in class)

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

<span style="font-size:1em; color:gray"> ESearch </span> |
<span style="font-size:1em; color:gray"> EFetch </span> |
<span style="font-size:1em; color:gray"> ELink </span> |
<span style="font-size:1em; color:gray"> ESummary </span>

---
#### Functions available to handle and store NCBI responses

* EParse - Convert XML response to Julia Dict
* Saving NCBI Responses to XML
* Saving EFetch to a SQLite database
* Saving EFetch to a MySQL database

---
#### Functions  available to query the database

* All PMIDs
* All MESH descriptors for an article

---
### Before we start

* Attach another interactive shell to your docker container

```
docker exec -it bcbi_julia /bin/bash
```

* Create your .juliarc.jl file

```
cd ~
touch .juliarc.jl
```

---
* Write your environment variables

```
emacs .juliarc.jl
```

Type the following ENV variables

ENV["NCBI_EMAIL"]="first_last@brown.edu"
ENV["UMLS_USER"]="user"
ENV["UMLS_PSSWD"]="password"
ENV["PBCBICIT_USER"]="mysql_user"
ENV["PBCBICIT_PSSWD"]="mysql_password"

* Start mysql service

```
sudo /etc/init.d/mysql start
```

---
### Let's start

Create a Julia notebook called entrez

---
## Import the Module and Environment Variables

```julia
using BioMedQuery.Entrez
email = ENV["NCBI_EMAIL"];
umls_user = ENV["UMLS_USER"];
umls_psswd = ENV["UMLS_PSSWD"];
```

---
## esearch

Request a list of UIDS matching a query from an input dictionary specifying all required parameters specified in the Entrez documentation [NCBI Entrez:Esearch](http://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch).

---

### Example

Request 10 pmids for papers matching the query:

<span style="font-size:0.8 em; color:gray"> (asthma[MeSH Terms]) AND ("2001/01/29"[Date - Publication] : "2010"[Date - Publication]) </span>


```julia
search_term = """(asthma[MeSH Terms]) AND ("2001/01/29"[Date - Publication] : "2010"[Date - Publication])"""
search_dic = Dict("db"=>"pubmed", "term" => search_term,
"retstart" => 0, "retmax"=>10,
"email" => email)
esearch_response = esearch(search_dic)
```

---
### Save the response to file


```julia
using XMLconvert
xmlASCII2file(esearch_response, "./esearch.xml");
```

---
### Convert to a Julia (Multi) Dictionary

```julia
esearch_dict = eparse(esearch_response)
println("Type of esearch_dict: ", typeof(esearch_dict))
show_key_structure(esearch_dict)
```

---
### Flatten into Dictionary for easy access


```julia
flat_easearch_dict = flatten(esearch_dict)
display(flat_easearch_dict)
```
---

### Get all pmids returned by esearch


```julia
ids = Array{Int64,1}(flat_easearch_dict["IdList-Id" ])
```

---

## efetch


```julia
# define the fetch dictionary
fetch_dic = Dict("db"=>"pubmed","tool" =>"BioJulia",
"email" => "maria_restrepo@brown.edu", "retmode" => "xml", "rettype"=>"null")

# fetch
efetch_response = efetch(fetch_dic, ids)
```

---

### Convert to XML respose to (Multi) Dictionary


```julia
efetch_dict = eparse(efetch_response)
show_key_structure(efetch_dict)
```

---
## 3. Save to MySQL


```julia
db_config = Dict(:host=>"127.0.0.1",
                 :dbname=>"biomed_query_test",
                 :username=>"root",
                 :pswd=>"bcbi123",
                 :overwrite=>true)

db = save_efetch_mysql(efetch_dict, db_config)
```

---

## MySQL Schema

---
### Explore the MySQL Results Database


```julia
using MySQL
tables = mysql_execute(db, "show tables;")
display(tables)
articles = mysql_execute(db, "select * from article limit 10")
display(articles)
authors = mysql_execute(db, "select * from author limit 10")
display(authors)
```
---
## 4. Save as publications


```julia
citation_config = Dict(:type => "bibtex", :output_file => "citations_test.bib", :overwrite=>true)
    save_article_citations(efetch_dict, citation_config);
```

---
# BioMedQuery.Processes

The library comes with a series a "pre-assembled" workflows. For instance, we often need to call esearc, efetch and save to database as a pipeline.


```julia
using BioMedQuery.Processes
```

---
### esearch, efetch, mysql_save in one line of code


```julia
db = pubmed_search_and_save(email, search_term, 10,
    save_efetch_mysql, db_config);
```

---

### esearch, efetch, save citations in one line of code


```julia
pubmed_search_and_save(email, search_term, 10,
    save_article_citations, citation_config);
```
