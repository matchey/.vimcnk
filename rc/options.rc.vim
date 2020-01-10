
"---------------------------------------------------------------------------
" Search:"{{{
"

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
" set incsearch
" Don't highlight search result.
" set nohlsearch
" highlight search result.
set hlsearch

" Searches wrap around the end of the file.
set wrapscan
"}}}

"---------------------------------------------------------------------------
" Edit:"{{{
"

" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
set tabstop=2
" Spaces instead <Tab>.
" set softtabstop=4
" Autoindent width.
set shiftwidth=2
" Round indent by shiftwidth.
" set shiftround

" Enable smart indent.
set autoindent smartindent

" Disable modeline.
" set modelines=0
" set nomodeline

" Enable modeline.
set modeline
set modelines=5 "モードラインの検索行数を設定

" <C-a>, <C-x>
" set nrformats+=alpha

" Use clipboard register.

if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
     set clipboard& clipboard+=unnamedplus
  else
     set clipboard& clipboard+=unnamed
  endif
endif
if (has('mac'))
	set clipboard=unnamed
else
	set clipboard=autoselect,unnamedplus "OS のクリップボードと vim のヤンクを共有する．
endif
" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Highlight <>.
" set matchpairs+=<:>

if v:version >= 800
	packadd! matchit
endif

" Display another buffer when current buffer isn't saved.
" set hidden

" to easily change directory to the file being edited
nnoremap cd :cd %:p:h<CR>:pwd<CR>

" working directory is always the same as the file edited
" set autochdir
" autocmd BufEnter * silent! lcd %:p:h

" Search home directory path on cd.
" But can't complete.
"  set cdpath+=~

" Enable folding.
set foldenable
" set foldmethod=expr
set foldmethod=marker
" Show folding level.
set foldcolumn=1
set fillchars=vert:\|
" set commentstring=%s

" FastFold
" autocmd MyAutoCmd TextChangedI,TextChanged *
"       \ if &l:foldenable && &l:foldmethod !=# 'manual' |
"       \   let b:foldmethod_save = &l:foldmethod |
"       \   let &l:foldmethod = 'manual' |
"       \ endif
" autocmd MyAutoCmd BufWritePost *
"       \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
"       \   let &l:foldmethod = b:foldmethod_save |
"       \   execute 'normal! zx' |
"       \ endif

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
  let g:foldCCtext_head = 'repeat("-   ",indent(v:foldstart)/shiftwidth()-1)'
  let g:foldCCtext_tail = 'v:foldend-v:foldstart+1'
  let g:foldCCtext_enable_autofdc_adjuster = 1
endif

let g:localvimrc_persistent=2 " 選択を保存
let g:localvimrc_sandbox=0 " 変更可能にする

let g:tex_flavor='latex'

let g:vim_markdown_folding_disabled=1
" let g:previm_enable_realtime=1

" Use vimgrep.
" set grepprg=internal
" Use grep.
" set grepprg=grep\ -inH

" Exclude = from isfilename.
" set isfname-==

" Keymapping timeout.
" set timeoutlen=250
set timeout timeoutlen=200 ttimeoutlen=100
" set timeout timeoutlen=3000 ttimeoutlen=100
"  'timeout'  'ttimeout'        動作
"     オフ      オフ            タイムアウト (時間切れ) を設けない
"     オン      オンまたはオフ  マッピングとキーコードにタイムアウトあり
"     オフ      オン            キーコードにタイムアウトあり
" 'ttimeout' は、'compatible' がオンになるとオフになる

set viminfo='20,\"1000 "ヤンクの保存行数

" perpetuation undo
if has('persistent_undo')
	set undodir=$HOME/.vimcnk/.vimundo,$HOME/.vimundo,$HOME/.vimcnk,$HOME/.vim
	set undofile
endif

" set viminfo=n$HOME/.vimcnk/.viminfo
set viminfo+=n$HOME/.vimcnk/.viminfo

" let s:session_path = expand('viminfo+=n$HOME/.vimcnk/')

" Shougo's settings"{{{

" CursorHold time.
" set updatetime=1000

" Set swap directory.
" set directory-=.

" Set undofile.
" set undofile
" let &g:undodir = &directory

" Enable virtualedit in visual block mode.
" set virtualedit=block

" Set keyword help.
" set keywordprg=:help

" Check timestamp more for 'autoread'.
" autocmd MyAutoCmd WinEnter * checktime

" Disable paste.
" autocmd MyAutoCmd InsertLeave *
"       \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
"       \ if &l:diff | diffupdate | endif

" Update diff.
" autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" Make directory automatically.
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/

" autocmd MyAutoCmd BufWritePre *
"       \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
" function! s:mkdir_as_necessary(dir, force) abort
"   if !isdirectory(a:dir) && &l:buftype == '' &&
"         \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
"         \              a:dir)) =~? '^y\%[es]$')
"     call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
"   endif
" endfunction

" Use autofmt.
" set formatexpr=autofmt#japanese#formatexpr()

" Use blowfish2
" https://dgl.cx/2014/10/vim-blowfish
" if has('cryptv')
  " It seems 15ms overhead.
  "  set cryptmethod=blowfish2
" endif

" If true Vim master, use English help file.
" set helplang& helplang=en,ja

" Default home directory.
" let t:cwd = getcwd()
"}}}
"}}}

"---------------------------------------------------------------------------
" View:"{{{
"

" Show line number.
set number
" Show title.
set title

execute 'set runtimepath^=' . fnamemodify(expand('<sfile>'), ':h:h')
execute 'set runtimepath+=' . fnamemodify(expand('<sfile>'), ':h:h') . "/after"
colorscheme molokai
syntax on "コードの色分け
set t_Co=256 "カラースキーム反映させるのに必要
highlight Normal ctermbg=none 
set scrolloff=1 " カーソル位置をウィンドウ端からn行残してスクロール

" Don't create backup.
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" Disable bell.
set t_vb=
set novisualbell
" set belloff=all

" Display candidate supplement.
" set nowildmenu
set wildmode=longest,list " 共通部分まで補完->リスト表示
" set wildmode=longest:full,full "共通部分まで補完->候補を順に補完
set wildignorecase
" Increase history amount.
set history=1000

" Completion setting.
" set completeopt=menuone
set completeopt=menu,preview,longest "insertの補完で一致まで
" if has('patch-7.4.775')
"   set completeopt+=noinsert
" endif
" Don't complete from other buffer.
" set complete=.
set complete-=i   " disable scanning included files
set complete-=t   " disable searching tags

set ttyfast

" When a line is long, do not omit it in @.
set display=lastline

hi MatchParen term=standout ctermbg=Black ctermfg=gray guibg=yellow guifg=yellow
" hi MatchParen term=standout ctermbg=Black ctermfg=Black guibg=yellow guifg=yellow

" autocmd FocusLost * :normal gg

set laststatus=2

hi StatusLine ctermbg=253 ctermfg=23
hi StatusLineNC ctermbg=248 ctermfg=238

hi StatusLineTerm ctermbg=29 ctermfg=231
hi StatusLineTermNC ctermbg=238 ctermfg=253

augroup ccsl
  autocmd! ccsl
  " autocmd WinLeave * hi StatusLineTerm   ctermbg=238 ctermbg=253 guifg=#455354 guibg=fg
  " autocmd WinEnter,BufRead * hi StatusLineTerm   ctermbg=238 ctermbg=253 guifg=#455354 guibg=fg
  " autocmd WinLeave * highlight StatusLineTerm guifg=DarkSlateGray guibg=OliveDrab 
  " autocmd WinEnter,BufRead * hi StatusLineTerm   ctermbg=238 ctermbg=253 guifg=#455354 guibg=fg
  " autocmd WinEnter,BufRead * highlight StatusLineTerm guifg=black guibg=white 
  " autocmd WinLeave * hi StatusLineTermNC ctermbg=244 ctermbg=232 guifg=#808080 guibg=#080808
  " autocmd WinEnter,BufRead * hi StatusLineTermNC ctermbg=244 ctermbg=232 guifg=#808080 guibg=#080808
  " autocmd WinEnter,BufRead * highlight StatusLine guifg=black guibg=white 
  " autocmd WinLeave * highlight StatusLine guifg=DarkSlateGray guibg=OliveDrab 
  " autocmd WinEnter,BufRead * highlight StatusLine guifg=black guibg=white 
  " autocmd FocusLost * set nocursorline
  " autocmd FocusGained * set cursorline
  " autocmd WinLeave,FocusLost * set nocursorline
  " autocmd WinEnter,BufRead * set cursorline
augroup END

function! ZenkakuSpace() "{{{
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction
if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif "全角スペースを可視化する "}}}

augroup vimrcEx "{{{
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "windo normal G" | exe "windo normal g`\"" | endif
augroup END " 前回の編集場所のカーソル位置から開く 
"}}}

" Shougo's settings"{{{

" Show <TAB> and <CR>
" set list
" if IsWindows()
"    set listchars=tab:>-,trail:-,extends:>,precedes:<
" else
"    set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
" endif
" Always display statusline.
" set laststatus=2
" Height of command line.
" set cmdheight=2
" Not show command on statusline.
" set noshowcmd
" Title length.
" set titlelen=95
" Title string.
" let &g:titlestring="
"       \ %{expand('%:p:~:.')}%(%m%r%w%)
"       \ %<\(%{WidthPart(
"       \ fnamemodify(&filetype ==# 'vimfiler' ?
"       \ substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),
"       \ &columns-len(expand('%:p:.:~')))}\) - VIM"
" Disable tabline.
" set showtabline=0

" Set statusline.
" let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
"       \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
"       \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
"       \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
"       \ '['.(&filetype!=''?&filetype.',':'')"
"       \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
"       \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
" set linebreak
" set showbreak=\
" set breakat=\ \	;:,!?
" Wrap conditions.
" set whichwrap+=h,l,<,>,[,],b,s,~
" if exists('+breakindent')
"   set breakindent
"   set wrap
" else
"   set nowrap
" endif

" Do not display the greetings message at the time of Vim start.
" set shortmess=aTI

" Do not display the completion messages
" set noshowmode
" if has('patch-7.4.314')
"   set shortmess+=c
" else
"   autocmd MyAutoCmd VimEnter *
"         \ highlight ModeMsg guifg=bg guibg=bg |
"         \ highlight Question guifg=bg guibg=bg
" endif

" Do not display the edit messages
" if has('patch-7.4.1570')
"   set shortmess+=F
" endif

" Display all the information of the tag by the supplement of the Insert mode.
" set showfulltag
" Can supplement a tag in a command-line.
" set wildoptions=tagfile

" if has('nvim')
"   set shada=!,'300,<50,s10,h
" else
"   set viminfo=!,'300,<50,s10,h
" endif

" Disable menu
" let g:did_install_default_menus = 1

" Set popup menu max height.
" set pumheight=20

" Report changes.
" set report=0

" Maintain a current line at the time of movement as much as possible.
" set nostartofline

" Splitting a window will put the new window below the current one.
" set splitbelow
" Splitting a window will put the new window right the current one.
" set splitright
" Set minimal width for current window.
" set winwidth=30
" Set minimal height for current window.
" set winheight=20
" set winheight=1
" Set maximam maximam command line window.
" set cmdwinheight=5
" No equal window size.
" set noequalalways

" Adjust window size of preview and help.
" set previewheight=8
" set helpheight=12

" Display an invisible letter with hex format.
"set display+=uhex

" function! WidthPart(str, width) abort "{{{
"   if a:width <= 0
"     return ''
"   endif
"   let ret = a:str
"   let width = strwidth(a:str)
"   while width > a:width
"     let char = matchstr(ret, '.$')
"     let ret = ret[: -1 - len(char)]
"     let width -= strwidth(char)
"   endwhile
"
"   return ret
" endfunction"}}}
"
" " For conceal.
" set conceallevel=2 concealcursor=niv
"
" set colorcolumn=79
"}}}
"}}}

"---------------------------------------------------------------------------
" Terminal:"{{{

" let s:session_path = expand('~/.vimcnk/.sessions')
"
" if !isdirectory(s:session_path)
"   call mkdir(s:session_path, "p")
" endif

" }}}

"---------------------------------------------------------------------------
" MyVimScripts"{{{
" execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/CatkinMake_pkg.vim'
" execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/CatkinMakePkg_fromCMakeList.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/RosMake.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/MakeInCpp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/clear_undo.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/vnewTab.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/histignore.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/SetRelativeNumber.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/DiffOrig.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/SessionFunc.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/vert_netrw.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/vert_motion_ft.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/vim_in_term.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/LineMove.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h:h').'/scripts/saveLastSession.vim'
" source ~/.vim/script/RosTopicList.vim
" source ~/.vim/script/RosCatkinMake.vim
" source ~/.vim/script/CatkinMake_pkg.vim
" "source ~/.vim/script/RosChibiMake.vim
" source ~/.vim/script/RosRun.vim
" source ~/.vim/script/PyRun.vim
" source ~/.vim/script/CppRun.vim
" source ~/.vim/script/CppMake.vim
" source ~/.vim/script/RosBuild.vim
" "source ~/.vim/script/smooth_scroll.vim
"}}}
 
