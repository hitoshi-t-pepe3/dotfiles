" NeoBundle
"------------------------------------------------------------------------------
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
if 703 <= v:version
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/vimshell.vim'
    NeoBundle 'Shougo/vimfiler'
endif
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Align'
NeoBundle 'syngan/vim-pukiwiki'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-rails', { 'autoload' : {
      \ 'filetypes' : ['haml', 'ruby', 'eruby'] }}
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'kana/vim-submode'
NeoBundle 'yuratomo/w3m.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'marcus/rsense'
NeoBundleLazy 'marcus/rsense', {
      \ 'autoload': {
      \   'filetypes': 'ruby',
      \ },
      \ }
NeoBundle 'supermomonga/neocomplete-rsense.vim', {
      \ 'depends': ['Shougo/neocomplete.vim', 'marcus/rsense'],
      \ }

NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'
NeoBundle 'szw/vim-tags'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'kmnk/vim-unite-giti'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'violetyk/cake.vim'
NeoBundle 'vim-scripts/VimCoder.jar'
NeoBundleLazy 'alpaca-tc/alpaca_tags', {
              \    'depends': ['Shougo/vimproc'],
              \    'autoload' : {
              \       'commands' : [
              \          { 'name' : 'AlpacaTagsBundle', 'complete': 'customlist,alpaca_tags#complete_source' },
              \          { 'name' : 'AlpacaTagsUpdate', 'complete': 'customlist,alpaca_tags#complete_source' },
              \          'AlpacaTagsSet', 'AlpacaTagsCleanCache', 'AlpacaTagsEnable', 'AlpacaTagsDisable', 'AlpacaTagsKillProcess', 'AlpacaTagsProcessStatus',
              \       ],
              \    }
              \ }
NeoBundle "ctrlpvim/ctrlp.vim"
NeoBundle 'rking/ag.vim'

call neobundle#end()

" Reqiured:
filetype plugin indent on

set undolevels=1000

" vimsell
" ,is: シェルを起動
nnoremap <silent> ,is :VimShell<CR>
" ,ipy: pythonを非同期で起動
nnoremap <silent> ,ipy :VimShellInteractive python<CR>
" ,irb: irbを非同期で起動
nnoremap <silent> ,irb :VimShellInteractive irb<CR>
" ,ss: 非同期で開いたインタプリタに現在の行を評価させる
vmap <silent> ,ss :VimShellSendString<CR>
" 選択中に,ss: 非同期で開いたインタプリタに選択行を評価させる
nnoremap <silent> ,ss <S-v>:VimShellSendString<CR>

" alpaca_tags
let g:alpaca_tags#config = {
                       \    '_' : '-R --sort=yes',
                       \    'ruby': '--languages=+Ruby',
                       \ }

augroup AlpacaTags
  autocmd!
  if exists(':AlpacaTags')
    autocmd BufWritePost Gemfile AlpacaTagsBundle
    autocmd BufEnter * AlpacaTagsSet
    autocmd BufWritePost * AlpacaTagsUpdate
  endif
augroup END

" Rsense
let g:rsenseHome = '/usr/local/lib/rsense-0.3'
let g:rsenseUseOmniFunc = 1

" neocomplete.vim
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

" nerdtree
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" rubocop
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']

" vim-quickrun
let g:bufferline_echo = 0

"" RSpec対応
let g:quickrun_config = {}
let g:quickrun_config = {
  \   "_" : {
  \     'runner': 'vimproc',
  \     "runner/vimproc/updatetime" : 10,
  \     "outputter/buffer/split" : ":botright",
  \     "outputter/buffer/close_on_empty" : 1,
  \     'hook/time/enable': '1',
  \   },
  \}

"quickfix
"
let g:quickrun_config['ruby.rspec'] = {
  \ 'command': "rspec",
  \ 'cmdopt': '-c -fd',
  \ 'exec': "bundle exec spring rspec %c %o",
  \}

augroup QRunRSpec
  autocmd!
  autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
augroup END

nnoremap [quickrun] <Nop>
nmap <Space>k [quickrun]
nnoremap <silent> [quickrun]r :call QRunRspecCurrentLine()<CR>
fun! QRunRspecCurrentLine()
  let line = line(".")
  " for rspec3
  exe ":QuickRun -exec 'bundle exec spring rspec %s:" . line ."  %o' -cmdopt '-cfd'" 
  " for rspec2
  " exe ":QuickRun -exec 'bundle exec %c %s %o' -cmdopt '-l " . line . " -c -fd'" 
endfun

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

"" 実行が成功すればバッファへ、失敗すれば quickfix へ出力する
":QuickRun -outputter error -outputter/error/success buffer -outputter/error quickfix

" vim-pukiwiki
let g:pukiwiki_config = {
  \   "LocalWiki" : {
  \       "url" : "https://pukiwiki.nyanko.mydns.jp/",
  \       "top" : "FrontPage",
  \   },
  \}

"vimfiler {{{

let g:vimfiler_edit_action = 'tabopen'

"vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
"現在開いているバッファのディレクトリを開く
nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir -quit<CR>
"現在開いているバッファをIDE風に開く
nnoremap <silent> <Leader>fi :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

" "デフォルトのキーマッピングを変更
" augroup vimrc
"   autocmd FileType vimfiler call s:vimfiler_my_settings()
" augroup END
" function! s:vimfiler_my_settings()
"   nmap <buffer> q <Plug>(vimfiler_exit)
"   nmap <buffer> Q <Plug>(vimfiler_hide)
" endfunction

"}}}

" tabpage
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示
set guioptions-=e " 常にタブラインを表示 

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"unite {{{

"unite prefix key.
nnoremap [unite] <Nop>
nmap , [unite]

"インサートモードで開始しない
let g:unite_enable_start_insert = 0

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  let g:unite_source_grep_recursive_opt = ''
endif

" For ag.

" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

if executable('ag')
    let g:ctrlp_use_caching=0
    let g:ctrlp_user_command='ag %s -i --nocolor --nogroup -g ""'
endif

"file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

"bookmarkだけホームディレクトリに保存
let g:unite_source_bookmark_directory = $HOME . '/.unite/bookmark'

" lightline.vim
let g:lightline = {
        \ 'colorscheme': 'wombat'
        \ }


"現在開いているファイルのディレクトリ下のファイル一覧。
"開いていない場合はカレントディレクトリ
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
"最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
"ブックマーク一覧
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
"ブックマークに追加
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
"uniteを開いている間のキーマッピング
augroup vimrc
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  "ESCでuniteを終了
  nmap <buffer> <ESC> <Plug>(unite_exit)
  "入力モードのときjjでノーマルモードに移動
  imap <buffer> jj <Plug>(unite_insert_leave)
  "入力モードのときctrl+wでバックスラッシュも削除
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  "sでsplit
  nnoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  inoremap <silent><buffer><expr> s unite#smart_map('s', unite#do_action('split'))
  "vでvsplit
  nnoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  inoremap <silent><buffer><expr> v unite#smart_map('v', unite#do_action('vsplit'))
  "fでvimfiler
  nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
endfunction

"}}}

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect

" ESCでIMEをOFF
"" for ubuntu mozc
""" FIXME 日本語入力へ復帰時に、Ctrl + OFF を押下しなければいけない
"call system('type ibus')
"if v:shell_error == 0
"    inoremap <Esc> <Esc>:call system('ibus engine "xkb:jp::jpn"')<CR> " JIS配列でIMEをオフ
"endif
" function! ImInActivate()
"   call system('fcitx-remote -c')
" endfunction
" inoremap <silent> <C-[> <ESC>:call ImInActivate()<CR>
augroup MyAutoCmd
    autocmd!
augroup END
autocmd MyAutoCmd InsertLeave * set iminsert=0 imsearch=0

" IIIMF handling, it must fallbacks to xim (+ set  imactivatekey)
if $GTK_IM_MODULE == "iiim"
  let $GTK_IM_MODULE='xim'
  set imactivatekey="C-space"
endif "

" ibus handling, it must fallbacks to xim
if $GTK_IM_MODULE == "ibus"
  let $GTK_IM_MODULE='xim'
endif "

inoremap  <sllent> <Esc> <Esc>:call IMCtrl('Off')<CR>

""""""""""""""""""""""""""""""
" 日本語入力固定モードの制御関数(デフォルト)
""""""""""""""""""""""""""""""
function! IMCtrl(cmd)
  let cmd = a:cmd
  if cmd == 'On'
    let res = system('xvkbd -text "\[Control]\[Shift]\[Insert]" > /dev/null 2>&1')
  elseif cmd == 'Off'
    let res = system('xvkbd -text "\[Control]\[Shift]\[Delete]" > /dev/null 2>&1')
  elseif cmd == 'Toggle'
    let res = system('xvkbd -text "\[Control]\[space]" > /dev/null 2>&1')
  endif
  return ''
endfunction

"------------------------------------------------------------------------------

"set patchmode=.clean
"set nobackup
"set nowritebackup
set noswapfile
set backupdir=~/tmp
if 704 <= v:version
  set undodir=~/tmp
endif
"set directory=~/tmp
set autowrite
set cursorline
set number
set noautoindent
set number
set noautoindent
set cindent
set encoding=utf8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp
set fileformats=unix,dos,mac
set antialias
set smarttab
set showtabline=2
set shiftwidth=2
set tabstop=2
set expandtab
set nrformats=
set visualbell t_vb=
" バックスペースキーで削除出来るものを指定
" indent：行頭の空白
" eol：改行
" start：挿入モード開始位置より手前の文字
" set backspace=indent,eol,start
" コマンド、検索パターンを100個まで履歴に残す
set history=100
" 検索の時に大文字小文字を区別しない
set ignorecase
" 検索の時に大文字が含まれている場合は区別して検索する
set smartcase
" 最後まで検索したら先頭に戻る
set wrapscan
" インクリメンタルサーチを使わない
"set noincsearch
" if 703 <= v:version
"   set colorcolumn=81
" endif
set modeline
set nowrap
" バッファを切り替えても undo の効力を失わない
set hidden
" クリップボード
set clipboard+=unnamed,autoselect
" 矩形ビジュアルモードでの選択方法
set virtualedit=block
set cmdheight=2
"set viminfo+=n~/users/2no/.vim/sessions/viminfo
" fish shell だった場合、対応していないプラグインがあるので、bash にしておく
if $SHELL =~ 'bin/fish'
  set shell=/bin/bash
endif
" 自動改行を回避
set formatoptions=q
set ambiwidth=double

syntax on
" color
colorscheme molokai
set t_Co=256
let &t_Co=256
let g:rehash256=1
let g:molokai_original=1
" set background=dark
" hi Normal          ctermfg=252 ctermbg=none
" hi Comment         ctermfg=lightcyan

nmap <silent> <leader>w :exec 'silent !google-chrome % &'
