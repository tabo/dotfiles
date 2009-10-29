" File:        .vimrc
" Author:      Gustavo Picon <'%s@%s.%s' % ('tabo', 'gpicon', 'org')>
" Last Change: 2009 Apr 12 (Vim 7.1)
" Download:    http://static.gpicon.org/code/vimrc.html
" Home:        http://gpicon.org
" License:     This file is placed in the publid domain
" Disclaimer:  Published as-is, no support, no warranty


" VIM extensions, not very VI compatible;
" this setting must be set because when vim
" finds a .vimrc on startup, it will set
" itself as "compatible" with vi
set nocompatible

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ignore this script if we're not using vim7
" note: most (if not all) of this vimrc will work, since I've been
" using it since 2000; it's just that I don't have vim5/6 around
" anymore
" TL;DR: edit the next line to use on vim6 at your own risk
if version >= 700

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" User Interface
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax highlighting, only if the feature is available and the
" terminal can display colors (or we're running gvim)
if has('syntax') && (&t_Co > 2 || has('win32') || has('gui_running'))

    " enable syntax highlighting
    syntax on

    " I'm too lazy to fix termcap/terminfo in servers on N different
    " platforms, so I'll just do this here...
    " NEW: I don't like how the background isn't black after I quit vim, I'll
    "      enable this again when I know how to fix that
    "if &term == "xterm-256color"
    "    set t_Co=256
    "endif

    if has('gui_running')
        colorscheme twilight
    "elseif &t_Co == 256
    "    colorscheme oceanblack256
    else
        " gah, fall back
        colorscheme elflord
    endif

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" display
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" welcome to the 21st century
set encoding=utf-8

" faster macros
set lazyredraw

" we like security
set nomodeline

" abbrev. of messages (avoids 'hit enter')
set shortmess+=a

" display the current mode
set showmode

" min num of lines to keep above/below the cursor
set scrolloff=2

" show line numbers
" I don't like this because it's annoying when copying and I'm used to ctrl-g
"set number

if has('cmdline_info')

    " show the ruler
    set ruler

    " a ruler on steroids
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

    " show partial commands in status line and selected characters/lines in
    " visual mode
    set showcmd

endif

if has('statusline')
    
    " always show a status line
    set laststatus=2

    " a statusline, also on steroids
    set statusline=%<%f\ %=\:\b%n\[%{strlen(&ft)?&ft:'none'}/%{&encoding}/%{&fileformat}]%m%r%w\ %l,%c%V\ %P

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" editing
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" backspace for dummies
set backspace=indent,eol,start

" show matching brackets/parenthesis
set showmatch

" command <Tab> completion, list matches and complete the longest common
" part, then, cycle through the matches
set wildmode=list:longest,full

" enable filetype detection
filetype on

" wrap long lines
set wrap

" indent at the same level of the previous line
set autoindent

" use indents of 4 spaces
set shiftwidth=4

" the text width
set textwidth=79

" basic formatting of text and comments
"set formatoptions+=tcq

" match, to be used with %
set matchpairs+=<:>

" spaces instead of tabs, CTRL-V<Tab> to insert a real space
set expandtab

" pastetoggle (sane indentation on pastes) just press F12 when you are
" going to paste several lines of text so they won't be indented.
" When in paste mode, everything is inserted literally.
set pastetoggle=<F12>

" ignore these file types when opening
set wildignore=*.pyc,*.o,*.obj,*.swp


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" search
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" show search results as you type (enable this _only_ if you work with small
" files)
set incsearch

" highlight all search matches
set hlsearch


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" file types
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType c,cpp call <SID>cstuff()
function <SID>cstuff()
    set cindent
    set formatoptions+=croql
    set formatoptions-=t
endfunction

autocmd FileType python call <SID>pystuff()
function <SID>pystuff()
    set foldmethod=indent
    set foldlevel=999999
    set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
endfunction

" I have been working with cobol lately, the horror
au BufNewFile,BufRead *.CBL,*.cbl,*.cob     setf cobol

" clearsilver templates
au BufNewFile,BufRead *.cst      setf cs


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" misc, there is _always_ a misc section
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" real men _never_ _ever_ do backups
" (but real programmers use version control)
set nobackup


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" plugins
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:netrw_list_hide="\.pyc$,\.swp$,\.bak$,^\.svn/$"
" tree style
"let g:netrw_liststyle=3
" F11 to open the work directory
nmap <silent> <F11> :Explore<CR>

" press F11 to toggle the project sidebar
"nmap <silent> <F11> <Plug>ToggleProject
"let g:proj_flags="mst"

map <leader>t :FuzzyFinderTextMate<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" tabs
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" this settings are basically for gvim in gtk and windows
map <silent><C-t> :tabnew<CR>
map <silent><A-Right> :tabnext<CR>
map <silent><A-Left> :tabprevious<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" gvim- (here instead of .gvimrc)
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('gui_running') 
    set guioptions-=T          " remove the toolbar
    set guioptions+=a          " 
    set lines=999
    if has("mac")
        set guifont=Monaco:h14
    elseif has("unix")
        set guifont=Monospace\ 12
    elseif has("win32") || has("win64")
        set guifont=Consolas:h10:cANSI
    endif
    set cursorline
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

endif " if version >= 700 (at the beggining of the file)

" to please the gods
iabbrev cthuf Ia! Ia! Cthulhu fhtagn! Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn! Cthulhu fhtagn! Cthulhu fhtagn!
