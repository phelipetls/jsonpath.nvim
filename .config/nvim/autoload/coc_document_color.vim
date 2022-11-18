function! coc_document_color#setup_autocmds() abort
  augroup CocDocumentColor
    autocmd!
    autocmd TextChanged,TextChangedI,TextChangedP <buffer> call coc_document_color#request()
  augroup END
endfunction

function! coc_document_color#cleanup_autocmds() abort
  autocmd! CocDocumentColor
endfunction

let s:NAMESPACE_ID = nvim_create_namespace('cocDocumentColor')

let s:DELAY_INTERVAL = 500
let s:timer_id = ''

function! s:Delay(fn, interval) abort
  if !empty(s:timer_id)
    call timer_stop(s:timer_id)
  endif

  let s:timer_id = timer_start(a:interval, a:fn)
endfunction

function! coc_document_color#request() abort
  if !CocHasProvider('documentColor')
    return
  endif

  call <SID>Delay(function('s:RequestDocumentColor'), s:DELAY_INTERVAL)
endfunction

function! s:RequestDocumentColor(...) abort
  call CocRequestAsync(
        \ 'tailwindcss-lsp',
        \ 'textDocument/documentColor',
        \ {'textDocument': v:lua.vim.lsp.util.make_text_document_params()},
        \ function('s:HandleResponse')
        \ )
endfunction

function! coc_document_color#cleanup_highlights() abort
  call nvim_buf_clear_namespace(0, s:NAMESPACE_ID, 0, -1)
endfunction

function! s:HandleResponse(error, results) abort
  if a:error
    echohl ErrorMsg
    echomsg 'An error occurred while requesting textDocument/documentColor'
    echohl None

    return
  end

  call coc_document_color#cleanup_highlights()

  let document_colors = a:results

  for document_color in document_colors
    let rgb_color = <SID>ConvertLspColorToRgb(document_color.color)

    call nvim_win_set_hl_ns(0, s:NAMESPACE_ID)

    let hl_group = printf('cocDocumentColor_%s', rgb_color)
    call nvim_set_hl(s:NAMESPACE_ID, hl_group, {
          \ 'fg': 'fg',
          \ 'bg': '#' . rgb_color,
          \ })

    let line = document_color.range.start.line
    let col_start = document_color.range.start.character
    let col_end = document_color.range.end.character

    call nvim_buf_add_highlight(0, s:NAMESPACE_ID, hl_group, line, col_start, col_end)
  endfor
endfunction

function! s:ConvertLspColorToRgb(color) abort
  let color = a:color

  let r = float2nr(color.red * 255)
  let g = float2nr(color.green * 255)
  let b = float2nr(color.blue * 255)

  return printf('%X%X%X', r, g, b)
endfunction
