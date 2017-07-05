
augroup filetypedetect
" au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash[_-]profile*,.bash[_-]logout*,.bash[_-]aliases*,*.bash,*/{,.}bash[_-]completion{,.d,.sh}{,/*},*.ebuild,*.eclass call SetFileTypeSH("bash")
" au BufNewFile,BufRead .bash[_-]pathinit*, call SetFileTypeSH("bash")
au BufNewFile,BufRead .bash[_-]pathinit set filetype=sh

augroup END

" autocmd FileType cpp setlocal commentstring=//%s
