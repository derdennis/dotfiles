" Dennis .vimrc
" This time, finally, it should be well layed out...
"
" 07.12.2010


" Enabling pathogen.vim
" The filetype off statement is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off 
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" This is vim not vi. Also: 1970 is gone.
set nocompatible

" Make backspace behave nicely on some obscure platforms
set backspace=indent,eol,start

" There are some security issues with modelines in files. I only have some
" vague understanding what modelines are anyway, so I'm not that much hurt by
" turning them off.
set modelines=0

" We want UTF-8 goodness.
set encoding=utf-8
" keep 3 lines when scrolling
set scrolloff=3
" Higlight the current line (use set cursorcolumn for the current column
set cursorline
" Show me the mode I'm in
set showmode
" Todays terminals are quite fast. This setting smoothes scrolling
set ttyfast

" Make the window title reflect the file being edited
set title
set titlestring=VIM:\ %F

" At command line, complete longest common string, then list alternatives.
set wildmenu
set wildmode=list:longest,full

" If available, ignore the case of the completion
if exists("&wildignorecase")
    set wildignorecase
endif

" Automatically insert the current comment leader
" after hitting 'o' or 'O' in Normal mode.
set fo+=o

" Do not automatically insert a comment leader after an enter
set fo-=r

" Do no auto-wrap text using textwidth (does not apply to comments)
set fo-=t

" Turn off the bell
set vb t_vb=

" Enable the mouse
set mouse=a
behave xterm
set selectmode=mouse

" Show invisible characters (only here to remind me how to turn it on and off)
" See http://vimcasts.org/episodes/show-invisibles/ for more information
set listchars=trail:.,tab:>-,eol:¬
"set list
set nolist

" Show incomplete paragraphs
set display+=lastline

" Turn on info ruler at the bottom
set ruler

" Make sure status line is always visible
set laststatus=2

" Make command line two lines high
set ch=2

" Make window height VERY large so they always maximise on window switch
set winheight=9999

" Fix the height of the preview window (would be one line otherwise
" because of the winheight of 9999). Fix via:
" http://stackoverflow.com/questions/3712725/can-i-change-vim-completion
" -preview-window-height
set previewheight=20
au BufEnter ?* call PreviewHeightWorkAround()
func PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunc

" Show the current branch in the statusline
set statusline+=%{fugitive#statusline()}

" Make Syntastic show syntax errors in the statusline and at the side
" Use SyntasticEnable and SyntasticDisable to turn it on and off
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

" change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Turn on syntax highlighting
syntax on

" Make sure, one can see comments on a dark background (terminal) while
" keeping things bright in GUI-mode
if has('gui_running')
    set background=light
else
    set background=dark
endif

" If no GUI is running make sure to display 256 colors
if !has("gui_running")
        set term=screen-256color
    endif

" Set light/dark Switch for solarized on F5-key
function! ToggleBackground()
        if (g:solarized_style=="dark")
        let g:solarized_style="light"
        colorscheme solarized
    else
        let g:solarized_style="dark"
        colorscheme solarized
    endif
    endfunction
    command! Togbg call ToggleBackground()
    nnoremap <F5> :call ToggleBackground()<CR>
    inoremap <F5> <ESC>:call ToggleBackground()<CR>a
    vnoremap <F5> <ESC>:call ToggleBackground()<CR>

" This is needed to get good results on putty
" via: http://stackoverflow.com/questions/5560658/ubuntu-vim-and-the-solarized-color-palette
se t_Co=256

" Turn on the Solarized colorscheme (See http://ethanschoonover.com/solarized)
colorscheme solarized

" Use a nice OS X Font, Size 12
set guifont=Bitstream\ Vera\ Sans\ Mono:h12

" Have Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Have Vim load indentation rules and plugins according to the detected filetype.
filetype plugin indent on

" Tab Settings put together from http://www.vex.net/~x/python_and_vim.html and
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/#making-vim-more-useful.
" There is also an useful Vimcast about these things:
" http://vimcasts.org/episodes/tabs-and-spaces/
"
" A four-space tab indent width is the prefered coding style for Python (and
" everything else!), although of course some disagree.
set tabstop=4
" Use < and > from visual mode to indent/undindent whole blocks
set shiftwidth=4
" People like using real tab character instead of spaces because it makes it
" easier when pressing BACKSPACE or DELETE, since if the indent is using spaces
" it will take 4 keystrokes to delete the indent. Using this setting, however,
" makes VIM see multiple space characters as tabstops, and so <BS> does the
" right thing and will delete four spaces (assuming 4 is your setting).
set softtabstop=4
"Insert spaces instead of <TAB> character when the <TAB> key is pressed. This
"is also the prefered method of Python coding, since Python is especially
"sensitive to problems with indenting which can occur when people load files in
"different editors with different tab settings, and also cutting and pasting
"between applications (ie email/news for example) can result in problems. It is
"safer and more portable to use spaces for indenting.
set expandtab
" Use the "shiftwidth" setting for inserting <TAB>s instead of the "tabstop"
" setting, when at the beginning of a line. This may be redundant for most
" people, but some poeple like to keep their tabstop=8 for compatability when
" loading files, but setting shiftwidth=4 for nicer coding style. 
set smarttab
" Very painful to live without this (especially with Python)! It means that
" when you press RETURN and a new line is created, the indent of the new line
" will match that of the previous line. 
" 
" This, of course, destroys Copy & Paste from Browsers etc...
" To deactivate :set paste, do your thing, and :set nopaste to reverse it.
set autoindent

" The following line sets the smartindent mode for *.py files. It means that
" after typing lines which start with any of the keywords in the list (ie. def,
" class, if, etc) the next line will automatically indent itself to the next
" level of indentation:
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class 

" Remove any extra whitespace from the ends of lines in *.py files when saving:
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

" (Almost) straight from the standard Debian .vimrc and highly recommended.

" Searching stuff

" Shortcuts for ack:
" o to open (same as enter)
" go to preview file (open but maintain focus on ack.vim results)
" t to open in new tab
" T to open in new tab silently
" q to close the quickfix window
" Make the ack plugin work even faster (Notice the space at EOL of next line)
nnoremap <leader>a :Ack --smart-case -a 

" Fix Vim’s horribly broken default regex “handling” by automatically
" inserting a \v before any string you search for. This turns off Vim’s
" crazy default regex characters and makes searches use normal regexes.
nnoremap / /\v
vnoremap / /\v

set showmatch           " Show matching brackets
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
set incsearch           " Incremental search
set hlsearch            " Highlight the results

" makes it easy to clear out a search highlight by typing ,<space>
nnoremap <leader><space> :noh<cr>

" Applies substitutions globally on lines. This is almost always what you
" want (when was the last time you wanted to only replace the first occurrence
" of a word on a line?) and if you need the previous behavior you just tack on 
" the g again.
set gdefault

set showcmd             " Show (partial) command in status line
set autowrite           " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned

" make the tab key match bracket pairs. Much easier to type than %
nnoremap <tab> %
vnoremap <tab> %

" make Y copy until end of line, use yy to copy whole line
" same way D & dd and C & CC are working...
map Y y$

" Prevent Backupfiles to be created. If disabled, vim create file.txt~ files
" all over the place...
set nobackup

" Break whole words when a line ends, Linebreak after 79 chars
" via: http://aaron-mueller.de/artikel/vim-mastery-Absatzweise
set wrap
set linebreak
set textwidth=79
set formatoptions=qrn1
" See ":help fo-table" and the Vimcasts on soft wrapping and hard wrapping for
" more information.

" Line Numbers, off with :set nonu
set nu

" Disabling arrow keys in normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Disabling arrow keys in insert mode (helps to get hjkl working in muscle
" memory)
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" Make j and k move by screen line instead of the archaic move by file line
nnoremap j gj
nnoremap k gk

" Split vertically and change to new view by pressing ,w
nnoremap <leader>w <C-w>v<C-w>l

" Easy split-window navigation, kills the need to do C-w followed by h,j,k,l
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Easy Tab navigation
map th :tabfirst<CR>
map tk :tabnext<CR>
map tj :tabprev<CR>
map tl :tablast<CR>
map tt :tabedit<Space>
map tn :tabnext<Space>
map tm :tabm<Space>

" Make CTRL-m jump to the next diff in vimdiff
map <C-m> ]c

" Map some shortcuts for fugitive.vim
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

" Switch on the nerdtree with ,n
map <Leader>n :execute 'NERDTreeToggle ' . getcwd()<CR> 

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Mappings for starting a file search with Command-T:
" Start a project-wide search with ,f and search the
" directory of the current file with ,F:
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>'

" Open the current file with Marked.app for a Markdown preview (OS X only)
nnoremap <leader>m :silent !open -a Marked.app '%:p'<CR>

" This sets SuperTab’s completion type to “context”. Which lets it determine
" how things should be tab-completed.
let g:SuperTabDefaultCompletionType = "context"

" Underline the current line with = or - by hitting ",1" or ",2"
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

" Make vim complete lists starting with a "-"
" via:
" http://stackoverflow.com/questions/9065967/markdown-lists-in-vim-automatically-new-bullet-on-cr
set com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-

" Vim 7.3 (Not very widespread, therfore commented) features:
"
" Enable relative line numbers. Very useful for move commands
"set relativenumber
" Keep a <filename>.un~ file to enable undo even after :q
"set undofile
" colorcolumn draws a line at the desired column. Helps to avoid
" spaghetticode
"set colorcolumn=85

