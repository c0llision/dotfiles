""""""""""""""""""""""""""""""""""""""""""""""
" c0llision's .vimrc
" https://github.com/c0llision/dotfiles
""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                             " Run in non-backwards compatible mode
filetype off                                 " Needed for vundle plugin manager
syntax on                                    " Turn on syntax highlighting
set encoding=utf-8                           " Encoding shown on screen is utf-8
set term=xterm-256color                      " Use a 256 color terminal
set t_Co=256                                 " Ensure we use 256 colors


""""""""""""""""""""""""""""""""""""""""""""""
" Filenames
""""""""""""""""""""""""""""""""""""""""""""""
" todo: add windows support
let alias_file = expand("~/.aliases")        " File to load bash aliases from
set directory=~/.vim/tmp/swapfiles//         " Directory to save swap files
set backupdir=~/.vim/tmp/backupfiles//       " Directory to save backup files
set undodir=~/.vim/tmp/undofiles//           " Directory to save undo history


""""""""""""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a                                  " Allow mouse
set autoread                                 " Auto read when a file is changed from the outside
set so=10                                    " Set 10 lines to the cursor - when moving vertically
set lazyredraw                               " Don't redraw while executing macros
set undofile                                 " Persistent Undo
set pastetoggle=<F2>                         " When in insert mode, <F2> to go to mass paste mode
set background=dark                          " Use dark theme
set wildmenu                                 " Enable wild for command completion
set backspace=eol,start,indent               " Configure backspace so it acts as it should act
set clipboard^=unnamed,unnamedplus           " Use system clipboard
let g:netrw_dirhistmax=0                     " Disable netrw history file
let g:airline#extensions#tabline#enabled = 1 " Style the tabs properly
autocmd BufWritePre * %s/\s\+$//e            " Remove unnecessary whitespace


""""""""""""""""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase                               " Ignore case when searching
set smartcase                                " When searching try to be smart about cases
set hlsearch                                 " Highlight search results
set incsearch                                " Makes search act like search in modern browsers


""""""""""""""""""""""""""""""""""""""""""""""
" Line numbering
""""""""""""""""""""""""""""""""""""""""""""""
set relativenumber                           " Display relative line numbers
set number                                   " Current line displays actual number


""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""
set shiftwidth=4                             " Number of spaces inserted for indentation
set tabstop=4                                " Number of spaces inserted for tab key
set autoindent                               " Continue indentation when creating new line
set smartindent                              " React to syntac and try to indent appropriately
set expandtab                                " Tab inserts spaces


""""""""""""""""""""""""""""""""""""""""""""""
" Allow Bash aliases to work when running commands
""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(alias_file)
    let $BASH_ENV = alias_file               " Use my bash aliases when running bash commands
endif


""""""""""""""""""""""""""""""""""""""""""""""
" Create backup directories if they don't exist
" (from https://stackoverflow.com/a/8462159/9134405)
""""""""""""""""""""""""""""""""""""""""""""""
function! EnsureDirExists (dir)
  if !isdirectory(a:dir)
    if exists("*mkdir")
      call mkdir(a:dir, 'p', 0700)    " Only readable by owner
      echo "Created directory: " . a:dir
    else
      echo "Unable to create directory. Please create it: " . a:dir
    endif
  endif
endfunction
call EnsureDirExists(&backupdir)
call EnsureDirExists(&directory)
call EnsureDirExists(&undodir)


""""""""""""""""""""""""""""""""""""""""""""""
" Move lines up and down using <C-j> and <C-k>
" (from https://github.com/noopkat/dotfiles)
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv


""""""""""""""""""""""""""""""""""""""""""""""
" Skeleton templates for various languages
""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufNewFile *.sh 0r ~/.vim/skeletons/skeleton.sh
autocmd BufNewFile *.html 0r ~/.vim/skeletons/skeleton.html
autocmd BufNewFile *.py 0r ~/.vim/skeletons/skeleton.py


""""""""""""""""""""""""""""""""""""""""""""""
" Leader key shortcuts
""""""""""""""""""""""""""""""""""""""""""""""
" \r to run currently opened file
noremap <Leader>r :!%:p<CR>
" \u to open undotree
nnoremap <Leader>u :UndotreeToggle<cr><C-w><C-w>
" ./ to disable search highlighting
nmap <silent> ./ :nohlsearch<CR>


""""""""""""""""""""""""""""""""""""""""""""""
" Disable annoying keybinds
""""""""""""""""""""""""""""""""""""""""""""""
map Q <Nop>
map q: <Nop>


""""""""""""""""""""""""""""""""""""""""""""""
" Allow some keybinds to work case insensitively
""""""""""""""""""""""""""""""""""""""""""""""
command! Q q
command! W w
command! WQ wq
command! Wq wq
nnoremap ; :


""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND-T
" <cr> opens file in new tab, <c-t> opens it in same tab
""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTAcceptSelectionMap = '<C-t>'
let g:CommandTAcceptSelectionTabMap = '<CR>'


""""""""""""""""""""""""""""""""""""""""""""""
" Save last cursor position and jump to it on reload
" (from https://github.com/garybernhardt/dotfiles)
""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
\ endif


""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY (from https://github.com/garybernhardt/dotfiles)
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""
" Load vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" run :PluginInstall after adding a plugin here
" run :PluginUpdate to update the plugins
Plugin 'gmarik/Vundle.vim'                      " Plugin manager
Plugin 'airblade/vim-gitgutter'                 " Display git commit lines in gutter
Plugin 'vim-airline/vim-airline'                " Bar at bottom of screen
Plugin 'mbbill/undotree'                        " Undo manager
Plugin 'wincent/command-t'                      " Fuzzy file finder

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on
