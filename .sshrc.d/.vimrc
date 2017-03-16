set nocompatible
" ^^^ Trust me!

""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""

" Set to auto read/write when a file is changed from the outside
set autoread
set autowrite

" Color scheme
" colorscheme base16-railscasts
" let base16colorspace=256 " Fix for green line numbers

" Enable syntax highlighting
syntax on

" Display line numbers on the left
set number
set numberwidth=4

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Makes search act like search in modern browsers
set incsearch

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" Enable use of the mouse for all modes
set mouse=a

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
" Be smart when using tabs ;)
set smarttab

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

" Delete trailing white space on save, useful for Python and CoffeeScript
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

""""""""""""""""""""""""""""""
" Status line
""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

set statusline=%t\ %m\ %r\ [%{strlen(&fenc)?&fenc:'none'},%{&ff}]\ %y%=%c,%l/%L\ %P

""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""

" HardMode: Disable arrow keys
nmap <up> <nop>
nmap <down> <nop>
nmap <left> <nop>
nmap <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

nnoremap <silent> <ESC>OA <nop>
nnoremap <silent> <ESC>OB <nop>
nnoremap <silent> <ESC>OC <nop>
nnoremap <silent> <ESC>OD <nop>
inoremap <silent> <ESC>OA <nop>
inoremap <silent> <ESC>OB <nop>
inoremap <silent> <ESC>OC <nop>
inoremap <silent> <ESC>OD <nop>

" Fast saving
nmap <leader>w :w!<cr>

" Remap VIM 0 to first non-blank character
map 0 ^

" use jk for <esc> and disable <esc>
inoremap jk <esc>
inoremap <esc> <nop>
