## Setup Documentation

### Install ruby

    Recommended version 1.9.2

### Install postgresql

### Install bundler
    
    http://gembundler.com/

### Run bundle in the application's root folder

    $ bundle
    
### Create the database.yml file inside the config folder
  
    Inside the config folder there is an example on how to do this (database.example.yml)

### Create the database
    
    $ rake db:create
    
### Run the migrations

    $ rake db:migrate
  
### Import the data

    $ rake load_marcxml_files FILE=replace_this_with_the_name_of_the_marcxml_file_you_want_to_import.xml

### Deploy the application

    Use Apache web server and Phusion Passenger (or whatever you're comfortable with)
    

## Creating code examples

Project uses Pygmentize to generate code examples in HTML.

### Generating stylesheet

    pygmentize -f html -S friendly -a .highlight

### Generating JSON example

    pygmentize -l javascript -f html -o test.html test.json

### Generating Ruby example

    pygmentize -f html -o test.html test.rb
