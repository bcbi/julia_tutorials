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
