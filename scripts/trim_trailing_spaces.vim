function! s:trim_trailing_spaces(first_line, last_line) abort
  let view = winsaveview()
  try
    execute 'keepjumps keeppatterns silent '
          \ . a:first_line . ',' . a:last_line . 's/[ \t]\+$//e'
  finally
    call winrestview(view)
  endtry
endfunction

command! -bar -range=% TrimTrailingSpaces
      \ call s:trim_trailing_spaces(<line1>, <line2>)
