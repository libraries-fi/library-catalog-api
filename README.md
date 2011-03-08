## Creating code examples

Project uses Pygmentize to generate code examples in HTML. Example files are in doc-directory.

### Generating stylesheet

    pygmentize -f html -S friendly -a .highlight

### Generating JSON example

    pygmentize -l javascript -f html -o test.html test.json

### Generating Ruby example

    pygmentize -f html -o test.html test.rb
