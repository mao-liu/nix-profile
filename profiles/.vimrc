" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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

"turn on syntax highlighting
filetype plugin indent on
syntax on

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

set autoindent
set smarttab
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

" ================ Scrolling ========================

set scrolloff=8             "Start scrolling when we're 8 lines away from margins
set sidescrolloff=0
set sidescroll=40

" set the color scheme
colorscheme distinguished

" highlight text as red once it flows over 100 characters
highlight GuideLength ctermbg=darkgray ctermfg=white guibg=darkgray
match GuideLength /\%80v.\+/
highlight OverLength ctermbg=red ctermfg=white guibg=red
2match OverLength /\%120v.\+/
" always highlight extra white spaces
highlight ExtraWhitespace ctermbg=darkgray ctermfg=white guibg=darkgray
let match_space = matchadd('ExtraWhitespace', '\s\+$')

autocmd Filetype txt match none
autocmd Filetype txt 2match none
autocmd Filetype tex match none
autocmd Filetype tex 2match none
autocmd Filetype markdown match none
autocmd Filetype markdown 2match none
autocmd Filetype rst match none
autocmd Filetype rst 2match none

" set soft wrap for tex files
au FileType tex set wrap
au FileType txt set wrap
au FileType markdown set wrap
au FileType rst set wrap

" re-map the up and down keys to navigate soft wrap lines instead of hard lines
map <silent> <Up> gk
imap <silent> <Up> <C-o>gk
map <silent> <Down> gj
imap <silent> <Down> <C-o>gj
map <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
map <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

"execute pathogen#infect()
set clipboard=unnamed
set mouse=a

set paste
set ruler
