" dein configurations.

let s:dein_dir = expand('~/.vimcnk/rc/plugins')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" let s:dein_repo_dir = s:dein_dir . '/dein/repos/github.com/Shougo/dein.vim'

" if &compatible
"   set nocompatible               " Be iMproved
" endif

" Required:
execute 'set runtimepath+=' . s:dein_repo_dir

" Required:
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vimcnk/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/deinlazy.toml'
  " Let dein manage dein
  " Required:
  " call dein#add('s:dein_repo_dir')
  " Add or remove your plugins here:
  " call dein#add('taketwo/vim-ros')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  " call dein#add('LeafCage/foldCC')
  " call dein#add('tomtom/tcomment_vim')
  " call dein#add('vim-latex/vim-latex')
  " call dein#add('scrooloose/syntastic')
  " call dein#add('embear/vim-localvimrc')
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  " You can specify revision/branch/tag.
  " call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

  if dein#tap('deoplete.nvim') && has('nvim')
	  call dein#disable('neocomplete.vim')
  endif
  call dein#disable('neobundle.vim')
  call dein#disable('neopairs.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif


