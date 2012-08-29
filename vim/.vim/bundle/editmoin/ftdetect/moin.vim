" moin filetype file
" via:
" http://labix.org/editmoin
au! BufRead,BufNewFile *.moin
   \ let l=search("^$", 'n')
   \ | if search('^#format rst$', 'n', l) > 0 | setf rst
   \ | elseif search('^#format text_markdown$', 'n', l) > 0 | setf mkd
   \ | elseif getline(1) =~ '^@@ Syntax: 1\.5$' | setf moin1_5
   \ | else | setf moin1_6
   \ | endif


