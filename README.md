PDF Combiner
===========
A simple shell script that merges multiple pdfs into one while allowing for the use of a simple alias. The long ghostscript inside the script (referenced below) cannot easily be set with an alias, which is the purpose of this shell script.

<i>Thanks to Gery on Stack Overflow for providing the ghostscript command used in the shell script to merge the pdfs, original post can be found [here](https://stackoverflow.com/a/19358402/22990019)</i>

#### Setup
1. `cd` to a directory of your choice and clone the repository:
    ```
    $ git clone https://github.com/s7a19t4r/pdf-combine
    ```
2. `cd` into the cloned repository and move `pdfm.sh` into a directory of your choice, preferably a user library directory (e.g. `/usr/local/lib/`):
    ```
    # use sudo if the directory is outside your home directory
    $ mv pdfm.sh dir/of/your/choice/
    ```
3. Set up an `alias` so the file can easily be ran. Add the following to your `.bashrc` (or corresponding read command file depending on your shell)
    ```sh
    alias pdfm='dir/of/your/choice/pdfm.sh'

    # below is what is in my .bashrc
    alias pdfm='/usr/local/lib/pdfm.sh'
    ```

#### Usage
To use, simply type your chosen alias for `pdfm.sh`, followed by the name of the output file, then a space delimited list of input files.
```
$ pdfm <output-file> <input-files>
```
Example:
```
$ pdfm out.pdf file1.pdf file2.pdf file3.pdf
```
---
#### Technical Details
As mentioned in the main description, the reason for the creation of this shell script is so it can easily be aliased, preventing the need of typing out the long command.
This is because the name of the output file is passed into the `-sOutputFile` flag through an equal sign, which means it cannot contain a space (i.e. `-sOutputFile=out.pdf`)
When used as an alias, a whitespace appears before the first parameter so aliases function as normal. Take the following example:
```sh
alias l='ls -lha'
```
When the command `l /` is ran, it replaces `l` with `ls -lha`, which results in the command `ls -lha /`. Clearly, the white space before `/` is necessary so `ls -lha /` does not become `ls -lha/`.
To demonstrate the consequence of this, let us set another alias as follows, which sets the alias of an output file flag.
```sh
alias mycmd='somecmd <flags> -sOutputFile='
```
If we run
```
$ mycmd out.pdf
```
the command will become
```
$ somecmd <flags> -sOutputfile= out.pdf
```
when it is supposed to be
```
$ somecmd <flags> -sOutputfile=out.pdf
```
(note the space after the equal sign). This will cause the parser to think that there is no output file, or the output file is `NULL`.
If we want to try and remove the whitespace, the only thing we can do is run 
```
$ mycmdout.pdf
```
which clearly does not work. Additionally, setting the command as a function does not work either because function parameters are space delimited, which only allows for one additional file after the first one is designated as the output.
This brings us to the solution, which is to use the positional parameter variable in Bash: `$@`.

##### The Solution
The shell script presented in this repository solves this issue by taking in as many parameters as needed and parses it using `$@`.
It is parsed into two strings: one that takes the first parameter, which is the name of the output file, and the other with the rest of the parameters excluding the first parameter.
Those two strings can then be placed into the ghostscript and be functionally ran. 
The shell script can then be placed in a user defined library directory and properly aliased.

---
#### Footnotes
Original ghostscript does not generate a warning that the output file may be overwritten if it already exists, it was an added feature in the shell script.

