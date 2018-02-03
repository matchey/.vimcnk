
function! s:vnew_in_newtab(...)
	if a:0 == 1
		" tabedit %:p
		exec 'tabnew ' . a:1
		" exec 'rightbelow vnew ' . a:1
		" exec 'vnew ' . a:1
	else
		exec 'tabedit ' . a:1
		for l:file in a:000[1: ]
			exec 'rightbelow vnew ' . l:file
		endfor
	endif
endfunction
command! -bar -nargs=+ -complete=file New call s:vnew_in_newtab(<f-args>)

