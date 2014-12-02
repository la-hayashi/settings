set tabstop=2
set shiftwidth=2
set expandtab
set nocompatible
set number
syntax on
filetype on
filetype indent on
filetype plugin on

au FileType ruby setlocal makeprg=ruby\ -c\ %
au FileType ruby setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" neocomplcache
set nocompatible " be iMproved
filetype off

set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

" originalrepos on github
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundleFetch 'Shougo/vimproc'
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'rails.vim'
NeoBundle 'The-NERD-tree'
NeoBundle 'scrooloose/syntastic.git'

call neobundle#end()

let g:neocomplcache_enable_at_startup = 1
let NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterToggle

" bb binding.pry を追加する
nmap bb obinding.pry<Esc>

" F4/F5: コピペモード/戻す
map <F4>  :set paste <CR>:set nonu <CR>
map <F5>  :set nopaste <CR>:set nu <CR>

" Ctrl + a: 対応するスペックファイルとの切り替え
map <C-a> :A <CR>

" Ctrl + q: バッファから元のファイルへ戻る
map <C-q> :bn <CR>

" Ctrl + キー: ペイン移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Ctrk + z: 各ペインのウィンドウサイズをリセット

" F2/F3: 前のコンフリクト場所/次のコンフリクト場所
map <F2>  [c
map <F3>  ]c

" leaderをカンマに割り当て
let mapleader = ","
map <Leader>1 :diffget LOCAL<CR>
map <Leader>2 :diffget BASE<CR>
map <Leader>3 :diffget REMOTE<CR>
map <Leader>u :<C-u>diffupdate<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" 対応括弧に<と>のペアを追加
set matchpairs& matchpairs+=<:>

" Ctrl + c でハイライトを消す
nnoremap <C-c> :nohlsearch<CR>

" q で前の単語へ移動
nnoremap q b

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
