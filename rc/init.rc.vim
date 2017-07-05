"---------------------------------------------------------------------------
" Initialize:
"

" set encoding=utf-8
" set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,latin1,utf-8 "shift-jisで開くための設定

" let s:is_windows = has('win32') || has('win64')
"
" function! IsWindows() abort
"   return s:is_windows
" endfunction
"
" function! IsMac() abort
"   return !s:is_windows && !has('win32unix')
"       \ && (has('mac') || has('macunix') || has('gui_macvim')
"       \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
" endfunction

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
" if has('vim_starting') && &encoding !=# 'utf-8'
"   if IsWindows() && !has('gui_running')
"     set encoding=cp932
"   else
"     set encoding=utf-8
"   endif
" endif
set encoding=utf-8

" Build encodings.
" let &fileencodings = join([
"       \ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'])
set fileencodings=utf-8,ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,latin1,utf-8 "shift-jisで開くための設定

" execute 'set runtimepath+=' . fnamemodify(expand('<sfile>'), ':h:h') . "/after"

" Setting of terminal encoding.
" if !has('gui_running') && IsWindows()
"   " For system.
"   set termencoding=cp932
" endif

" if has('multi_byte_ime')
"   set iminsert=0 imsearch=0
" endif

" Use English interface.
" language message C

" Use ',' instead of '\'.
" " Use <Leader> in global plugin.
" let g:mapleader = ','
" " Use <LocalLeader> in filetype plugin.
" let g:maplocalleader = 'm'

" " Release keymappings for plug-in.
" nnoremap ;  <Nop>
" nnoremap m  <Nop>
" nnoremap ,  <Nop>

" if IsWindows()
"   " Exchange path separator.
"    set shellslash
" endif

" let $CACHE = expand('~/.cache')

" if !isdirectory(expand($CACHE))
"   call mkdir(expand($CACHE), 'p')
" endif
"
" if filereadable(expand('~/.secret_vimrc'))
"   execute 'source' expand('~/.secret_vimrc')
" endif

" Load dein.
" let s:dein_dir = finddir('dein.vim', '.;')
" if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
"   if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
"     let s:dein_dir = expand('$CACHE/dein')
"           \. '/repos/github.com/Shougo/dein.vim'
"     if !isdirectory(s:dein_dir)
"       execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
"     endif
"   endif
"   execute 'set runtimepath^=' . substitute(
"         \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
" endif

" Disable packpath
" set packpath=

"let s:vimmc_dir = expand('~/.vimcnk')
"execute 'set runtimepath+=' . s:vimmc_dir
"
"execute 'set runtimepath+=' . fnamemodify(expand('<sfile>'), ':h:h').'/colors'

"---------------------------------------------------------------------------
" Disable default plugins

" " Disable menu.vim
" if has('gui_running')
"    set guioptions=Mc
" endif
"
" let g:loaded_2html_plugin      = 1
" let g:loaded_logiPat           = 1
" let g:loaded_getscriptPlugin   = 1
" let g:loaded_gzip              = 1
" let g:loaded_man               = 1
" let g:loaded_matchit           = 1
" let g:loaded_matchparen        = 1
" let g:loaded_netrwFileHandlers = 1
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
" let g:loaded_rrhelper          = 1
" let g:loaded_shada_plugin      = 1
" let g:loaded_spellfile_plugin  = 1
" let g:loaded_tarPlugin         = 1
" let g:loaded_tutor_mode_plugin = 1
" let g:loaded_vimballPlugin     = 1
" let g:loaded_zipPlugin         = 1
