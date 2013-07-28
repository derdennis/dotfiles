""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Dennis .vimrc - Configuration for the improved Vi Edtor
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Handling Plugins with Pathogen
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enabling pathogen.vim
" The filetype off statement is needed on some linux distros.
" see http://www.adamlowe.me/2009/12/vim-destroys-all-other-rails-editors.html
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" My leaderkey is the ","
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" change the mapleader from \ to ,
let mapleader=","

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Basic Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This is vim not vi. Also: 1970 is gone.
set nocompatible
" Make backspace behave nicely on some obscure platforms
set backspace=indent,eol,start
" There are some security issues with modelines in files. I only have some
" vague understanding what modelines are anyway, so I'm not that much hurt by
" turning them off.
set modelines=0
" Line Numbers, off with :set nonu
set nu
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
" Turn off the bell
set vb t_vb=
" Make command line two lines high
set ch=2
" Show (partial) command in status line
set showcmd
" Automatically save before commands like :next and :make
set autowrite
" Hide buffers when they are abandoned
set hidden
" Remember more commands and search history
set history=1000
" Use many muchos levels of undo
set undolevels=1000
" Prevent Backupfiles to be created. If disabled, vim create file.txt~ files
" all over the place...
set nobackup
" Don't litter .swp files
set noswapfile
" Have Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" Have Vim load indentation rules and plugins according to the detected filetype.
filetype plugin indent on
" Quickly edit/reload the vimrc file
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>
" fix damn "crontab: temp file must be edited in place" error on OS X
set backupskip=/tmp/*,/private/tmp/*" 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Mouse settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable the mouse
set mouse=a
behave xterm
set selectmode=mouse

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Status line settings (Should be overwritten by Powerline-Plugin)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on info ruler at the bottom
set ruler
" Make sure status line is always visible
set laststatus=2
" Show filename, file content type and current column and line in the status
" bar. Use %= to right aline the possibly following fugitive and syntastic status
set statusline=%t\ %y\ [%c,%l]%=
" Append the current branch in the statusline if we are in a git repository
set statusline+=%{fugitive#statusline()}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Colors, themes and syntax highlighting
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
call togglebg#map("<F5>")
" This is needed to get good results on putty
" via: http://stackoverflow.com/questions/5560658/ubuntu-vim-and-the-solarized-color-palette
se t_Co=256
" Turn on the Solarized colorscheme (See http://ethanschoonover.com/solarized)
colorscheme solarized

"   For Panic Prompt that lacks presets run the 256-colour-version, and
"   don't use a background colour due to rendering issue.
if &term == "xterm-color"
    set t_Co=256
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
endif

" Powerline FontStuff
" Use the patched DejaVu Font for gvim and macvim
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h13
set rtp+=~/.dotfiles/powerline/bindings/vim

" Show invisible characters (only here to remind me how to turn it on and off)
" See http://vimcasts.org/episodes/show-invisibles/ for more information
set listchars=trail:·,tab:→\ ,eol:¬
"set list
set nolist
" Show incomplete paragraphs
set display+=lastline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Tabs, indentation and whitespace
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
" Remove all trailing whitespace in the current file by hitting ,W
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Search & Find & Change
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cheatsheet for searching inline
" fx: Search forward for x
" Fx: Search backward for x
"
" Cheatsheet for Most Recently used Files (MRU):
" Just enter :MRU in normal mode to get the MRU window...
"
" Cheatsheet for ack:
" o to open (same as enter)
" go to preview file (open but maintain focus on ack.vim results)
" t to open in new tab
" T to open in new tab silently
" q to close the quickfix window
" Make the ack plugin work even faster (Notice the space at EOL of next line)
nnoremap <leader>a :Ack --smart-case -a 
" Remap search characters to space (forward search) and ctrl-space (backward
" search)
noremap <space> /
noremap <c-space> ?
" Fix Vim’s horribly broken default regex “handling” by automatically
" inserting a \v before any string you search for. This turns off Vim’s
" crazy default regex characters and makes searches use normal regexes.
nnoremap / /\v
vnoremap / /\v
" (Almost) straight from the standard Debian .vimrc and highly recommended.
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

" Use the TaskList plugin via ,T to check for TODO, FIXME and XXX
map <leader>T <Plug>TaskList


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Linebreaks, wrappings and format options
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Break whole words when a line ends, Linebreak after 79 chars
" via: http://aaron-mueller.de/artikel/vim-mastery-Absatzweise
set wrap
set linebreak
" Quick Cheatsheet for reformating to 79 chars per line:
" gggqG: Reformat the whole enchilada
nnoremap <leader>Q gggqG
" gqip: Reformat the current paragraph
nnoremap <leader>q gqip
" (visual-selection) gq: Reformart the selection
set textwidth=79
" See ":help fo-table" and the Vimcasts on soft wrapping and hard wrapping for
" more information.
set formatoptions=tcroqln1
" Start at level 10 with foldings
set foldlevelstart=10

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Command mode and shell execution
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" At command line, complete longest common string, then list alternatives.
set wildmenu
set wildmode=list:longest,full
" If available, ignore the case of the completion
if exists("&wildignorecase")
    set wildignorecase
endif
" Make clam jump on the !
nnoremap ! :Clam<space>
vnoremap ! :ClamVisual<space>
" Command Mode mappings
" $q is super useful when browsing on the command line. It deletes everything until
" the last slash:
cno $q <C-\>eDeleteTillSlash()<cr>
" Bash like keys for the command line:
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
" automatically give executable permissions if file begins with #! and contains
" '/bin/' in the path
function! ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "/bin/"
      silent !chmod a+x  <afile>
    endif
  endif
endfunction

au BufWritePost * call ModeChange()
" sudo to write to files I don't have permission to...
cnoremap w!! w !sudo tee % >/dev/null

" Vimux Integration for some nice 20% tmux-split actions...
let VimuxUseNearestPane = 1
" Prompt for a command to run
map rp :VimuxPromptCommand<cr>
" Run last command executed by VimuxPromptCommand
map rl :VimuxRunLastCommand<cr>
" Interrupt any command running in the runner pane
map rs :VimuxInterruptRunner<cr>
" Close vimux runner pane
map rx :VimuxCloseRunner<cr>

" Navigating vim and tmux splits
" http://www.codeography.com/2013/06/19/navigating-vim-and-tmux-splits
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      " The sleep and & gives time to get back to vim so tmux's focus tracking
      " can kick in and send us our ^[[O
      execute "silent !sh -c 'sleep 0.01; tmux select-pane -" . a:tmuxdir . "' &"
      redraw!
    endif
  endfunction
  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te
  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Copy & Pasting and Completion
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cheatsheet for omnicompletion:
" via: http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/
"
" CTRL-x CTRL-n : Word completion – forward
" CTRL-x CTRL-p : Word completion – backward
" CTRL-x CTRL-l : Line completion
" CTRL-x CTRL-f : File completion
" CTRL-x CTRL-k : Dictionary completion FIXME?
" CTRL-x CTRL-t : Thesaurus completion FIXME?
" CTRL-x CTRL-o : Omni completion FIXME?
"

set thesaurus+=~/.dotfiles/txt/openthesaurus.txt

" ,v mapping to reselect the text that was just pasted so I can perform
" commands (like indentation) on it
nnoremap <leader>v V`]
" make Y copy until end of line, use yy to copy whole line
" same way D & dd and C & CC are working...
nnoremap Y y$
" Map Gundo to F3
nnoremap <F3> :GundoToggle<CR>
" This sets SuperTab’s completion type to “context”. Which lets it determine
" how things should be tab-completed.
let g:SuperTabDefaultCompletionType = "context"

" make the tab key match bracket pairs. Much easier to type than %
nnoremap <tab> %
vnoremap <tab> %
" J Joins lines, K kracks lines. Makes that K splits the current line
nnoremap K i<CR><Esc>
" Map the YankRing Window toggle to F11
:nnoremap <silent> <F11> :YRShow<CR>
" Move the yankring file out of ~ and into the .vim_local dir
let g:yankring_history_dir = '~/.vim_local'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Navigation and movement through buffers, splits, tabs, files
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Split Cheatsheet
" ===================
" Resizing Splits
" ---------------
" Max out the height of the current split
" ctrl + w _
" Max out the width of the current split
" ctrl + w |
" Normalize all split sizes, which is very handy when resizing terminal
" ctrl + w =
" Even more Split Manipulation
" ----------------------------
" Swap top/bottom or left/right split
" Ctrl+W R
" Break out current window into a new tabview
" Ctrl+W T
" Close every window in the current tabview but the current one
" Ctrl+W o

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
" Make cursor move as expected with wrapped lines in insert mode
inoremap <up> <C-o>gk
inoremap <down> <C-o>gj
" Make j and k move by screen line instead of the archaic move by file line
nnoremap j gj
nnoremap k gk
" Split vertically and change to new view by pressing ,w
nnoremap <leader>w <C-w>v<C-w>l
" Easy split-window navigation, kills the need to do C-w followed by h,j,k,l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Open new split panes to right and bottom, feels way more natural...
set splitbelow
set splitright
" Easy Tab navigation
noremap th :tabfirst<CR>
noremap tl :tablast<CR>
noremap tk :tabnext<CR>
noremap tj :tabprev<CR>
noremap tn :tabnew<Space>
noremap tm :tabm<Space> " Tabmove to position #
noremap tx :tabclose<CR>
" Switch on the nerdtree with ,n
noremap <Leader>n :execute 'NERDTreeToggle ' . getcwd()<CR>
" Open the Command-T window with ,t
nnoremap <silent> <Leader>t :CommandT<CR>
" mapping to easily change directory to the file being edited, prints pwd
" afterwards
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" All things Markdown
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setting default fileformat for markdown and textile to octopress
autocmd BufNewFile,BufRead *.markdown,*.textile set filetype=octopress
" Make SnipMate's markdown snippets work with the octopress filetype
let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['octopress'] = 'markdown'
" Create Headings. Underline the current line with = or - by hitting ",1" or ",2"
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-
" Create a Markdown-link structure for the current word or visual selection with
" leader 3. Paste in the URL later. Or use leader 4 to insert the current
" system clipboard as an URL.
nnoremap <Leader>3 ciw[<C-r>"]()<Esc>
vnoremap <Leader>3 c[<C-r>"]()<Esc>
nnoremap <Leader>4 ciw[<C-r>"](<Esc>"*pli)<Esc>
vnoremap <Leader>4 c[<C-r>"](<Esc>"*pli)<Esc>
" Open the current file with Marked.app for a Markdown preview (OS X only)
nnoremap <leader>m :silent !open -a Marked.app '%:p'<CR>
" Use formd to transfer markdown from inline to reference links and vice versa
" see: http://drbunsen.github.com/formd/
nnoremap <leader>fr :%! ~/bin/formd -r<CR>
nnoremap <leader>fi :%! ~/bin/formd -i<CR>
" Use convert_footnotes to make MultiMarkdown footnotes out of (*Some
" footnote*)...
" Original Script by Brett Terpstra, see:
" http://brettterpstra.com/2012/01/24/a-service-for-writing-multimarkdown-footnotes-inline/
nnoremap <leader>fn :%! ~/bin/convert_footnotes<CR>
" Make vim complete lists starting with a "-"
" via:
" http://stackoverflow.com/questions/9065967/markdown-lists-in-vim-automatically-new-bullet-on-cr
set com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-

" Disable plastic boys folding
" via: https://github.com/mutewinter/vim-markdown/commit/8f804c189ce45bff61f388d66ef5c3d4da03a9ce
let g:vim_markdown_folding_disabled=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Version control and diffing
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make CTRL-m jump to the next diff in vimdiff
noremap <C-m> ]c
" Map some shortcuts for fugitive.vim
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

" run :Gc my-branch to checkout a branch, or :Gc -b new-branch to create a new one.
" via: http://dailyvim.tumblr.com/post/44147584103/handy-git-checkout-function
function! s:GitCheckout(...)
  :silent execute 'Git checkout ' . a:1 . ' > /dev/null 2>&1' | redraw!
endfunction
command! -nargs=1 Gc call s:GitCheckout(<f-args>)

"  add spell checking and automatic wrapping at the recommended 72 columns to
"  you commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Abbreviations - For more sophisticated things see the snipmate-snippets bundle 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General things
ab ddw Dennis Wegner
ab mfg Mit freundlichen Grüßen

" Mail
ab ddit dennis@instant-thinking.de
ab ddst dennis.wegner@steag.com

" Date and time stamps
ab <expr> dds strftime("%Y-%m-%d")
ab <expr> tts strftime("%Y-%m-%d %H:%M")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" MacVim specific config
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_macvim")
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Setting up OS X specific stuff
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    " Setting shortcuts for Dash on OS X
    nmap <silent> <leader>h <Plug>DashSearch
    nmap <silent> <leader>H <Plug>DashGlobalSearch
  endif
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Vim 7.3 features
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim 7.3 (Not very widespread under Linux, therfore ifed) features:
if v:version >= 703
    " Relative Line numbers
    " Enable relative line numbers. Very useful for move commands
    set relativenumber
    " When vim is not in focus, set absolute numbers
    :au FocusLost * :set number
    :au FocusGained * :set relativenumber
    " Use absolute numbers in insert mode
    autocmd InsertEnter * :set number
    autocmd InsertLeave * :set relativenumber
    " Function to toggle the relative numbering with F6
    function! NumberToggle()
        if(&relativenumber == 1)
            set number
        else
            set relativenumber
        endif
    endfunc
    nnoremap <F6> :call NumberToggle()<cr>

    " Keep a <filename>.un~ file to enable undo even after :q. Keep all
    " undo-files in a separate undodir
    set undodir=~/.vim_local/undodir
    set undofile
    " maximum number of changes that can be undone
    set undolevels=1000
    " maximum number lines to save for undo on a buffer reload
    set undoreload=10000

    " colorcolumn draws a line at the desired column. Helps to avoid spaghetticode
    set colorcolumn=85

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Rechtschreibprüfung / Spellcheck
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let b:myLang=0
let g:myLangList=["nospell","de_de","en_gb"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction
nnoremap <silent> <F7> :call ToggleSpell()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Syntastic checks for Syntax Errors
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Syntastic show syntax errors in the statusline and at the side
" Use SyntasticEnable and SyntasticDisable to turn it on and off
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" EOF
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
