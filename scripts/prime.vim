
" S<Tab><C-[>qa>>Ypq540@a:g/\v^(<Tab><Tab>+)\1+$/d
" qb0C<C-R>=len(@-)
" <C-[>kq99@bZZ

" :pu=filter(range(2,100),'filter(range(2,v:val-1),v:val.''%v:val==0'')==[]')|1d
" :pu=filter(range(2,541),'filter(range(2,v:val-1),v:val.''%v:val==0'')==[]')|1d

" :pu=filter(range(2,100),'repeat(''x'',v:val)!~''\v^(xx+)\1+$''')|1d

:pu=filter(range(2,100),'filter(range(2,v:val-1),v:val.''%v:val==0'')==[]')


