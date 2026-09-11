set nocompatible
set hidden
let s:root = fnamemodify(expand('<sfile>'), ':h:h')
execute 'set runtimepath^=' . fnameescape(s:root . '/tests/fixtures')
execute 'source ' . fnameescape(s:root . '/rc/commit_msg.rc.vim')
let g:commit_message_skill_path = ''
let g:test_requests = []

function! FugitiveGitDir() abort
  return s:root . '/.git'
endfunction

function! s:buffer(...) abort
  enew!
  setlocal filetype=gitcommit
  call setline(1, ['', '# Staged changes'])
  if a:0
    call setline(1, a:1)
  endif
  return bufnr('')
endfunction

function! s:request() abort
  let request_count = len(g:test_requests)
  let target = bufnr('')
  let original = getline(1, '$')
  GenerateCommitMsg
  sleep 20m
  call assert_equal(request_count + 1, len(g:test_requests))
  let request = g:test_requests[-1]
  let prompt_buffer = request.params.textDocument.uri
  call assert_notequal(target, prompt_buffer)
  call assert_equal(target, bufnr(''))
  call assert_equal(original, getline(1, '$'))
  let context = map(copy(original[1:]), {_, line -> substitute(line, '^# \?', '', '')})
  call assert_equal(context + ['', 'Commit message (plain text, without fences or trailers):', ''],
        \ request.document)
  call assert_equal({'line': len(request.document) - 1, 'character': 0},
        \ request.params.position)
  if !request.cancelled
    call assert_equal('markdown', getbufvar(prompt_buffer, '&filetype'))
    call assert_equal('nofile', getbufvar(prompt_buffer, '&buftype'))
    call assert_equal(0, getbufvar(prompt_buffer, '&swapfile'))
    call assert_equal(0, getbufvar(prompt_buffer, '&undofile'))
    call assert_false(buflisted(prompt_buffer))
    call assert_false(filereadable(bufname(prompt_buffer)))
  endif
  return request
endfunction

function! s:item(text) abort
  let position = g:test_requests[-1].params.position
  return {
        \ 'insertText': a:text,
        \ 'range': {
        \   'start': copy(position),
        \   'end': copy(position),
        \ },
        \ }
endfunction

call s:buffer()
let s:view = winsaveview()
let s:req = s:request()
call assert_equal('textDocument/copilotPanelCompletion', s:req.method)
call assert_equal({'line': 3, 'character': 0}, s:req.params.position)
call assert_false(has_key(s:req.params, 'context'))
let s:first = s:item("\nKeep startup completion\n\nAvoid CLI generation.")
let s:first.command = {
      \ 'command': 'github.copilot.didAcceptPanelCompletionItem',
      \ 'arguments': ['synthetic-completion'],
      \ 'title': 'Accept completion 1',
      \ }
call s:req.resolve({'items': [
      \ s:first,
      \ s:item('Do not insert the second candidate'),
      \ ]})
call assert_equal(['Keep startup completion', '', 'Avoid CLI generation.', '',
      \ '# Staged changes'], getline(1, '$'))
call assert_equal(s:view, winsaveview())
call assert_false(bufexists(s:req.params.textDocument.uri))
call assert_equal('workspace/executeCommand', g:test_requests[-1].method)
call assert_equal(s:first.command, g:test_requests[-1].params)

" A cursor in the comments must stay on the same text after insertion above it.
call s:buffer()
call cursor(2, 3)
let s:req = s:request()
call assert_equal({'line': 3, 'character': 0}, s:req.params.position)
call s:req.resolve([s:item("Complete from anywhere\r\n\r\nKeep the cursor still.")])
call assert_equal(['Complete from anywhere', '', 'Keep the cursor still.', '',
      \ '# Staged changes'], getline(1, '$'))
call assert_equal([5, 3], getcurpos()[1:2])

" Late responses must not overwrite edits, even if the first line is still empty.
call s:buffer()
let s:req = s:request()
call append(1, 'User-written body')
call s:req.resolve({'items': [s:item('Do not insert')]})
call assert_equal(['', 'User-written body', '# Staged changes'], getline(1, '$'))

let s:target = s:buffer()
let s:req = s:request()
call s:buffer()
let s:current = bufnr('')
call s:req.resolve({'items': [s:item('Complete the hidden buffer')]})
call assert_equal(s:current, bufnr(''))
call assert_equal('Complete the hidden buffer', getbufline(s:target, 1)[0])
call assert_equal('', getline(1))

call s:buffer()
let s:req = s:request()
setlocal nomodifiable
call s:req.resolve({'items': [s:item('Do not change a locked buffer')]})
call assert_equal('', getline(1))
setlocal modifiable

call s:buffer()
let s:req = s:request()
setlocal readonly
call s:req.resolve({'items': [s:item('Do not change a read-only buffer')]})
call assert_equal('', getline(1))
setlocal noreadonly

call s:buffer()
let s:old = s:request()
let s:new = s:request()
call assert_equal(1, s:old.cancelled)
call s:old.resolve({'items': [s:item('Stale response')]})
call assert_equal('', getline(1))
call s:new.resolve({'items': [s:item('Latest response')]})
call assert_equal('Latest response', getline(1))

call s:buffer()
let s:req = s:request()
CancelCommitMsg
call assert_equal(1, s:req.cancelled)
call s:req.resolve({'items': [s:item('Cancelled response')]})
call assert_equal('', getline(1))

call s:buffer()
let s:req = s:request()
call s:req.resolve(v:null)
call assert_equal('', getline(1))
call assert_match('No completion candidate', execute('messages'))
let s:req = s:request()
call s:req.reject({'code': -1, 'message': 'Authentication required'})
call assert_equal('', getline(1))
call assert_match('Authentication required', execute('messages'))

call s:buffer()
let s:req = s:request()
let s:invalid = s:item('Replace comments')
let s:invalid.range.end.line += 1
call s:req.resolve({'items': [s:invalid]})
call assert_equal(['', '# Staged changes'], getline(1, '$'))
call assert_match('Unsupported completion range', execute('messages'))

call s:buffer()
let s:req = s:request()
call s:req.resolve({'items': [s:item("```text\nUse inline completion\n```\nCo-authored-by: Test\n# Git template\nDo not insert context")]})
call assert_equal(['Use inline completion', '', '# Staged changes'], getline(1, '$'))

call s:buffer()
let s:req = s:request()
call s:req.resolve({'items': [{'insertText': 'Complete without an explicit range'}]})
call assert_equal('Complete without an explicit range', getline(1))

call s:buffer()
let s:req = s:request()
let s:snippet = s:item('')
let s:snippet.insertText = {'kind': 'snippet', 'value': '${1:subject}'}
call s:req.resolve({'items': [s:snippet]})
call assert_equal('', getline(1))
call assert_match('Unsupported completion text', execute('messages'))

call s:buffer('Existing message')
let s:count = len(g:test_requests)
GenerateCommitMsg
sleep 20m
call assert_equal(s:count, len(g:test_requests))
call assert_equal('Existing message', getline(1))
call s:buffer()
call append(1, 'Existing body')
GenerateCommitMsg
sleep 20m
call assert_equal(s:count, len(g:test_requests))

call s:buffer()
let g:test_copilot_enabled = 0
GenerateCommitMsg
sleep 20m
call assert_equal(s:count, len(g:test_requests))
call assert_match('Copilot is disabled', execute('messages'))
let g:test_copilot_enabled = 1

call s:buffer()
let g:commit_msg_completion_timeout = 10
let s:req = s:request()
sleep 30m
call assert_equal(1, s:req.cancelled)
call s:req.resolve({'items': [s:item('Too late')]})
call assert_equal('', getline(1))
call assert_match('Completion timed out', execute('messages'))
let g:commit_msg_completion_timeout = 30000

let s:target = s:buffer()
let s:req = s:request()
execute 'bwipeout! ' . s:target
call assert_equal(1, s:req.cancelled)
call s:req.resolve({'items': [s:item('Closed buffer')]})
call assert_false(bufexists(s:target))

call s:buffer()
let s:count = len(g:test_requests)
GenerateCommitMsg
CancelCommitMsg
sleep 20m
call assert_equal(s:count, len(g:test_requests))

" Exercise the startup event, including re-sourcing without duplicate handlers.
execute 'source ' . fnameescape(s:root . '/rc/commit_msg.rc.vim')
call s:buffer()
let g:commit_msg_auto_complete = 0
let s:count = len(g:test_requests)
doautocmd BufReadPost COMMIT_EDITMSG
sleep 20m
call assert_equal(s:count, len(g:test_requests))
call s:buffer()
let g:commit_msg_auto_complete = 1
doautocmd BufReadPost COMMIT_EDITMSG
sleep 20m
call assert_equal(s:count + 1, len(g:test_requests))
call g:test_requests[-1].resolve({'items': [s:item('Complete at startup')]})
call assert_equal('Complete at startup', getline(1))

" Filetype detection may run after the commit helper's BufReadPost handler.
let s:tempdir = tempname()
call mkdir(s:tempdir)
call writefile(['', '# Commit template'], s:tempdir . '/COMMIT_EDITMSG')
filetype on
let s:count = len(g:test_requests)
execute 'edit ' . fnameescape(s:tempdir . '/COMMIT_EDITMSG')
sleep 20m
call assert_equal('gitcommit', &filetype)
call assert_equal(s:count + 1, len(g:test_requests))
call g:test_requests[-1].resolve({'items': [s:item('Complete after filetype detection')]})
call assert_equal('Complete after filetype detection', getline(1))
bwipeout!
call delete(s:tempdir . '/COMMIT_EDITMSG')
call delete(s:tempdir, 'd')

call s:buffer()
let &runtimepath = substitute(&runtimepath, escape(s:root . '/tests/fixtures,', '\'), '', '')
delfunction copilot#Request
let s:count = len(g:test_requests)
GenerateCommitMsg
sleep 20m
call assert_equal(s:count, len(g:test_requests))
call assert_match('copilot.vim completion API is unavailable', execute('messages'))
call assert_equal('', getline(1))

for s:request in g:test_requests
  if s:request.method ==# 'textDocument/copilotPanelCompletion'
    call assert_false(bufexists(s:request.params.textDocument.uri),
          \ 'Completion prompt buffer was not cleaned up')
  endif
endfor

if !empty(v:errors)
  for s:error in v:errors
    echomsg s:error
  endfor
  cquit
endif
qa!
