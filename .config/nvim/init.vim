"{{{ plugins

call plug#begin()

" appearance
Plug 'phelipetls/wal.vim'

" file navigation
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'

" autocompletion
Plug 'phelipetls/vim-simple-complete'

" git wrapper
Plug 'tpope/vim-fugitive'

" conveniences
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'tommcdo/vim-lion'
Plug 'markonm/traces.vim'
Plug 'AndrewRadev/inline_edit.vim'

" html and javascript
Plug 'mattn/emmet-vim'
Plug 'AndrewRadev/tagalong.vim'
Plug 'mitsuhiko/vim-jinja'
Plug 'tpope/vim-ragtag'
Plug 'pangloss/vim-javascript'

" LSP
Plug 'neovim/nvim-lsp'

" REPL
Plug 'jpalardy/vim-slime'

call plug#end()

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
set tags=.git/tags,tags             " look for tags file in these directories
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
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" use cfilter package
packadd cfilter

" use matchit package
packadd matchit

" emmet trigger key
let g:user_emmet_leader_key = "<C-c><C-e>"

" inline-edit config
let g:inline_edit_autowrite = 1

"}}}
"{{{ general mappings

let maplocalleader = "\<space>"

" copy absolute path to clipboard
nnoremap y<C-p> :let @+=expand("%:p")<CR>

" escape also cancels search highlight
nnoremap <silent> <esc> :nohlsearch<cr><esc>

" go to vimrc file
nnoremap <silent> <space>ev :edit $MYVIMRC<cr>

" source current file, only if it is .vim file
nnoremap <expr> <space>ss (&ft == "vim" ? ":source %<cr>" : "")

" vertical movement
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

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

" disable arrow keys
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>

" re-select region when indenting
vnoremap <silent> > >gv
vnoremap <silent> < <gv

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

nnoremap <silent> <C-c>' :InlineEdit<CR>

"}}}
"{{{ statusline and tabline

function! GitHead() abort
  let l:head = FugitiveHead()
  if len(l:head) > 0
    return printf("[%s]", l:head)
  else
    return ""
  endif
endfunction

let &g:statusline=' %n:'                      " buffer number
let &g:statusline.=' %t'                      " abbreviated file name
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

" FZF {{{
if executable("fzf")
  let $FZF_DEFAULT_COMMAND = 'rg --files --color=never --glob "!.git/*"'
  let g:fzf_preview_window = ''

  nmap <space>b :Buffers<CR>
  nmap <space>f :Files<CR>
  nmap <space>g :GFiles<CR>
  nmap <space>h :Help<CR>
  nmap <space>t :Tags<CR>
  nmap <space>r :History<CR>
  nmap <space>bc :BCommits<CR>
  nmap <space>cc :Commits<CR>
endif
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

function! CtrlSpace()
  let l:line_until_cursor = strpart(getline('.'), 0, col('.')-1)
  " complete if line until cursor is something like this:
  " 'a bunch of stuff ../path/to/file'
  " but not if like this:
  " '<tag>content</'
  if l:line_until_cursor =~ ".*\\(<\\)\\@1<!\/\\f*$"
    return "\<C-x>\<C-f>"
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

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

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
nnoremap <silent> ]l :call ListJump("l", "next", "first")<CR>
nnoremap <silent> [l :call ListJump("l", "previous", "last")<CR>

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

" line text objects
" -----------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" number text object (integer and float)
" --------------------------------------
" in
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" square brackets text objects
" ----------------------------
" ir ar
xnoremap ir i[
xnoremap ar a[
onoremap ir :normal vi[<CR>
onoremap ar :normal va[<CR>

"}}}
