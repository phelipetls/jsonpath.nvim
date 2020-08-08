"{{{ plugins

" file navigation
set rtp+=~/.fzf
packadd! fzf.vim
packadd! vim-vinegar

" conveniences
packadd! splitjoin.vim
packadd! vim-simple-complete
packadd! vim-fugitive
packadd! vim-surround
packadd! vim-commentary
packadd! vim-repeat
packadd! vim-unimpaired
packadd! vim-speeddating
packadd! vim-eunuch
packadd! vim-abolish
packadd! vim-rsi
packadd! vim-lion
packadd! traces.vim
packadd! inline_edit.vim
packadd! vim-toml
packadd! cfilter
packadd! matchit

" databases
packadd! vim-dadbod

" html and javascript
packadd! emmet-vim
packadd! vim-jinja
packadd! vim-ragtag
packadd! vim-javascript
packadd! vim-jsx-pretty
packadd! vim-hugo

" snippets
packadd! aergia

" LSP
packadd! nvim-lsp

" REPL
packadd! vim-slime

"}}}
"{{{ general settings

syntax on
colorscheme sixteen

set nonumber
set hidden
set wildmenu
set wildmode=full
set wildcharm=<Tab>
set mouse=nv                        " allow mouse in normal and visual mode
set clipboard+=unnamedplus          " always use system clipboard
set splitbelow splitright           " always split window to the right and below
set ignorecase smartcase            " ignore case, except when there is an upper case
set noswapfile                      " i don't want swap files...
set noshowcmd nocursorline          " don't show incomplete commands nor cursor line
set nojoinspaces                    " remove spaces when joining lines
set scrolloff=3                     " when scrolling, keep three lines ahead visible
set backspace=indent,eol,start      " better backspace behaviour
set encoding=utf-8                  " set default encoding to utf-8
set foldmethod=marker
set laststatus=2                    " always show statusline
set noshowmode                      " don't show mode
set tags=./tags,tags;                       " look for tags file in these directories
set complete-=t                     " when completing, don't search tags
set complete-=i                     " neither in included files
set updatetime=1000                 " lower updatetime, used for CursorHold event
set breakindent                     " keep indentation when lines break
set breakindentopt=shift:2          " but shift it by 2 spaces
set linebreak                       " break only at specific characters, :h breakat

if has('nvim-0.4.3')
  set wildoptions=tagfile " keep the horizontal wildmenu in neovim
endif

filetype plugin indent on

" visually show special characters
set list
set fillchars=fold:-
set listchars=tab:»\ ,nbsp:¬,trail:·,extends:›,precedes:‹
set showbreak=↳\ 

" default identation
set expandtab
set softtabstop=2
set shiftwidth=2

" don't autocomment on newline
autocmd! FileType * set formatoptions-=c formatoptions-=r formatoptions-=o

" autoresize splits when vim is resized or entering tab
autocmd! VimResized * wincmd =
autocmd! TabEnter * wincmd =

" tell neovim where python3 is -- this improves startup time
let g:python_host_prog = "/usr/bin/python"
let g:loaded_python_provider = 0
let g:python3_host_prog = "/usr/bin/python3"

" when entering a buffer, resume to the position you were when you left it
autocmd! BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" use ripgrep as the external grep command
if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" emmet trigger key
let g:user_emmet_leader_key = "<C-c><C-e>"

let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\  'html': {
\      'empty_element_suffix': ' />',
\  },
\}

" inline-edit config
let g:inline_edit_autowrite = 1

" aergia
" let g:aergia_snippets = expand("%:p:h")."/snippets"
let g:aergia_snippets = "~/.config/nvim/snippets"
let g:aergia_key = "<c-j>"

inoremap <c-x><c-a> <c-r>=aergia#completion#AergiaComplete()<cr>

set diffopt+=algorithm:patience

"}}}
"{{{ general mappings

let maplocalleader = "\<space>"

tnoremap <Esc> <C-\><C-n>

" copy absolute path to clipboard
nnoremap y<C-p> :let @+=expand("%:p")<CR>

" escape also cancels search highlight
nnoremap <silent> <esc> :nohlsearch<cr><esc>

" go to vimrc file
nnoremap <silent> <space>ev :edit $MYVIMRC<cr>

" source current file, only if it is .vim file
nnoremap <expr> <space>ss (&ft == "vim" ? ":source %<cr>" : "")

" make <c-u> and <c-w> undoable
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" vertical movement
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" autoclose braces
fun! AutoCloseBraces()
  inoremap <buffer> {<CR> {<CR>}<C-o>O
endfun

augroup AutoClosePairs
  au!
  autocmd FileType javascript,scss,css call AutoCloseBraces()
augroup END

" Y consistent with C, D etc.
nnoremap Y y$

" ' is more convenient to jump to a mark exact location
nnoremap ' `

" better maps to move between splits
nnoremap <silent> <c-w><c-q> :close<cr>
nnoremap <silent> <c-j> <c-w><c-j>
nnoremap <silent> <c-k> <c-w><c-k>
nnoremap <silent> <c-l> <c-w><c-l>
nnoremap <silent> <c-h> <c-w><c-h>

" resize splits with arrow keys
nnoremap <silent> <c-left>  <c-w>>
nnoremap <silent> <c-right> <c-w><
nnoremap <silent> <c-down>  <c-w>-
nnoremap <silent> <c-up>    <c-w>+

" re-select region when indenting
vnoremap <silent> > >gv
vnoremap <silent> < <gv

" select last yanked text
nnoremap <silent> gy `[v`]

" disable key to Ex mode and command-line window (press c_CTRL-F instead)
nnoremap Q <nop>
nnoremap q: <nop>

" annoying command line typos
command! E e
command! Q q
command! W w
command! Qall qall

" mapping to rename the word under the cursor
nnoremap <silent> <c-n> *Ncgn

" show information about highlight group under cursor
command! Hi exe 'hi '.synIDattr(synID(line("."), col("."), 0), "name")

" see https://gist.github.com/romainl/d2ad868afd7520519057475bd8e9db0c
" gq wrapper that:
" - tries its best at keeping the cursor in place
" - tries to handle formatter errors
function! Format(type, ...)
  normal! '[v']gq
  if v:shell_error > 0
    silent undo
    redraw
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
  call winrestview(w:gqview)
  unlet w:gqview
endfunction

nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@
nnoremap <silent> gQ :normal magggqG`a<CR>

" paste linewise without moving cursor
function! DoWithoutMoving(command)
  let w:gpview = winsaveview()
  execute "normal ".a:command
  call winrestview(w:gpview)
endfunction

nnoremap <silent> gP :call DoWithoutMoving("]P")<CR>
nnoremap <silent> gp :call DoWithoutMoving("]p")<CR>

" inline-edit plugin remapping
nnoremap <silent> <C-c>' :InlineEdit<CR>

" highlight yanked region
if has("nvim-0.5.0")
  augroup highlight_yank
      autocmd!
      autocmd TextYankPost * silent!
            \ au TextYankPost * silent!
            \ lua vim.highlight.on_yank {higroup="Search", on_visual=false}
  augroup END
endif

"}}}
"{{{ statusline and tabline

function! GitHead() abort
  if exists("*FugitiveHead")
    let l:head = FugitiveHead()
    if len(l:head) > 0
      return printf("[%s]", l:head)
  else
    return ""
  endif
endfunction

let &g:statusline=' %n:'                      " buffer number
let &g:statusline.=' %0.30f'                  " abbreviated file name
let &g:statusline.=' %{GitHead()}'            " branch of current HEAD commit
let &g:statusline.=' %m'                      " modified
let &g:statusline.=' %='                      " jump to other side
let &g:statusline.=' [%l/%L]'                 " current line number / total lines
let &g:statusline.=' %y'                      " filetype

function! Tabline()
  let s = ''
  for tab in range(1, tabpagenr('$'))
    " Get tab infos
    let winnr = tabpagewinnr(tab)
    " Get buf infos
    let buflist = tabpagebuflist(tab)
    let bufspnr = buflist[winnr - 1]
    let bufname = bufname(bufspnr)
    " Set tab state
    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    " Set tab label
    let s .= ' ' . tab . ' '
    let s .= (bufname != '' ? fnamemodify(bufname, ':t') : '[No Name]') . ' '
  endfor
  " Finalize tabline
  let s .= '%#TabLineFill#' | return s
endfunction

set tabline=%!Tabline()

""}}}
"{{{ file navigation

set path=.,,..

augroup ExpressPath
  au!
  au Filetype javascript,html set path+=src,static,views,routes,public
augroup END

nnoremap <space>f :find<space>

" FZF {{{

if executable("fzf")
  let $FZF_DEFAULT_COMMAND = 'rg --files --color=never --glob "!.git/*"'
  let g:fzf_preview_window = ''

  nnoremap <space>b :Buffers<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>h :Help<CR>
  nnoremap <space>t :Tags<CR>
  nnoremap <space>r :History<CR>
endif

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"}}}
" Netrw {{{2

let g:netrw_special_syntax = 1  " highlight special files in netrw
let g:netrw_sizestyle = "H"  " human-readable file size
let g:netrw_timefmt = "%b %d %R" " preferred datetime format

" don't go to netrw buffer on ctrl-6
let g:netrw_altfile = 1

" delete hidden netrw buffers
" see https://github.com/tpope/vim-vinegar/issues/13
let g:netrw_fastbrowse = 0

" avoid netrw refresh command conflicting with <c-l> mapping
nnoremap <a-L> <Plug>NetrwRefresh

" ignore these files while browsing
" python
set wildignore=venv*/,__pycache__/,.pytest_cache/,tags,htmlcov/.coverage

" wipe netrw buffers when closed
augroup Netrw
  autocmd!
  au FileType netrw setlocal bufhidden=wipe
augroup END

""}}}

"}}}
"{{{ autocompletion config

function! LocalFileCompletion()
    lcd %:p:h
    return "\<C-x>\<C-f>"
endfunction

function! CtrlSpace()
  let l:line_until_cursor = strpart(getline('.'), 0, col('.')-1)
  " complete if line until cursor is something like this:
  " 'a bunch of stuff ../path/to/file'
  " but not if like this:
  " '<tag>content</'
  if l:line_until_cursor =~ ".*\\(<\\)\\@1<!\/\\f*$"
    return LocalFileCompletion()
  " else, call omnicompletion if omnifunc exists
  elseif len(&omnifunc) > 0
    return "\<C-x>\<C-o>"
  else
    return "\<C-n>"
  endif
endfunction

function! SmartTab()
  let l:lastchar = matchstr(getline('.'), '.\%' . col('.') . 'c')
  if pumvisible()
    return "\<C-n>"
  elseif l:lastchar =~ "\\s" || len(l:lastchar) == 0
    return "\<Tab>"
  else
    return CtrlSpace()
  endif
endfunction

inoremap <silent> <Tab> <C-R>=SmartTab()<CR>
inoremap <silent> <C-Space> <C-R>=CtrlSpace()<CR>
inoremap <silent> <C-x><C-f> <C-R>=LocalFileCompletion()<CR>

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

autocmd! CompleteDonePre *
      \ if complete_info(["mode"]).mode == "files" |
      \   lcd - |
      \ endif

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10

"}}}
"{{{ quickfix config

function! ListJump(list_type, direction, wrap)
  try
    exe a:list_type . a:direction
  catch /E553/ " wrap around last item
    exe a:list_type . a:wrap
  catch /E163,E42/
    return
  endtry
  normal! zz
endfunction

" wrap around when navigating the quickfix list
nnoremap <silent> ]q :call ListJump("c", "next", "first")<CR>
nnoremap <silent> [q :call ListJump("c", "previous", "last")<CR>
nnoremap <silent> ]l :call ListJump("l", "below", "first")<CR>
nnoremap <silent> [l :call ListJump("l", "above", "last")<CR>

command! Make silent make! | redraw!

" function to resize quickfix window given a min and max height
function! ResizeQf(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! OpenLocationList()
  try
    lwindow
  catch /E776/
    return
  endtry
  if &ft == "qf"
    wincmd p
  endif
endfunction

nnoremap <silent> <space>o :cwindow<CR>
nnoremap <silent> <space>l :call OpenLocationList()<CR>
nnoremap <silent> <space>q :pclose<CR>:cclose<cr>:lclose<cr>
nnoremap <silent> <space>m :Make<CR>

augroup QuickFixSettings
  autocmd!
  au QuickFixCmdPost * cwindow
  au QuickFixCmdPost * execute &ft == "qf" ? "wincmd p" : ""
  au FileType qf wincmd J
  au FileType qf setlocal nowrap
  au FileType qf call ResizeQf(1, 5) " min, max
  au FileType qf au BufEnter <buffer> nested if winnr("$") == 1 | quit | endif
augroup END

"}}}
"{{{ vim-slime


if exists("$TMUX")
  let g:slime_target = "tmux"
  let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
  let g:slime_dont_ask_default = 1
elseif has("unix")
  let g:slime_target = "x11"
else
  let g:slime_target = "neovim"
endif

nnoremap <silent> <C-c><C-c> <Plug>SLimeRegionSend
nnoremap <silent> <C-c><C-w> :exe ":SlimeSend1 " . expand('<cword>')<CR>
nnoremap <silent> <C-c>% :%SlimeSend<CR>
nnoremap <silent> <C-c><C-a> :%SlimeSend<CR>
nnoremap <silent> <C-c><C-l> :exe ":silent !tmux send-keys -t " . b:slime_config['target_pane'] . " '^L'"<CR>
nnoremap <silent> <C-c><C-s> :exe ":silent !tmux send-keys -t " . b:slime_config['target_pane'] . " 'plt.show()' Enter"<CR>

"}}}
"{{{ LSP

if has("nvim-0.5.0") && filereadable("/home/phelipe/.config/nvim/lsp.lua")
  luafile /home/phelipe/.config/nvim/lsp.lua
endif

"}}}
"{{{ text objects

" 24 simple text objects
" ----------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" line text objects
" -----------------
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" number text object (integer and float)
" --------------------------------------
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" square brackets text objects
" ----------------------------
xnoremap ir i[
xnoremap ar a[
onoremap ir :normal vi[<CR>
onoremap ar :normal va[<CR>

" last yanked text object
" -----------------------
xnoremap iy `]o`[
onoremap iy :<C-u>normal vik<CR>
onoremap ay :<C-u>normal vikV<CR>

"}}}
