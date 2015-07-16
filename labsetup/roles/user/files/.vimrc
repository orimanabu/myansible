set encoding=utf-8
set fileencodings=utf-8,euc-jp,cp932,iso-2022-jp
scriptencoding utf-8
let g:mapleader = ' '

if &compatible
  set nocompatible              " no-compatible mode
endif

set backspace=start,eol,indent  " backspace everywhere
set whichwrap=b,s,[,],<,>,~     " wrap cursor
set mouse=                      " never use mouse
set nohlsearch                  " no highlight while searching
set laststatus=2                " always show status line
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
"set number                      " show line number
set incsearch                   " incremental search
set ignorecase                  " case insensitive search
set smartcase                   " ignore ignorecase for capital search queries
set guicursor=a:blinkon0        " supress cursor blinking

set display=lastline		" 最後の行が長すぎても表示する

set nobackup
set noswapfile
" swapfileがあるとreadonlyで開く
"augroup swapchoice-readonly
"  autocmd!
"  autocmd SwapExists * let v:swapchoice = 'o'
"augroup END
set noundofile

set hidden                     " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq         " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                   " ビープをならさない
set autoread                   " 他で書き換えられたら自動で読み直す
set wildmenu           " コマンド補完を強化
set wildmode=list:longest,full " リスト表示，最長マッチ

set autoindent
set history=1000
set ruler
set showmatch
set matchtime=2
set modeline
set modelines=10
set comments=
set scrolloff=5
set pumheight=10	" 補完候補表示数

"if has("mouse")
"    set mouse=a
"endif

syntax on                       " syntax highlighting

"""
""" emacs keybind in input mode
"""
"inoremap <M-p> <C-p>
"inoremap <M-n> <C-n>
"inoremap <C-n> <Down>
"inoremap <C-p> <Up>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <silent> <C-d> <Del>
inoremap <silent> <C-a> <Esc>0<Insert>
inoremap <silent> <C-e> <Esc>$a
""" history-search in command mode
"cnoremap <C-p> <Up>
"cnoremap <C-n> <Down>
nnoremap Y y$

augroup vimrc
	autocmd!
	autocmd FileType python
		\ setlocal tabstop=4 |
		\ setlocal softtabstop=4 |
		\ setlocal shiftwidth=4 |
		\ setlocal smarttab |
		\ setlocal expandtab
	autocmd BufNewFile,BufRead *.go
		\ setlocal noexpandtab |
		\ setlocal tabstop=4 |
		\ setlocal shiftwidth=4
	autocmd FileType ruby
		\ setlocal tabstop=2 |
		\ setlocal softtabstop=2 |
		\ setlocal shiftwidth=2 |
		\ setlocal expandtab
	autocmd FileType yaml
		\ setlocal tabstop=2 |
		\ setlocal softtabstop=2 |
		\ setlocal shiftwidth=2 |
		\ setlocal expandtab
augroup END

if 1
""""""""""""""""""""""""""""""
"挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
"let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => l:hl
  exec 'highlight '.a:hi
  redir END
  let l:hl = substitute(l:hl, '[\r\n]', '', 'g')
  let l:hl = substitute(l:hl, 'xxx', '', '')
  return hl
endfunction
endif

"""
""" GUI Options
"""
if has('gui_running')
    set transparency=10
    set guifont=Menlo:h12
    set lines=70 columns=120
    set guioptions-=T
    set macmeta
endif

map <C-g> :Gtags 
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

"""
""" NeoBundle
"""
let s:has_neobundle = isdirectory(expand('~/.vim/bundle/neobundle.vim'))
" To install neobundle:
" git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
if s:has_neobundle
	if has('vim_starting')
		set runtimepath+=~/.vim/bundle/neobundle.vim/
		call neobundle#begin(expand('~/.vim/bundle'))
		NeoBundleFetch 'Shougo/neobundle.vim'
		call neobundle#end()
	endif

	call neobundle#begin(expand('~/.vim/bundle'))
	" NeoBundle 'PLUGIN'
	NeoBundle 'nelstrom/vim-visual-star-search'
	NeoBundle 'nelstrom/vim-qargs'
	NeoBundle 'tpope/vim-commentary'
	NeoBundle 'tpope/vim-fugitive'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'thinca/vim-quickrun'
	NeoBundle 'Shougo/vimproc.vim'
	NeoBundle 'Align'
	NeoBundle 'nathanaelkane/vim-indent-guides'
	NeoBundle 'nvie/vim-flake8'
	NeoBundle 'chase/vim-ansible-yaml'
	"NeoBundle 'Shougo/clang_complete'
	NeoBundleLazy 'Shougo/vimshell.vim', { 'depends' : [ 'Shougo/vimproc.vim' ] }
	NeoBundleLazy 'Shougo/unite.vim', { 'depends' : [ 'Shougo/vimproc.vim' ] }
	NeoBundleLazy 'h1mesuke/unite-outline', { 'depends' : [ 'Shougo/unite.vim' ] }
	call neobundle#end()

	filetype plugin indent on

	"NeoBundleCheck
endif
