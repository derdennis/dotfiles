## Sort Markdown Footnotes

This is a Python script to sort Markdown footnote markers like `[^fn1]` into
their order of appearance in the text.

It reads a Markdown file via standard input and tidies the containing
Multimarkdown footnotes. The reference links will be numbered in
the order they appear in the text and placed at the bottom
of the file.

The needed Markdown footnotes syntax can be easily created by using Vim and
[my fork of the vim-markdownfootnotes plugin][1].


### Usage
Basically, it transfers a text like:

~~~
Well, the way they make shows is, they make one show. That show's called
a pilot[^dn2]. Then they show that show to the people who make shows, and on the
strength of that one show they decide if they're going to make more shows. Some
pilots get picked and become television programs. Some don't, become nothing.
She starred in one of the ones that became nothing.

Now that there is the Tec-9[^dn1], a crappy spray gun from South Miami. This gun is
advertised as the most popular gun in American crime. Do you believe that shit?
It actually says that in the little book that comes with it: the most popular
gun in American crime. Like they're actually proud of that shit[^dn3]. 

[^dn1]: This is a footnote concerning the Tec-9, it was the first that was written...

[^dn2]: This is the second footnote I added, it's marker appears in the text before the marker of the first footnote...

[^dn3]: This is the third footnote I added, it's marker is the last in the text...
~~~

into:

~~~
Well, the way they make shows is, they make one show. That show's called
a pilot[^dn1]. Then they show that show to the people who make shows, and on the
strength of that one show they decide if they're going to make more shows. Some
pilots get picked and become television programs. Some don't, become nothing.
She starred in one of the ones that became nothing.

Now that there is the Tec-9[^dn2], a crappy spray gun from South Miami. This gun is
advertised as the most popular gun in American crime. Do you believe that shit?
It actually says that in the little book that comes with it: the most popular
gun in American crime. Like they're actually proud of that shit[^dn3]. 

[^dn1]: This is the second footnote I added, it's marker appears in the text before the marker of the first footnote...

[^dn2]: This is a footnote concerning the Tec-9, it was the first that was written...

[^dn3]: This is the third footnote I added, it's marker is the last in the text...
~~~

Markdown does not care a bit about the order in which the footnotes appear in
the text. Both texts above render to the exact same HTML. But it is just *much*
nicer looking, isn't it?

#### Commandline usage

    cat ugly-text.markdown | sort_footnotes > beautiful-text.markdown

#### Usage with Vim

I define the following mapping in my `.vimrc`:

    " Sort footnotes into order of appearance
    nnoremap <leader>fs mm :%! ~/bin/sort_footnotes<CR> `m :delmarks m<CR>

And just call `<Leader>fs` whenever I feel my footnotes should get sorted.

### Credits

The whole script is based on the post [Tidying Markdown reference links][2] by
Dr. Drang.

### Caveats

Do *not* place footnote reference links at the start of a line, bad things will
happen, your footnotes will be eaten by a grue.


[1]: https://github.com/derdennis/vim-markdownfootnotes
[2]: http://www.leancrew.com/all-this/2012/09/tidying-markdown-reference-links/
