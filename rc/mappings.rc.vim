"---------------------------------------------------------------------------
" Key-mappings:
"

" Use <C-Space>.
" nmap <C-Space>  <C-@>
" cmap <C-Space>  <C-@>

" Visual mode keymappings: "{{{
" Indent
" nnoremap > >>
" nnoremap < <<
" xnoremap > >gv
" xnoremap < <gv

" if (!has('nvim') || $DISPLAY != '') && has('clipboard')
"   xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
" endif
vnoremap <silent> * "zy:let @/ = @z<CR>:set hlsearch<CR>
" vnoremap ccc <ESC>a*/<ESC>gvo<ESC>i/*<ESC>
vnoremap <silent> cy   c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

" commentout and paste
vmap gy ygvgcgv<ESC>p

vnoremap <silent> x x:let@x=@"<CR>
vnoremap <silent> d d:let@d=@"<CR>
vnoremap <silent> s "dygvs

" move lines
" vnoremap <C-Up> "zx<Up>"zP`[V`]
" vnoremap <C-Down> "zx"zp`[V`]

"}}}

" Insert mode keymappings: "{{{
" <C-t>: insert tab.
" inoremap <C-t>  <C-v><TAB>
" Enable undo <C-w> and <C-u>.
" inoremap <C-w>  <C-g>u<C-w>
" inoremap <C-u>  <C-g>u<C-u>
" inoremap {{ {}<Left><CR><Up><ESC>o
" inoremap }} {<ESC>o}<ESC>dd
" inoremap {<C-l> {<Down>
" inoremap (( ()<Left>
" inoremap )) (<ESC>Ea)
" inoremap (<C-l> (<ESC>Ea)
" inoremap "" ""<Left>
" inoremap "" "<ESC>Ea"
" inoremap "<Right> "<Right>
" inoremap "<C-l> "<Right>
" inoremap [[ []<Left>
" inoremap ]] [<ESC>Ea]
" inoremap < <><Left>
" inoremap <<Right> <
inoremap <Down> <ESC>gja
inoremap <Up> <ESC>gka
" inoremap <C-h> <Left>
" inoremap <C-j> <ESC>gja
" inoremap <C-k> <ESC>gka
" inoremap <C-l> <Right>

" as delete (fn + BackSpace)
inoremap <C-d> <Delete>
" インデントを１つ減らす<C-d>
inoremap <C-e> <End>
inoremap <C-u> <C-\><C-o>"yd^
inoremap <C-w> <C-\><C-o>"ydb
inoremap <C-y> <C-r>y
" inoremap <C-l> <ESC><Right>s

" inoremap <A-j> lll
" inoremap @p <Right><ESC>"0pi 
" inoremap <C-j> <ESC>:s/^ *//<CR>kgJ:noh<CR>i

"}}}

" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-d>: delete char.
" cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-n>: next history.
cnoremap <C-n>          <Down>
" <C-p>: previous history.
cnoremap <C-p>          <Up>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
" <C-g>: Exit.
" cnoremap <C-g>          <C-c>

" cnoremap <C-h> <Left>
" cnoremap <C-j> <Down>
" cnoremap <C-k> <Up>
" cnoremap <C-l> <Right>
" cnoremap W w !sudo tee % > /dev/null
" cnoremap vdiff vertical<Space>diffsplit<Space>
command! W w !sudo tee % > /dev/null
command! -complete=file Vdiff vertical<Space>diffsplit<Space>
" au FileType plantuml command! OpenUml :!google-chrome %
"}}}

" Terminal mode keymappings"{{{
if has('terminal')
  " tnoremap <Esc> <C-\><C-n>
  " tnoremap jj <C-\><C-n>
  " tnoremap gt <C-\><C-n>gt
  " tnoremap <silent> <C-h> :noh<CR>
  " tnoremap jj <C-w><S-n>
  " tnoremap <C-w><C-u> <C-w><S-n><C-u><C-w>7>
  tnoremap <C-w><C-u> <C-w><S-n><C-u>
  tnoremap <C-w>/ <C-w><S-n>/
  " tnoremap i <C-w>=i
endif
" }}}

" Netrw keymappings"{{{
" autocmd filetype netrw nmap <buffer> x :call NetrwCollapse()<CR>
" }}}

" movement "{{{
" noremap j gj
" noremap <Down> gj
"nnoremap <Down> <C-w><Down><Down>
" noremap k gk
" noremap <Up> gk
" noremap <silent> gh :SetRelativeNumber<CR>
noremap <silent> gh :set relativenumber!<CR>
" nnoremap j :SetRelativeNumber j<CR>
" nnoremap k :SetRelativeNumber k<CR>
" vnoremap j :VSetRelativeNumber j<CR>
" vnoremap k :VSetRelativeNumber k<CR>
"nnoremap <Up> <C-w><Up><Up>
" noremap <S-h> ^
" noremap <S-l> $
" noremap <S-k> H
" noremap <S-j> L
" noremap <S-k> {
" noremap <S-j> }
" noremap { [{
" noremap } ]}
" noremap ( [(
" noremap ) ])
"}}}

" yank and paste"{{{

noremap 0p "0p
noremap <Space>y "ay
noremap <Space>p "ap
noremap Y y$
noremap 1p "1p

" past continuously
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

nnoremap <silent> ciw "cyiwciw
nnoremap <silent> cw "cywcw
nnoremap <silent> diw "dyiwdiw
nnoremap <silent> dw "dywdw

"}}}

" [Space]: Other useful commands "{{{
" Smart space mapping.
nmap  <Space>   [Space]
nnoremap  [Space]   <Nop>

nnoremap <Space>m :make<Enter>
" nnoremap [Space]m :make<Enter>
nnoremap <Space>p :make\|!xdg-open %:r.png<Enter><Enter>

" not move only highligt
nnoremap <silent> * :let @/="\\<"<CR>"zyiw:let @/.=@z<CR>:let @/.="\\>"<CR>:set hlsearch<CR>

nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
" nmap * <Plug>(anzu-star-with-echo)
" nmap # <Plug>(anzu-sharp-with-echo)
" set statusline=%{anzu#search_status()}

" no highlit search
nnoremap <silent> <C-h> :noh<CR>

" Substitute for the word under cursor follow this line 
nnoremap [Space]s "syiw:,$s/<C-r>s//gc<Left><Left><Left>
vnoremap <silent> <Space>s "sy:,$s/<C-r>s//gc<Left><Left><Left>

" map for fold
nnoremap [Space]a za
nnoremap [Space]i zMzv

" indent format all
" nnoremap == gg=G''
" indent format line
nnoremap == v=

" Easy escape.
inoremap jj <ESC>
" inoremap <C-j> <ESC>
" inoremap jj <ESC><Right>
" cnoremap <expr> j
"       \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
" inoremap j<Space>     j

" yank all
" nmap <ESC>a <M-a>
" nnoremap <ESC>a ggyG''

" quick write quit
nnoremap <Space>w :w<Enter>
nnoremap <silent><Space>q :q<Enter>

" put space
nnoremap <Space><Space> i<Space><ESC><Right>

" put a new line
nnoremap [Space]<CR> o<ESC>

"count number of characters
" vnoremap co :s/./&/gn <== g<C-g>

" Shougo's mappings"{{{

" Set autoread.
" nnoremap [Space]ar
"       \ :<C-u>call vimrc#toggle_option('autoread')<CR>
" " Set spell check.
" nnoremap [Space]p
"       \ :<C-u>call vimrc#toggle_option('spell')<CR>
"       \: set spelllang=en_us<CR>
"       \: set spelllang+=cjk<CR>
" nnoremap [Space]w
"       \ :<C-u>call vimrc#toggle_option('wrap')<CR>
"
" " Easily edit .vimrc
" nnoremap <silent> [Space]ev  :<C-u>edit $MYVIMRC<CR>
"
" " Useful save mappings.
" nnoremap <silent> <Leader><Leader> :<C-u>update<CR>
"
" s: Windows and buffers(High priority) "{{{
" The prefix key.
" nnoremap    [Window]   <Nop>
" nmap    s [Window]
" nnoremap <silent> [Window]p  :<C-u>vsplit<CR>:wincmd w<CR>
" nnoremap <silent> [Window]o  :<C-u>only<CR>
" nnoremap <silent> <Tab>      :wincmd w<CR>
" nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""
"}}}

" e: Change basic commands "{{{
" The prefix key.
" nnoremap [Alt]   <Nop>
" nmap    S  [Alt]

" Indent paste.
" nnoremap <silent> [Alt]p o<Esc>pm``[=`]``^
" nnoremap <silent> [Alt]P O<Esc>Pm``[=`]``^
"}}}

" Better x
" nnoremap x "_x

" Disable Ex-mode.
" nnoremap Q  q

" Useless command.
" nnoremap M  m

" Smart <C-f>, <C-b>.
" noremap <expr> <C-f> max([winheight(0) - 2, 1])
"       \ . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
" noremap <expr> <C-b> max([winheight(0) - 2, 1])
"       \ . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")

" Disable ZZ.
" nnoremap ZZ  <Nop>

" Select rectangle.
" xnoremap r <C-v>

" Redraw.
" nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" If press l on fold, fold open.
" nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
" xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" Substitute.
" xnoremap s :s//g<Left><Left>

" Sticky shift in English keyboard."{{{
" Sticky key.
" inoremap <expr> ;  vimrc#sticky_func()
" cnoremap <expr> ;  vimrc#sticky_func()
" snoremap <expr> ;  vimrc#sticky_func()
"}}}

" a>, i], etc... "{{{
" <angle>
" onoremap aa  a>
" xnoremap aa  a>
" onoremap ia  i>
" xnoremap ia  i>
"
" " [rectangle]
" onoremap ar  a]
" xnoremap ar  a]
" onoremap ir  i]
" xnoremap ir  i]
"}}}

" Improved increment.
" nmap <C-a> <SID>(increment)
" nmap <C-x> <SID>(decrement)
" nnoremap <silent> <SID>(increment)    :AddNumbers 1<CR>
" nnoremap <silent> <SID>(decrement)   :AddNumbers -1<CR>
" command! -range -nargs=1 AddNumbers
"       \ call vimrc#add_numbers((<line2>-<line1>+1) * eval(<args>))
"
" nnoremap <silent> #    <C-^>
" nnoremap ;;     ;
"
" " Change current word and repeatable
" nnoremap cn *``cgn
" nnoremap cN *``cgN
"
" " Change selected word and repeatable
" vnoremap <expr> cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
" vnoremap <expr> cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"
"}}}

"}}}

