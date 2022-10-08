function! highlight#get_hlgroup_params(hlgroup) abort
  let raw_hlgroup = <SID>getRawHlGroup(a:hlgroup)

  let linked_hlgroup = <SID>getLinkedHlgroup(raw_hlgroup)
  if !empty(linked_hlgroup)
    return highlight#get_hlgroup_params(linked_hlgroup)
  endif

  return {
        \ 'fg': <SID>getFg(raw_hlgroup),
        \ 'bg': <SID>getBg(raw_hlgroup),
        \ }
endfunction

function! s:getRawHlGroup(hlgroup) abort
  redir => raw_hlgroup
    silent! execute 'highlight ' . a:hlgroup
  redir END

  return raw_hlgroup
endfunction

function! s:getLinkedHlgroup(raw_hlgroup) abort
  let matches = matchlist(a:raw_hlgroup, 'links to \(\k*\)')

  if !empty(matches)
    return matches[1]
  endif

  return ''
endfunction

function! s:getFg(raw_hlgroup) abort
  let guifg_matches = matchlist(a:raw_hlgroup, 'guifg=\([^ ]\+\)')
  if !empty(guifg_matches) && len(guifg_matches) > 1
    return guifg_matches[1]
  endif

  let ctermfg_matches = matchlist(a:raw_hlgroup, 'ctermfg=\([^ ]\+\)')
  if !empty(ctermfg_matches) && len(ctermfg_matches) > 1
    return ctermfg_matches[1]
  endif

  return ''
endfunction

function! s:getBg(raw_hlgroup) abort
  let guibg_matches = matchlist(a:raw_hlgroup, 'guibg=\([^ ]\+\)')
  if !empty(guibg_matches) && len(guibg_matches) > 1
    return guibg_matches[1]
  endif

  let ctermbg_matches = matchlist(a:raw_hlgroup, 'ctermbg=\([^ ]\+\)')
  if !empty(ctermbg_matches) && len(ctermbg_matches) > 1
    return ctermbg_matches[1]
  endif

  return ''
endfunction
