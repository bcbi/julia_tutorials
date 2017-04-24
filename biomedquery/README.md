# Introduction to BioMedQuery.jl

[![Slides](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/bcbi/julia_tutorials/master?grs=github&t=white&p=biomedquery)

## Configuration

Our scripts will depend on our email, umls/uts username, which will be stored
as enviroment variables.

1. Start an interactive shell to your docker container

    ```
    docker exec -it bcbi_julia /bin/bash
    ```

2. Create your .juliarc.jl file

    ```
    cd ~
    touch .juliarc.jl
    ```

3. Write your environment variables

    ```
    emacs .juliarc.jl
    ```

    Type the following ENV variables

    ENV["NCBI_EMAIL"]="first_last@brown.edu"
    ENV["UMLS_USER"]="user"
    ENV["UMLS_PSSWD"]="password"
    ENV["PBCBICIT_USER"]="mysql_user"
    ENV["PBCBICIT_PSSWD"]="mysql_password"

4. Start mysql service

    ```
    sudo /etc/init.d/mysql start
    ```
