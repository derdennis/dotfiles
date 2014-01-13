" via:
" http://www.nickcoleman.org/blog/index.cgi?post=footnotevim%21201102211201%21programming
" Add a footnote
" NJC 20/02/11 added counter.  fine tuned cursor position and mark setting.
" NJC 20/02/11 fixed bug where pre-existing footnote was not accounted for with counter.
" Designed for HTML, it adds a footnote number and a footnote at the bottom of the page.
" It maintains an internal counter of the number of footnotes and automatically
" increments it each time.  On first call, it checks for any pre-existing footnotes
" using the pattern  <div class="footnote"
" It uses the q mark, to provide a quick way to return to the document body with `q.

" TODO If a footnote is added, then Undo, the footnote counter will not decrement and
" will be off by one.  A workaround is to manually set the counter with
" let b:footnote_number = x

function! Footnote()
    " save current position
    let s:cur_pos =  getpos(".")
    if !exists("b:footnote_number")
	let l:pattern = 'div class=\"footnote'
	let l:flags = 'eW'
	call cursor(1,1)
	" get first match
	let b:footnote_number = search(l:pattern, l:flags)
	if (b:footnote_number != 0)
	    let l:temp = 1
	    " count subsequent matches
	    while search(l:pattern, l:flags) != 0
		let l:temp += 1
		if l:temp > 50
		    redraw | echohl ErrorMsg | echo "Trouble in paradise: the while loop did not work"
		    break
		endif
	    endwhile
	    let b:footnote_number = l:temp + 1
	    call setpos(".", s:cur_pos)
	else
	    let b:footnote_number = 1
	endif
    else
	let b:footnote_number += 1
    endif
    let b:link = '<sup><small><a href="#fn' . b:footnote_number . '" id="back' . b:footnote_number . '">' . b:footnote_number . '</a></small></sup> '
    let b:footnote = [ '<div class="footnote">', '<a href="#back' . b:footnote_number .  '" id="fn' . b:footnote_number . '">[' . b:footnote_number. ']</a> <a href="#back' . b:footnote_number . '"> &uarr; </a>', '</div>']
    exe "normal a" . b:link
    " save current position as mark q for easy jump back with `q
    call setpos("'q", getpos("."))
    call append(line('$'), b:footnote)
    exe "normal \<S-G>\<Up>^3f\<Space>"
    exe "startinsert"
endfunction

