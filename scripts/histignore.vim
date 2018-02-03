
" let g:histignore = '^q:^w'
" function! s:ignore_history(commandline)
" 	let oldhist=&history
" 	try
" 		if len(filter(split(g:histignore, ':'), 'a:commandline =~ v:val')) == 0
" 			call histadd(':', a:commandline)
" 		endif
" 		set history=0
" 		exe a:commandline
" 	catch
" 		echohl ErrorMsg | echomsg v:exception | echohl None
" 	finally
" 		let &history=oldhist
" 		unlet oldhist
" 	endtry
" endfunction
" command! -nargs=+ IgnoreHistory call s:ignore_history(<q-args>)

" function! s:remove_history()
" 	keeppatterns histdel(':', -1)
" endfunction

augroup hist_ignore
	autocmd!
	autocmd BufWritePost * :keeppatterns call histdel(':', -1)
	" autocmd VimLeavePre * :keeppatterns call histdel(':', -1)
	autocmd QuitPre * :keeppatterns call histdel(':', -1)
augroup END

