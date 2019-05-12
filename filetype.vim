
augroup filetypedetect
" au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash[_-]profile*,.bash[_-]logout*,.bash[_-]aliases*,*.bash,*/{,.}bash[_-]completion{,.d,.sh}{,/*},*.ebuild,*.eclass call SetFileTypeSH("bash")
" au BufNewFile,BufRead .bash[_-]pathinit*, call SetFileTypeSH("bash")

au BufNewFile,BufRead *.launch set filetype=xml
au BufNewFile,BufRead *.gs set filetype=javascript
au BufNewFile,BufRead .inputrc set filetype=sh
au BufNewFile,BufRead *bashrc/* set filetype=sh
au BufNewFile,BufRead .bash[_-]envs set filetype=sh
au BufNewFile,BufRead .bash[_-]envs syn region shSetList oneline matchgroup=shSet start="\<\(declare\|typeset\|local\|export\|unset\)\>\ze[^/]" end="$"	matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+#\|="	contains=@shIdList

augroup END

" autocmd FileType cpp setlocal commentstring=//%s
