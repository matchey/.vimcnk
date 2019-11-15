
" vnoremap <leader>j <Esc>m`:let b:ss=@/<CR>:let b:zz=col('.') - 1<CR>/\%<C-r>=b:zz<CR>c.\zs.\+\n.\{,<C-r>=b:zz<CR>}$<CR>:let @/=b:ss<CR><C-v>``o
" vnoremap <leader>k <Esc>m`:let b:ss=@/<CR>:let b:zz=col('.') - 1<CR>?^.\{,<C-r>=b:zz<CR>}\n.*\%<C-r>=b:zz<CR>c.\zs.<CR>:let @/=b:ss<CR><C-v>``o

" nnoremap <silent> <space>f :<c-u>exe line('.').'/\%'.col('.').'c'.nr2char(getchar())<cr>
" nnoremap <silent> <space>f :<c-u>exe line('.').'/^\s*'.nr2char(getchar())<cr>
" nnoremap <silent> <space>F :<c-u>exe line('.').'#^\s*'.nr2char(getchar())<cr>
"
" command -nargs=1 MyLineSearch let @m=<q-args> | call search('^\s*'. @m)

nnoremap <silent> <space>j :call search('^\s*'.nr2char(getchar()))<CR>
nnoremap <silent> <space>k :call search('^\s*'.nr2char(getchar()), 'b')<CR>


function! VertFT()
  let g:colpos
endfunction
command! VertNetrw :call VertNetrw()

