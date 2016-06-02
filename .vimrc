" hacks to get various features working.
"set t_Co=256         " tell us that 256 color mode is working
set timeoutlen=1000  " set the mappint delap to 1000ms
set ttimeoutlen=0    " set the keycode delay to 10ms
set nocompatible
set hidden           " allow buffers to move to the background seamlessly
filetype plugin indent on

" bootstrap to install vimplug
if empty(glob('~/.vim/autoload/plug.vim'))
    if has ('win32')
      silent execute "!curl -k -fLo " . $HOME . '\.vim\autoload\plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    else
      silent execute "!curl -k -fLo " . $HOME . '/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'  "Customize the tabs and statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fatih/vim-go', { 'for' : 'go' }
if has ("win32")
    Plug 'vim-scripts/perforce.vim'
    Plug 'kkoenig/wimproved.vim'     " Add Windows fullscreen support
endif
Plug 'valloric/youcompleteme'
Plug 'oranget/vim-csharp', { 'for' : 'cs' }
Plug 'rking/ag.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/vim-easy-align'
call plug#end()

" VIM related settings
set autoread        " Automatically reload changed files
set encoding=utf-8  " Character encoding used inside vim
set expandtab       " Use spaces instead of tabs in insert mode
set hlsearch        " Highlight search matches
set ignorecase      " Ignore case when matching
set laststatus=2    " Always show the status line
set list            " Display certain whitespace chars designated by listchars
set listchars=tab:>\ ,eol:\ ,trail:~,extends:>,precedes:<
set number          " Show line numbers
set shiftwidth=4    " Number of spaces to use for each autoindent
set smartcase       " Override ignorecase setting if search contains uppercase
set softtabstop=-1  " Use shiftwidth to insert spaces when <TAB> is pressed
set tabstop=4       " Number of spaces that a tab in a file counts for
set smartindent     " C style indening in many cases
set wildmenu        " Enable visual menu for command line completion
set fileencoding=utf-8             " Indicate desired and acceptable
set fileencodings=ucs-bom,utf8,prc " file encodings
set backspace=indent,eol,start     " allow backspace over certain characters.
set cursorline
set colorcolumn=80
syntax on           " Enable syntax highlighting
set background=dark
let g:solarized_termtrans=1
let g:solarized_visibility = "low"
colorscheme solarized
set splitright     " When making new panes go OLD | NEW
set incsearch      " Turn on incremental search

" simple mapping to un-highlight find results
nnoremap <silent> <C-l> :nohl<CR><C-l>

" map YCM's GoTo command to an easy chord
nnoremap <F12> :YcmCompleter GoTo<CR><F12>
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 0

" vim-airline settings
let g:airline#extensions#tabline#enabled = 1     " Show tabline at the top
set noshowmode                                           " Hide -- INSERT --

" vim-go settings
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" ctrl-p ctags support
let g:ctrlp_extensions = ['buffertag']
let g:ctrlp_buftag_types = { 'go' : '--language-force=go --go-types=d' }

" Ag settings
let g:ag_working_path_mode="r"
nnoremap K :Ag! "\b<C-R><C-W>\b"<CR>:cw<CR>

" vim-cpp-enhanced-highlight settings
let g:cpp_class_scope_highlight=1
let g:cpp_experimental_template_highlight=1
" potentially disable false curly brace highlighting
" let c_no_curly_error=1

"windows gvim settings
if has('gui_running') && has('win32')
    set guifont=consolas:h10

    autocmd GUIEnter * silent! WToggleClean
    autocmd GUIEnter * silent! WToggleFullscreen
    nnoremap <silent> <Leader>r :WToggleFullscreen<ENTER>
    nnoremap <silent> <Leader>f :WToggleClean<ENTER>
endif
