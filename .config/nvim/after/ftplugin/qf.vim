setlocal nowrap

setlocal statusline=%q\ %{get(w:,'quickfix_title','')}\ %=[%l/%L]

" function to resize quickfix window given a min and max height
function! ResizeQf(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

call ResizeQf(1, 5)
