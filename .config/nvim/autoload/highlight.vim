function! highlight#get_hlgroup_params(hlgroup) abort
  let l:raw_hlgroup = <SID>getRawHlGroup(a:hlgroup)

  let l:linked_hlgroup = <SID>getLinkedHlgroup(l:raw_hlgroup)
  if !empty(l:linked_hlgroup)
    return highlight#get_hlgroup_params(l:linked_hlgroup)
  endif

  return {
        \ 'fg': <SID>getFg(l:raw_hlgroup),
        \ 'bg': <SID>getBg(l:raw_hlgroup),
        \ }
endfunction

function! s:getRawHlGroup(hlgroup) abort
  redir => l:raw_hlgroup
    silent! execute 'highlight ' . a:hlgroup
  redir END

  return l:raw_hlgroup
endfunction

function! s:getLinkedHlgroup(raw_hlgroup) abort
  let matches = matchlist(a:raw_hlgroup, 'links to \(\k*\)')

  if !empty(matches)
    return matches[1]
  endif

  return ''
endfunction

function! s:getFg(raw_hlgroup) abort
  let l:guifg_matches = matchlist(a:raw_hlgroup, 'guifg=\([^ ]\+\)')
  if !empty(l:guifg_matches) && len(l:guifg_matches) > 1
    return l:guifg_matches[1]
  endif

  let l:ctermfg_matches = matchlist(a:raw_hlgroup, 'ctermfg=\([^ ]\+\)')
  if !empty(l:ctermfg_matches) && len(l:ctermfg_matches) > 1
    return l:ctermfg_matches[1]
  endif

  return ''
endfunction

function! s:getBg(raw_hlgroup) abort
  let l:guibg_matches = matchlist(a:raw_hlgroup, 'guibg=\([^ ]\+\)')
  if !empty(l:guibg_matches) && len(l:guibg_matches) > 1
    return l:guibg_matches[1]
  endif

  let l:ctermbg_matches = matchlist(a:raw_hlgroup, 'ctermbg=\([^ ]\+\)')
  if !empty(l:ctermbg_matches) && len(l:ctermbg_matches) > 1
    return l:ctermbg_matches[1]
  endif

  return ''
endfunction
