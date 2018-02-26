filetype off
syntax on
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
set mouse=a                        " allow mouse
set laststatus=2                   " always show powerline
set autoread                       " Set to auto read when a file is changed from the outside
set so=7                           " Set 7 lines to the cursor - when moving vertically using j/k
set backspace=eol,start,indent     " Configure backspace so it acts as it should act
set ignorecase                     " Ignore case when searching
set smartcase                      " When searching try to be smart about cases 
set hlsearch                       " Highlight search results
set incsearch                      " Makes search act like search in modern browsers
set lazyredraw                     " Don't redraw while executing macros (good performance config)
set clipboard^=unnamed,unnamedplus " Use system clipboard
set pastetoggle=<F2>               " when in insert mode, press <F2> to go to
                                   "    paste mode, where you can paste mass data
                                   "    that won't be autoindented

" vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" show line numbers
set number
set relativenumber

" recursive search (use :find to find a file)
set path+=**
set wildmenu

" indentation
set shiftwidth=2
set autoindent 
set expandtab
set tabstop=4

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

nnoremap <Leader>gs :Gstatus<Enter>
nnoremap <Leader>gc :Gcommit<Enter>
nnoremap <Leader>gp :Gpush<Enter>

nnoremap <Leader>html :-1read $HOME/.vim/skeleton.html<CR>3jf>a 
nnoremap <Leader>python :-1read $HOME/.vim/skeleton.py<CR>3ji    

map Q <Nop>
command Q q
command W w
command WQ wq
command Wq wq
nnoremap ; : 

" comment line
autocmd Filetype python nnoremap <Leader>cc I# <esc>
autocmd Filetype java nnoremap <Leader>cc I// <esc>
nnoremap <Leader>cu ^df <esc>

let g:NERDTreeWinPos = "left"
let NERDTreeIgnore=['\~$', '.o$', 'bower_components', 'node_modules', '__pycache__']
nnoremap <Leader>f :NERDTreeToggle<Enter>
nnoremap <Leader>u :UndotreeToggle<Enter>

" theme
set background=dark

" vim swap files in special directory
let swap_dir = expand("~/.vim/swapfiles")
if !isdirectory(swap_dir)
  call mkdir(swap_dir)
endif

"" Backup, Swap and Undo
set undofile " Persistent Undo
if has("win32")
    set directory=$HOME\vimfiles\swap,$TEMP
    set backupdir=$HOME\vimfiles\backup,$TEMP
    set undodir=$HOME\vimfiles\undo,$TEMP
else
    set directory=~/.vim/swap,/tmp
    set backupdir=~/.vim/backup,/tmp
    set undodir=~/.vim/undo,/tmp
endif

" Python
let python_highlight_all=1
highlight BadWhitespace ctermbg=red guibg=darkred

" Plugins

Plugin 'gmarik/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'mbbill/undotree'
Plugin 'jamessan/vim-gnupg'
Plugin 'johngrib/vim-game-code-break'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" filetype plugin indent on    " required

