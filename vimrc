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
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'                   " Plugin manager
Plugin 'airblade/vim-gitgutter'              " Display git commit lines in gutter
Plugin 'vim-airline/vim-airline'             " Bar at bottom of screen
Plugin 'mbbill/undotree'                     " Undo manager
Plugin 'wincent/command-t'                   " Fuzzy file finder
Plugin 'mhinz/vim-startify'                  " Start page
Plugin 'arcticicestudio/nord-vim'            " Color scheme
call vundle#end()
filetype plugin indent on


""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""
colorscheme nord                             " Colorscheme to use
" fix for visual highlighting
highlight Visual cterm=reverse ctermbg=NONE


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
set so=10                                    " Set 10 lines to the cursor when moving vertically
set lazyredraw                               " Don't redraw while executing macros
set undofile                                 " Persistent Undo
set pastetoggle=<F2>                         " When in insert mode, <F2> to go to mass paste mode
set wildmenu                                 " Enable wild for command completion
set backspace=eol,start,indent               " Configure backspace so it acts as it should act
set clipboard^=unnamed,unnamedplus           " Use system clipboard
set history=10000                            " Remember more commands and search history
let g:netrw_dirhistmax=0                     " Disable netrw history file
let g:airline#extensions#tabline#enabled = 1 " Style the tabs properly
autocmd BufWritePre * %s/\s\+$//e            " Remove unnecessary whitespace
let g:startify_session_persistence = 1       " Autosave sessions


""""""""""""""""""""""""""""""""""""""""""""""
" Startify theme and layout
""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': [   'Sessions']       },
    \ { 'type': 'dir',       'header': [   'MRU '. getcwd()] },
    \ { 'type': 'bookmarks', 'header': [   'Bookmarks']      },
    \ { 'type': 'commands',  'header': [   'Commands']       },
\ ]


""""""""""""""""""""""""""""""""""""""""""""""
" Search
""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase                               " Ignore case when search term is all lowercase
set smartcase                                " If search term has an uppercase, case matters
set incsearch                                " Makes search act like search in modern browsers
set hlsearch                                 " Move cursor to matches while typing search


""""""""""""""""""""""""""""""""""""""""""""""
" Line numbering
""""""""""""""""""""""""""""""""""""""""""""""
set number                                   " Current line displays actual number
set relativenumber                           " Other lines dislay relative numbers


""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
""""""""""""""""""""""""""""""""""""""""""""""
set expandtab                                " Tab inserts spaces
set tabstop=4                                " Number of spaces inserted for tab key
set shiftwidth=4                             " Number of spaces inserted for indentation
set autoindent                               " Continue indentation when creating new line
set smartindent                              " React to syntax and try to indent appropriately


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
" Press enter to run the current program
""""""""""""""""""""""""""""""""""""""""""""""
function! RunProgram(filename)
    echo a:filename
    if (executable('./' . a:filename))
        exec ":!./" . a:filename
    else
        echo "File is not executable"
    endif
endfunction
nnoremap <CR> :call RunProgram(@%)<cr>


""""""""""""""""""""""""""""""""""""""""""""""
" \r to make current file executable and run it
""""""""""""""""""""""""""""""""""""""""""""""
noremap <Leader>r :!chmod +x %:p<cr>:!%:p<cr>


""""""""""""""""""""""""""""""""""""""""""""""
" Press backspace to open a terminal on the bottom
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <bs> :bot terminal<cr>


""""""""""""""""""""""""""""""""""""""""""""""
" Move lines up and down using <C-j> and <C-k>
" (from https://github.com/noopkat/dotfiles)
""""""""""""""""""""""""""""""""""""""""""""""
" Is moving splits better for these keys?
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

