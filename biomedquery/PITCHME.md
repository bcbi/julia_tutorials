## BioMedQuery.jl

<span style="font-size:0.6em; color:gray">Isabel Restrepo, PhD</span> |
<span style="font-size:0.6em; color:gray">PHP 2561, Brown University</span> |
<span style="font-size:0.6em; color:gray">April 25, 2017</span>


<span style="font-size:0.6em; color:gray"> Slides: https://gitpitch.com/bcbi/julia_tutorials/master?p=biomedquery </span>
---

### Set up before class


* Install Docker
* Make sure Docker Daemon is running
* Download Docker Image bcbi/julia_edu

```
docker pull bcbi/julia_edu:latest
```

* Is everyone done with these steps?

---
### AWS?

http://34.207.254.102:8888/

hcwang | kjeong | kjline  | pc16 | vdantu

http://54.173.109.173:8888/

amtran | bbqu | bmle | jsleung | mquinn | nchou

---
### Finish setting up (in class)

* Make a directory where you will save your Jupyter notebooks. E.g.,

```
cd ~
mkdir php_2561
cd php_2561
mkdir tutorial_notebooks
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

* To open Jupyter visit http:/localhost:8888


---
### What is BioMedQuery.jl?

[BioMedQuery.jl](https://github.com/bcbi/BioMedQuery.jl) is a Julia package with utilities to interact
with BioMedical Databases and APIs. Supported databases/APIS include:

* Entrez Programming Utilities (E-utilities)
* Unified Medical Language System (UMLS)
* Clinical Trials (dot) Gov
* Medical Text Indexer (MTI)

---
### Where can I find documentation?

Documentation lives here: http://bcbi.github.io/BioMedQuery.jl/stable/

---
### What if the functionality I'm looking for doesn't exist?

Submit a pull request here: https://github.com/bcbi/BioMedQuery.jl/pulls)

---
## Entrez Utilities (eutils)

BiomedQuery.Entrez provides an interface to some of the functionality in the [Entrez Utility API](https://www.ncbi.nlm.nih.gov/books/NBK25501/).

The following E-utils functions have been implemented:

* ESearch
* EFetch
* ELink
* ESummary

---
#### Functions available to handle and store NCBI responses

* EParse - Convert XML response to Julia Dict
* Saving NCBI Responses to XML
* Saving EFetch to a SQLite database
* Saving EFetch to a MySQL database
* Saving EFetch to a publication file (bibtex or endnote)

---
#### Functions  available to query the database

* All PMIDs
* All MESH descriptors for an article

---
### Before we start

(AWS users ... skip)
* Attach another interactive shell to your docker container

```
docker exec -it bcbi_julia_edu /bin/bash
```

* Create your .juliarc.jl file

```
cd ~
touch .juliarc.jl
```

---
(AWS users ... skip)
* Write your environment variables

```
emacs .juliarc.jl
```

    Type the following ENV variables

    ENV["NCBI_EMAIL"]="first_last@brown.edu"
    ENV["UMLS_USER"]="user"
    ENV["UMLS_PSSWD"]="password"

    To save: ctrl-x ctrl-s
    To quit: ctrl-x ctrl-c

* Start mysql service

```
sudo /etc/init.d/mysql start
```

---
### Let's start with ENTREZ

Create a Julia notebook called entrez

+++
### Import the Module and Environment Variables

* Regular users:

```julia
using BioMedQuery.Entrez
email = ENV["NCBI_EMAIL"];
umls_user = ENV["UMLS_USER"];
umls_psswd = ENV["UMLS_PSSWD"];
```

* AWS users:

```julia
using BioMedQuery.Entrez
email = "your email";
umls_user = "your umls user";
umls_psswd = IJulia.readprompt("UMLS password", password=true);
```

+++
### esearch

Request a list of UIDS matching a query from an input dictionary specifying all required parameters specified in the Entrez documentation [NCBI Entrez:Esearch](http://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.ESearch).

+++

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

+++
### Save the response to file


```julia
using XMLconvert
xmlASCII2file(esearch_response, "./esearch.xml");
```

+++
### Convert to a Julia (Multi) Dictionary

```julia
esearch_dict = eparse(esearch_response)
println("Type of esearch_dict: ", typeof(esearch_dict))
show_key_structure(esearch_dict)
```

+++
### Flatten into Dictionary for easy access


```julia
flat_easearch_dict = flatten(esearch_dict)
display(flat_easearch_dict)
```
+++

### Get all pmids returned by esearch


```julia
ids = Array{Int64,1}(flat_easearch_dict["IdList-Id" ])
```

+++
## efetch


```julia
# define the fetch dictionary
fetch_dic = Dict("db"=>"pubmed","tool" =>"BioJulia",
"email" => "maria_restrepo@brown.edu", "retmode" => "xml", "rettype"=>"null")

# fetch
efetch_response = efetch(fetch_dic, ids)
```

+++
### Convert to XML respose to (Multi) Dictionary


```julia
efetch_dict = eparse(efetch_response)
show_key_structure(efetch_dict)
```

+++
## Save to MySQL


```julia
db_config = Dict(:host=>"127.0.0.1",
                 :dbname=>"biomed_query_test",
                 :username=>"root",
                 :pswd=>"bcbi123",
                 :overwrite=>true)

db = save_efetch_mysql(efetch_dict, db_config)
```

+++
## MySQL Schema

![Schema](/images/save_efetch_schema.jpeg)

+++
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
+++
##Save as publications


```julia
citation_config = Dict(:type => "bibtex", :output_file => "citations_test.bib", :overwrite=>true)
    save_article_citations(efetch_dict, citation_config);
```

+++
### BioMedQuery.Processes

The library comes with a series a "pre-assembled" workflows. For instance, we often need to call esearc, efetch and save to database as a pipeline.


```julia
using BioMedQuery.Processes
```

+++
### esearch, efetch, mysql_save in one line of code


```julia
db = pubmed_search_and_save(email, search_term, 10,
    save_efetch_mysql, db_config);
```

+++
### esearch, efetch, save citations in one line of code


```julia
pubmed_search_and_save(email, search_term, 10,
    save_article_citations, citation_config);
```

---
### Let's start with UMLS

Create a Julia notebook called umls

+++
### BioMedQuery.UMLS


Utilities to search the Unified Medical Language System (UMLS). This is a Julia interface to their [REST API](https://documentation.uts.nlm.nih.gov/rest/home.html).

Searching the UMLS requires approved credentials. You can sign up [here](https://uts.nlm.nih.gov//license.html)

As of today, the following utilities are available:

* verify credentials / issue umls tickets
* search_umls
* get the best maching cui from a query
* get the semantic type

+++
### Set Up


```julia
using BioMedQuery.UMLS
user = ENV["UMLS_USER"];
psswd = ENV["UMLS_PSSWD"];
credentials = Credentials(user, psswd)
query = Dict("string"=>"asthma", "searchType"=>"exact")
```

+++
### Get a ticket and submit query


```julia
tgt = get_tgt(credentials)
all_results = search_umls(tgt, query)
```

+++
###  Get best matching cui and it's semantic type


```julia
cui = best_match_cui(all_results)
display(cui)
sm = get_semantic_type(tgt, cui)
display(sm)
```

+++
### Processes available for UMLS

* Get all UMLS semantic types for all MeSH stored in a database corresponding to results from an Entrez query


```julia
using BioMedQuery.Processes
using MySQL

db_host = "127.0.0.1"
mysql_usr = "root"
mysql_pswd = "bcbi123"
dbname = "biomed_query_test"

db = mysql_connect(db_host, mysql_usr, mysql_pswd, dbname)

map_mesh_to_umls_async!(db, credentials)

```
```julia
tables = mysql_execute(db, "show tables;")
display(tables)
```


```julia
mesh2umls = mysql_execute(db, "select * from mesh2umls")
display(mesh2umls)
```

+++
* Filter by semantic type: For all articles in the 'results' database, filter all MeSH associated with a specific semantic type


```julia
labels2ind, occur = umls_semantic_occurrences(db, "Disease or Syndrome")

println("-------------------------------------------------------------")
println("Output Descritor to Index Dictionary")
display(labels2ind)
println("-------------------------------------------------------------")

println("-------------------------------------------------------------")
println("Output Data Matrix")
display(full(occur))
println("-------------------------------------------------------------")

```

+++
### Plot conditional probabilities as a histogram


```julia
collect(keys(labels2ind))
```
```julia
using PlotlyJS

trace1 = bar(;x=collect(keys(labels2ind)),
            y=sum(occur, 2)[:]./10,
            marker=attr(color="rgba(50, 171, 96, 0.7)",
            line=attr(color="rgba(50, 171, 96, 1.0)", width=2)))

data = [trace1]
layout = Layout(;margin_b = 100,
                 margin_r =100)

plot(data, layout)
```
