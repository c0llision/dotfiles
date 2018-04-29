filetype off
syntax on
set nocompatible


"""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL
"""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
set mouse=a                                  " allow mouse
set autoread                                 " auto read when a file is changed from the outside
set so=10                                    " Set 10 lines to the cursor - when moving vertically
set backspace=eol,start,indent               " Configure backspace so it acts as it should act
set lazyredraw                               " Don't redraw while executing macros
set undofile                                 " Persistent Undo
set clipboard^=unnamed,unnamedplus           " Use system clipboard
set pastetoggle=<F2>                         " When in insert mode, <F2> to go to mass paste mode
let $BASH_ENV = "~/.aliases"                 " Use my bash aliases when running bash commands
set background=dark                          " Theme
autocmd BufWritePre * %s/\s\+$//e            " Remove unnecessary whitespace
set wildmenu                                 " Enable wild for command completion
"set path+=**                                " recursive search (use :find to find a file)
let g:airline#extensions#tabline#enabled = 1 " Style the tabs properly
let g:netrw_dirhistmax=0                     " Disable netrw history file

" Search
set ignorecase                               " Ignore case when searching
set smartcase                                " When searching try to be smart about cases
set hlsearch                                 " Highlight search results
set incsearch                                " Makes search act like search in modern browsers

" Line numbering
set relativenumber                           " Display relative line numbers
set number                                   " Current line displays actual number

" Indentation
set shiftwidth=4                             " Number of spaces inserted for indentation
set autoindent                               " Continue indentation when creating new line
set smartindent                              " React to syntac and try to indent appropriately
set expandtab                                " Tab inserts spaces
set tabstop=4                                " Number of spaces inserted for tab key

" Backup files
set directory=~/.vim/tmp/swapfiles//         " Directory to save swapfiles
set backupdir=~/.vim/tmp/backupfiles//       " Directory to save backup files
set undodir=~/.vim/tmp/undofiles//           " Directory to save undo history


"""""""""""""""""""""""""""""""""""""""""""""""
" Create backup directories if they don't exist
" (from https://stackoverflow.com/a/8462159/9134405 )
"""""""""""""""""""""""""""""""""""""""""""""""
function! EnsureDirExists (dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir,'p', 0700)    " Only readable by owner
      echo "Created directory: " . a:dir
    else
      echo "Please create directory: " . a:dir
    endif
  endif
endfunction
call EnsureDirExists($HOME . '/.vim/tmp/backupfiles')
call EnsureDirExists($HOME . '/.vim/tmp/swapfiles')
call EnsureDirExists($HOME . '/.vim/tmp/undofiles')


"""""""""""""""""""""""""""""""""""""""""""""""
" Move lines up and down using <C-j> and <C-k>
" (from https://github.com/noopkat/dotfiles)
"""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv


"""""""""""""""""""""""""""""""""""""""""""""""
" Skeleton templates for languages
"""""""""""""""""""""""""""""""""""""""""""""""
au BufNewFile *.sh 0r ~/.vim/skeletons/skeleton.sh
au BufNewFile *.html 0r ~/.vim/skeletons/skeleton.html
au BufNewFile *.py 0r ~/.vim/skeletons/skeleton.py


"""""""""""""""""""""""""""""""""""""""""""""""
" Leader key shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""
" \r to run currently opened file
noremap <Leader>r :!%:p<CR>
" \u to open undotree
nnoremap <Leader>u :UndotreeToggle<cr><C-w><C-w>
" ./ to disable search highlighting
nmap <silent> ./ :nohlsearch<CR>


"""""""""""""""""""""""""""""""""""""""""""""""
" Disable annoying keybinds
"""""""""""""""""""""""""""""""""""""""""""""""
map Q <Nop>
map q: <Nop>


"""""""""""""""""""""""""""""""""""""""""""""""
" Allow some keybinds to work case insensitively
"""""""""""""""""""""""""""""""""""""""""""""""
command Q q
command W w
command WQ wq
command Wq wq
nnoremap ; :


"""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND-T
" <cr> opens file in new tab, <c-t> opens it in same tab
"""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTAcceptSelectionMap = '<C-t>'
let g:CommandTAcceptSelectionTabMap = '<CR>'


"""""""""""""""""""""""""""""""""""""""""""""""
" Save last cursor position and jump to it on reload
" (from https://github.com/garybernhardt/dotfiles)
"""""""""""""""""""""""""""""""""""""""""""""""
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
\ endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY (from https://github.com/garybernhardt/dotfiles)
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>


"""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""
" Load vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'mbbill/undotree'
Plugin 'wincent/command-t'

" All of your Plugins must be added before the following line
call vundle#end()            " required
" filetype plugin indent on    " required
