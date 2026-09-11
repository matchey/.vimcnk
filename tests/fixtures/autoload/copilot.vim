function! copilot#Enabled() abort
  return get(g:, 'test_copilot_enabled', 1)
endfunction

function! s:cancel() dict abort
  let self.cancelled = 1
endfunction

function! copilot#Request(method, params, ...) abort
  let request = {
        \ 'method': a:method,
        \ 'params': deepcopy(a:params),
        \ 'resolve': get(a:000, 0, v:null),
        \ 'reject': get(a:000, 1, v:null),
        \ 'cancelled': 0,
        \ 'Cancel': function('s:cancel'),
        \ }
  if has_key(a:params, 'textDocument')
    let request.document = getbufline(a:params.textDocument.uri, 1, '$')
  endif
  call add(g:test_requests, request)
  return request
endfunction
