" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

colorscheme distinguished

"disable loading all the default config in Vim 8
"let skip_defaults_vim=1
set viminfo=""

" =============== Pathogen Initialization ===============
" This loads all the plugins in ~/.vim/bundle
" Use tpope's pathogen plugin to manage all other plugins

" ================ General Config ====================

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink

set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window. 
" http://items.sjbach.com/319/configuring-vim-right
set hidden

set paste
"set list

"set clipboard=exclude:.*
set clipboard=unnamed

"turn on syntax highlighting
syntax on

highlight OverLength ctermbg=darkgrey ctermfg=white guibg=#592929
"call matchadd('OverLength', '\%>100v.\+')

highlight OverLength2 ctermbg=darkblue ctermfg=white guibg=#592929
"call matchadd('OverLength2', '\%>120v.\+')

highlight ExtraWhitespace ctermbg=grey ctermfg=white guibg=#592929
"call matchadd('ExtraWhitespace', '\s\+$')

" ================ Search Settings  =================

set incsearch        "Find the next match as we type the search
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works in MacVim (gui) mode.

if has('gui_running')
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

"filetype plugin off
"filetype indent on
filetype indent off

set autoindent
set smartindent
"set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

set nowrap                  "Don't wrap lines
set linebreak               "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent       "fold based on indent
set foldnestmax=3           "deepest fold is 3 levels
set nofoldenable            "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

" ================ Scrolling ========================

set scrolloff=8             "Start scrolling when we're 8 lines away from margins
set sidescrolloff=0
set sidescroll=40
