function! s:KeepPosExec(cmd)
    let save_view = winsaveview()

    silent! execute "normal! i \<esc>x" | undojoin | execute a:cmd

    call winrestview(save_view)
endfunction

" clang-format
function! s:FormatClang() range
    let file_path = system('find_parent .clang-format')
    if !empty(l:file_path)
      let file_path = split(l:file_path, "\n")[0]
    endif
    if filereadable(l:file_path)
      let cmd = ':silent %! clang-format-14 '
          \ .'-lines='.a:firstline.':'.a:lastline.' '
          \ .'-style=file:'.l:file_path
      let msg = l:file_path
    else
      let cmd = ':silent %! clang-format-14 '
          \ .'-lines='.a:firstline.':'.a:lastline.' '
          \ .'-style="{
          \   AccessModifierOffset                : -4     ,
          \   AlwaysBreakTemplateDeclarations     : true   ,
          \   Standard                            : C++11  ,
          \   ColumnLimit                         : 90     ,
          \   BreakBeforeBraces                   : Attach ,
          \   IndentWidth                         : 2      ,
          \   UseTab                              : Never  ,
          \   AllowShortIfStatementsOnASingleLine : false  ,
          \   AlignConsecutiveAssignments         : true   ,
          \   AlignConsecutiveDeclarations        : true   ,
          \   AlignEscapedNewlinesLeft            : true   ,
          \   IndentCaseLabels                    : true   ,
          \ }"'
      let msg = 'clang-format-14'
    endif
    call s:KeepPosExec(cmd)
    redraw | echomsg l:msg
endfunction

" autopep8
function! s:FormatAutopep8() range
    let cmd = ':silent %! autopep8 '
        \ .'--line-range '.a:firstline.' '.a:lastline.' '
        \ .'-'
    call s:KeepPosExec(cmd)
endfunction

function! s:FormatPrettier() range
    " let cmd = ':silent %! npx prettier --write '
    "     \ .'--range-start '.(a:firstline - 1).' '
    "     \ .'--range-end '.a:lastline.' '
    "     \ .'-'
    " call s:KeepPosExec(cmd)
    execute a:firstline . ',' . a:lastline . '!npx prettier --stdin-filepath ' . expand('%')
endfunction

augroup Formater
    au!
    " autocmd FileType * :silent CocDisable
    " autocmd FileType typescript,javascript,typescriptreact,javascriptreact :silent CocEnable
    " au FileType *
    "     \ :xnoremap <silent> <C-f> <ESC>
    au FileType c,cpp,objc,objcpp :xnoremap <buffer> <silent> <C-f> :call <SID>FormatClang()<cr>
    au FileType python :xnoremap <buffer> <silent> <C-f> :call <SID>FormatAutopep8()<cr>
    " autocmd FileType typescript,javascript,typescriptreact,javascriptreact :xnoremap <C-f> :call <SID>FormatPrettier()<cr>
    " autocmd FileType vue,typescript,javascript,typescriptreact,javascriptreact :xnoremap <buffer> <silent> <C-f> :call CocAction('formatSelected')<cr>
    autocmd FileType vue,typescript,javascript,typescriptreact,javascriptreact :xnoremap <buffer> <silent> <C-f> :call CocAction('format')<cr>
    " autocmd FileType typescript,javascript,typescriptreact,javascriptreact :xnoremap <C-f> <Plug>(coc-format-selected)
augroup END

