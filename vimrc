""""""""""""""""""""""""""""""""""""""""""""""
" c0llision's .vimrc
" https://github.com/c0llision/dotfiles
""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                             " Run in non-backwards compatible mode
set encoding=utf-8                           " Encoding shown on screen is utf-8
set term=xterm-256color                      " Use a 256 color terminal
set t_Co=256                                 " Ensure we use 256 colors
set re=1                                     " Use faster RE engine


""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plug')
Plug 'airblade/vim-gitgutter'                " Display git commit lines in gutter
Plug 'vim-airline/vim-airline'               " Bar at bottom of screen
Plug 'mbbill/undotree'                       " Undo manager
Plug 'wincent/command-t'                     " Fuzzy file finder
Plug 'mhinz/vim-startify'                    " Start page
Plug 'arcticicestudio/nord-vim'              " Color scheme
Plug 'tpope/vim-commentary'                  " Comments
Plug 'vimwiki/vimwiki'                       " Note taking
call plug#end()


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
" Vimwiki
""""""""""""""""""""""""""""""""""""""""""""""
let g:vimwiki_list = [{'path': '~/vimwiki',
  \ 'path_html': '~/vimwiki/html',
  \ 'syntax': 'markdown',
  \ 'custom_wiki2html':  '~/.vim/wiki2html.sh',
  \ 'auto_export' : 1,
  \ 'ext': '.md'}]

au BufWritePost *.wiki VimwikiAll2HTML

""""""""""""""""""""""""""""""""""""""""""""""
" Startify theme and layout
""""""""""""""""""""""""""""""""""""""""""""""
" let g:startify_bookmarks = [ '']

let g:startify_lists = [
    \ { 'type': 'sessions',  'header': [   'Sessions']       },
    \ { 'type': 'bookmarks', 'header': [   'Bookmarks']      },
    \ { 'type': 'dir',       'header': [   'MRU '. getcwd()] },
    \ { 'type': 'commands',  'header': [   'Commands']       },
\ ]


""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
""""""""""""""""""""""""""""""""""""""""""""""
colorscheme nord                             " Colorscheme to use
" fix for visual highlighting
highlight Visual cterm=reverse ctermbg=NONE


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
" nnoremap <CR> :call RunProgram(@%)<cr>

" <enter> and <s-enter> to insert blank lines
map <Enter> o<ESC>
" doesnt work in cli
map <S-Enter> O<ESC>


""""""""""""""""""""""""""""""""""""""""""""""
" \r to make current file executable and run it
""""""""""""""""""""""""""""""""""""""""""""""
noremap <Leader>r :!chmod +x %:p<cr>:!%:p<cr>


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
autocmd BufNewFile *.js 0r ~/.vim/skeletons/skeleton.js
autocmd BufNewFile *.md 0r ~/.vim/skeletons/skeleton.md


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

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Uncomment for practising
" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>


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

