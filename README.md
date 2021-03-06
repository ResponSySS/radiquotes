# Radiquotes

Twitter app/bot for Aufhebung at <http://twitter.com/AufhebungOff>.  
Posts pictures of quotes from radical authors.  
**Requires: [libsyl.sh](http://github.com/ResponSySS/bash-libsyl/), [situation.sh](http://github.com/ResponSySS/situation/)**

## Process
* *quotes.txt* :        stores pre-formatted quote list  
* *format-quotes.vim* :	vim script for formatting quote list  
* *quotes* :            stores formatted quote list via *format-quotes.vim*  
* *situation.sh* :      quote image creator (<https://github.com/ResponSySS/situation>)
* *render.sh* :	        renderer  
* *tweet.sh* :          tweeter  
 
 1. `make quotes` turns `quotes.txt` into `quotes` with `format-quotes.vim`
 2. `./render.sh` use `quotes` to make quote images in *./Renders/* with `situation.sh`
 2. `./tweet.sh ./Renders/*` tweets random file from *./Renders/*
 
 Name format for rendered quote images: 	`{author}-{6 words}.png`  
 Example: `Karl_Marx-La_société_est_sauvée_aussi_souvent.png`  
 
 `quotes.txt` 	-> `quotes` 	-> `{render dir}/{author}-{6 words}.png`

## Format of *quotes.txt*
 Do not use at sign (`@`) in this file.  
 Must be formatted as follows:  

	# {comments}
	{text1}
	--- {author1}, {book1} [...]
	{text2}
	--- {author2}, {book2} [...]

## Format of *quotes*
 Two `@`-separated fields, 1st is quote, 2nd is source.  
 Must be formatted as follows:  

	{text1}@{author1}, {book1} [...]
	{text2}@{author2}, {book2} [...]

## Authors
 Collectif Aufhebung: <http://aufhebung.fr>  
 Written by Sylvain Saubier (<http://SystemicResponse.com>)  
 Report bugs at: <feedback@sylsau.com>  
