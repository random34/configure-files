set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set nu!
set wrap
  if !exists("syntax_on")
    syntax on
endif
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cindent

set encoding=utf-8
set fileencodings=utf-8,chinese,latin-1
if has("win32")
set fileencoding=chinese
else
set fileencoding=utf-8
endif

language messages zh_CN.utf-8

set fencs=utf-8,gbk,ucs-bom,gb18030,gb2312,cp936
set langmenu=zh_CN.utf-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"set font
"set guifont=NSimSun:h12:cANSI
set guifont=Courier\ New:h12:cANSI


set helplang=cn
set iskeyword+=

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" NERDTree
map <F7> :NERDTreeToggle<CR>
"设置F2为开关拼写检查
nmap <F2> :set spell!<CR>
"configuration for TOhtml
let html_use_css = 1 " Use stylesheet instead of inline style
let html_number_lines = 0 " don't show line numbers
let html_no_pre = 1 " don't wrap lines in <pre>

"No indent when () breaks.
set nocindent

"default window size
set lines=40 columns=90

"auto indent
set ai
" soft word warp
set wrap linebreak textwidth=0
" search ignore case
set ignorecase
" ignore ignorecase when the search word contains upper case characters
set smartcase

" No annoying sound on errors
set noerrorbells
set novisualbell

nnoremap k gk
nnoremap j gj
nnoremap  <Up> gk
nnoremap  <Down> gj
nnoremap  0 g0
nnoremap  ^ g^
nnoremap  $ g$
inoremap  <Up> <C-O>gk
inoremap  <Down> <C-O>gj
vnoremap  k gk
vnoremap  j gj
vnoremap  <Up> gk
vnoremap  <Down> gj
vnoremap  0 g0
vnoremap  ^ g^
vnoremap  $ g$

"Ctrl+i = surround visual mode selections by '*', useful for markdown syntax.
map <C-I> c*<C-R>"*<ESC>


" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


