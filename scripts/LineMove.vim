
function! s:LineMoveUp()
  " mode = currentmode
  " normal gv
  " echo mode()

  " let l:pos = getpos(".")
  " normal `<
  " echo line(".")
  " echo col(".")
  " normal `>
  " echo mode()
  " echo line(".")
  " echo col(".")

  " switch mode
  "   visu
  "   line dd
  "   normal
  "   dd
  "
  " if mode vis
  "   vis
  "
  " if last cmd linemove up || down
  "   undojoin

  " silent normal gv"zx<Up>"zP`[V`]
endfunction

function! s:LineMoveDown()
  " silent normal gv"zx"zp`[V`]
endfunction

" vnoremap <C-Up> "zx<Up>"zP`[V`]
" vnoremap <C-Down> "zx"zp`[V`]

noremap <silent> <C-Up> :call <SID>LineMoveUp()<CR>
noremap <silent> <C-Down> :call <SID>LineMoveDown()<CR>

" xno <expr> <C-Up> {'v': "\<esc>:echo 'characterwise'",
"       \  'V': "\<esc>:echo 'linewise'",
"       \  "\<c-v>": "\<esc>:echo 'blockwise'",
"       \ }[mode()]

