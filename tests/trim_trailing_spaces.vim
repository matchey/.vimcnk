set nocompatible
set hidden
let s:root = fnamemodify(expand('<sfile>'), ':h:h')
execute 'source ' . fnameescape(s:root . '/scripts/trim_trailing_spaces.vim')

function! s:buffer(lines) abort
  enew!
  call setline(1, a:lines)
endfunction

" Trim trailing spaces and tabs without changing blank lines or line count.
call s:buffer(['text  ', 'with tab' . "\t\t", ' ', "\t ", '', '  middle  space  '])
TrimTrailingSpaces
call assert_equal(['text', 'with tab', '', '', '', '  middle  space'], getline(1, '$'))

" Trim only the requested line range.
call s:buffer(['first  ', 'second  ', 'third  ', 'fourth  '])
2,3TrimTrailingSpaces
call assert_equal(['first  ', 'second', 'third', 'fourth  '], getline(1, '$'))

" Preserve the current view and cursor while trimming other lines.
call s:buffer(['before  ', 'cursor line  ', 'after  '])
call cursor(2, 5)
let s:view = winsaveview()
TrimTrailingSpaces
let s:trimmed_view = winsaveview()
call assert_equal(s:view.lnum, s:trimmed_view.lnum)
call assert_equal(s:view.col, s:trimmed_view.col)
call assert_equal(s:view.leftcol, s:trimmed_view.leftcol)

" Do not change the search pattern or search history.
let @/ = 'search-pattern'
call histadd('search', 'search-history')
let s:search_history = histget('search', -1)
call s:buffer(['trailing  '])
TrimTrailingSpaces
call assert_equal('search-pattern', @/)
call assert_equal(s:search_history, histget('search', -1))

" Running the command again is idempotent.
let s:trimmed = getline(1, '$')
TrimTrailingSpaces
call assert_equal(s:trimmed, getline(1, '$'))

if !empty(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit
endif
qa!
