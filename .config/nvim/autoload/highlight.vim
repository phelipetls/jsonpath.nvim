function! highlight#get_hlgroup_params(hlgroup) abort
  let l:hlgroup_unparsed = s:get_hlgroup_unparsed(a:hlgroup)

  let l:linked_hlgroup = s:get_linked_hlgroup(l:hlgroup_unparsed)
  if !empty(l:linked_hlgroup)
    return highlight#get_hlgroup_params(l:linked_hlgroup)
  endif

  return {
        \ 'fg': s:get_fg(l:hlgroup_unparsed),
        \ 'bg': s:get_bg(l:hlgroup_unparsed),
        \ }
endfunction

function! s:get_hlgroup_unparsed(hlgroup) abort
  redir => l:hlgroup_unparsed
    silent! execute 'highlight ' . a:hlgroup
  redir END

  return l:hlgroup_unparsed
endfunction

function! s:get_linked_hlgroup(hlgroup_unparsed) abort
  let matches = matchlist(a:hlgroup_unparsed, 'links to \(\k*\)')

  if !empty(matches)
    return matches[1]
  endif

  return ''
endfunction

function! s:get_fg(hlgroup_unparsed) abort
  let l:guifg_matches = matchlist(a:hlgroup_unparsed, 'guifg=\([^ ]\+\)')
  if !empty(l:guifg_matches)
    return l:guifg_matches[1]
  endif

  let l:ctermfg_matches = matchlist(a:hlgroup_unparsed, 'ctermfg=\([^ ]\+\)')
  if !empty(l:ctermfg_matches)
    return l:ctermfg_matches[1]
  endif

  return ''
endfunction

function! s:get_bg(hlgroup_unparsed) abort
  let l:guibg_matches = matchlist(a:hlgroup_unparsed, 'guibg=\([^ ]\+\)')
  if !empty(l:guibg_matches)
    return l:guibg_matches[1]
  endif

  let l:ctermbg_matches = matchlist(a:hlgroup_unparsed, 'ctermbg=\([^ ]\+\)')
  if !empty(l:ctermbg_matches)
    return l:ctermbg_matches[1]
  endif

  return ''
endfunction
