" Based on: https://github.com/jessfraz/.vim

set nocompatible              " Leave this here trust me
filetype off                  " required

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" ------------------------------------------------------------------------------
" Settings

set noerrorbells                " No beeps
set number                      " Show line numbers
set backspace=indent,eol,start  " Makes backspace key more powerful.
set showcmd                     " Show me what I'm typing

set noswapfile                  " Don't use swapfile
set nobackup					          " Don't create annoying backup files
set nowritebackup
set splitright                  " Split vertical windows right to the current windows
set splitbelow                  " Split horizontal windows below to the current windows
set encoding=utf-8              " Set default encoding to UTF-8
set autowrite                   " Automatically save before :next, :make etc.
set autoread                    " Automatically reread changed files without asking me anything
set laststatus=2
set hidden

set ruler                       " Show the cursor position all the time
au FocusLost * :wa              " Set vim to save the file on focus out.

set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats

set noshowmode                  " We show the mode with airline or lightline
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters
set ttyfast
" set ttyscroll=3               " noop on linux ?
set lazyredraw          	      " Wait to redraw "

" speed up syntax highlighting
set nocursorcolumn
set nocursorline

syntax sync minlines=256
set synmaxcol=300
set re=1

" do not hide markdown
set conceallevel=0

" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L

" Make Vim to handle long lines nicely.
set wrap
set textwidth=80
set formatoptions=qrn1

" Do not use relative numbers to where the cursor is.
set norelativenumber

" Apply the indentation of the current line to the next line.
set autoindent
set smartindent
set complete-=i
set showmatch
set smarttab

set tabstop=4
set shiftwidth=4
set expandtab

set nrformats-=octal
set shiftround

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone

# History
if &history < 1000
  set history=50
endif

# Tab page max
if &tabpagemax < 50
  set tabpagemax=50
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" If linux then set ttymouse
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux" && !has('nvim')
  set ttymouse=xterm
endif

" ------------------------------------------------------------------------------
" Hotkeys

" Fast saving
nmap <leader>w :w!<cr>

" Just go out in insert mode
imap jk <ESC>l


" ------------------------------------------------------------------------------
" Theme

syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-default-dark
set guifont=Inconsolata:h15
set guioptions-=L
