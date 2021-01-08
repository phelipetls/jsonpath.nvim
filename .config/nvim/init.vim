"{{{ plugins

" text editing conveniences
packadd! splitjoin.vim
packadd! vim-fugitive
packadd! vim-surround
packadd! vim-commentary
packadd! vim-repeat
packadd! vim-unimpaired
packadd! vim-speeddating
packadd! vim-abolish
packadd! vim-toml
packadd! matchit
packadd! vim-lion

if exists("g:vscode")
  nnoremap <silent> K <Cmd>call VSCodeCall('editor.action.showHover')<CR>
  nnoremap <silent> gh <Cmd>call VSCodeCall('editor.action.showHover')<CR>
  nnoremap <silent> [d <Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
  nnoremap <silent> [<C-d> <Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
  nnoremap <silent> gd <Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
  nnoremap <silent> [t <Cmd>call VSCodeCall('editor.action.goToTypeDefinition')<CR>
  nnoremap <silent> gr <Cmd>call VSCodeCall('references-view.find')<CR>
  nnoremap <silent> gs <Cmd>call VSCodeCall('workbench.action.gotoSymbol')<CR>
  nnoremap <silent> <c-w>d <cmd>call VSCodeCall('editor.action.revealDefinitionAside')<CR>
  nnoremap <silent> <c-b> <cmd>call VSCodeCall('workbench.action.toggleSidebarVisibility')<CR>
  nnoremap <silent> - <Cmd>call VSCodeCall('workbench.files.action.showActiveFileInExplorer')<CR>
  nnoremap <silent> <space>r <Cmd>call VSCodeCall('workbench.action.showAllEditorsByMostRecentlyUsed')<CR>
  finish
endif

" file navigation
set rtp+=~/.fzf
packadd! vim-dirvish
packadd! fzf.vim

" vim specific improvements
packadd! traces.vim
packadd! vim-obsession
packadd! editorconfig-vim
packadd! completion-nvim
packadd! gv.vim
packadd! cfilter

" html and javascript
packadd! emmet-vim
packadd! tagalong.vim
packadd! vim-jinja
packadd! vim-javascript
packadd! vim-jsx-pretty
packadd! vim-hugo

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
set lazyredraw
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
set tags=./tags,tags;               " look for tags file
set complete-=t                     " when completing, don't search tags
set complete-=i                     " neither in included files
set updatetime=1000                 " lower updatetime, used for CursorHold event
set breakindent                     " keep indentation when lines break
set breakindentopt=shift:2          " but shift it by 2 spaces
set linebreak                       " break only at specific characters, :h breakat

if has("nvim-0.4.3")
  set wildoptions=tagfile " keep the horizontal wildmenu in neovim
endif

filetype plugin indent on

" visually show special characters
set list
set fillchars=fold:-
set listchars=tab:»\ ,nbsp:¬,trail:·,extends:…,precedes:‹
set showbreak=↳\ 

" default identation
set expandtab
set softtabstop=2
set shiftwidth=2

" disable foldcolumn in diff mode
set diffopt+=foldcolumn:0

" don't autocomment on newline
autocmd! FileType * set formatoptions-=cro

" autoresize splits when vim is resized or entering tab
autocmd! VimResized * wincmd =
autocmd! TabEnter * wincmd =

" tell neovim where python3 is -- this improves startup time
if has("nvim") && has("unix")
  let g:loaded_python_provider = 0
  let g:python3_host_prog = "/usr/bin/python3"
endif

" when entering a buffer, resume to the position you were when you left it
autocmd! BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "commit" |
      \   exe "normal g`\"" |
      \ endif

" use ripgrep as the external grep command
if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" checktime when nvim resumes from suspended state
if has("nvim")
  autocmd! VimResume * checktime
endif

" disable props highlighting
let g:yats_host_keyword = 0

"}}}
"{{{ general mappings

" improve esc in terminal
tnoremap <Esc> <C-\><C-n>

" escape also cancels search highlight
nnoremap <silent> <esc> :nohlsearch<cr><esc>

" go to vimrc file
nnoremap <silent> <space>ev :edit $MYVIMRC<cr>

" source current file, only if it is .vim file
nnoremap <silent><expr> <space>ss (&ft == "vim" ? ":source %<cr>" : "")

" make <c-u> and <c-w> undoable
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" vertical movement
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Y consistent with C, D etc.
nnoremap Y y$

" ' is more convenient to jump to the exact location of a mark
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

" handle annoying command line typos
command! -bang -complete=file_in_path E e<bang>
command! -bang -complete=file_in_path W w<bang>
command! -bang Q q<bang>
command! -bang Qall qall<bang>

" mapping to change the word under the cursor. use . to repeat
nnoremap <silent> <c-n> *Ncgn

" show information about highlight group under cursor
command! Hi exe 'hi '.synIDattr(synID(line("."), col("."), 0), "name")

" format range or whole file. try to not change the jumplist
function! Format(type, ...)
  keepjumps normal! '[v']gq
  if v:shell_error > 0
    keepjumps silent undo
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
endfunction

nmap <silent> gq :set opfunc=Format<CR>g@
nmap <silent> gQ :lua require'utils'.same_buffer_windo("let w:view = winsaveview()")<CR>
      \ :set opfunc=Format<CR>
      \ :keepjumps normal gg<CR>
      \ :keepjumps normal gqG<CR>
      \ :lua require'utils'.same_buffer_windo("keepj call winrestview(w:view)")<CR>

" highlight yanked region
if has("nvim-0.5.0")
  augroup highlight_yank
      autocmd!
      autocmd TextYankPost * silent!
            \ au TextYankPost * silent!
            \ lua vim.highlight.on_yank {higroup="Search", on_visual=false}
  augroup END
endif

" format paragraph
nnoremap <M-q> gwip
inoremap <M-q> <C-o>gwip

" put the current file name under the f register
autocmd! BufEnter * let @f=expand("%:t:r")

" function used for abbreviations
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction

" vim-rsi mappings that I use
inoremap <C-A> <Home>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

" cool mapping to get a list of dates
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d","%Y-%m-%d %H:%M:%S"],'strftime(v:val)')),0)<CR>

" <space> does not move cursor in normal mode
nnoremap <space> <nop>

" when using ^R^L in command-line mode, strip out leading whitespace
cnoremap <C-R><C-L> <C-R>=substitute(getline('.'), '^\s*', '', '')<CR>

" use <Tab> as an operator for matchit
omap <Tab> %
xmap <Tab> %

" put file name in clipboard
nnoremap yp :let @+=expand("%:p")<CR>
nnoremap y<C-p> :let @+=expand("%:p")<CR>

" put file directory name in clipboard
nnoremap y. :let @+=expand("%:h")<CR>
nnoremap yh :let @+=expand("%:h")<CR>

command! DiffOrig vert new | set buftype=nofile |
      \ read ++edit # |
      \ 0d_ |
      \ diffthis |
      \ wincmd p |
      \ diffthis

inoreabbrev Taebl Table
inoreabbrev taebl table

"}}}
"{{{ statusline and tabline

function! GitHead() abort
  if exists("*FugitiveHead")
    let l:head = FugitiveHead()
    if len(l:head) > 0
      return printf("[%s]", l:head)
  endif
  return ""
endfunction

let &g:statusline='[%n]'                         " buffer number
let &g:statusline.=' %0.30f'                     " abbreviated file name
let &g:statusline.=' %{GitHead()}'               " branch of current HEAD commit
let &g:statusline.=' %m'                         " modified
let &g:statusline.=' %i'                         " no end of line
let &g:statusline.=' %='                         " jump to other side
let &g:statusline.=' [%l/%L]'                    " current line number / total lines
let &g:statusline.=' %y'                         " filetype

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
nnoremap <space>f :find<space>

"{{{2 fzf

if executable("fzf")
  let g:fzf_preview_window = ''

  nnoremap <space>b :Buffers<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>h :Help<CR>
  nnoremap <space>t :Tags<CR>
  nnoremap <space>r :History<CR>
  nnoremap <space>g :Rg<CR>
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

"}}} fzf
"{{{2 netrw

let g:netrw_special_syntax = 1  " highlight special files in netrw
let g:netrw_sizestyle = "H"  " human-readable file size
let g:netrw_timefmt = "%b %d %R" " preferred datetime format
let g:netrw_use_errorwindow = 0 " don't open a separate window to show errors

" don't go to netrw buffer on ctrl-6
let g:netrw_altfile = 1

" delete hidden netrw buffers
" see https://github.com/tpope/vim-vinegar/issues/13
let g:netrw_fastbrowse = 0

" avoid netrw refresh command conflicting with <c-l> mapping
nnoremap <a-L> <Plug>NetrwRefresh

" ignore these files while browsing
set wildignore=venv*/,__pycache__/,.pytest_cache/,tags,htmlcov/.coverage,*.pyc

" wipe netrw buffers when closed
augroup Netrw
  autocmd!
  au FileType netrw setlocal bufhidden=wipe
augroup END

"}}}2

"}}}
"{{{ autocompletion config

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10

imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)
imap <silent> <C-Space> <Plug>(completion_trigger)

autocmd BufEnter * lua require'completion'.on_attach()

let g:completion_enable_auto_hover = 0
let g:completion_trigger_keyword_length = 3
let g:completion_chain_complete_list = {
    \ 'default' : {
    \   'default': [
    \       {'complete_items': ['lsp']},
    \       {'complete_items': ['path'], 'triggered_only': ['/']},
    \       {'mode': '<c-p>'},
    \       {'mode': '<c-n>'}
    \     ]
    \   }
    \}

augroup CompletionTriggerCharacter
  autocmd!
  autocmd BufEnter *.ts,*.js,*.tsx,*.jsx let g:completion_trigger_character = ['.']
augroup end

"}}}
"{{{ quickfix config

function! ListJump(list_type, direction, wrap)
  try
    exe a:list_type . a:direction
  catch /E553/ " wrap around last item
    exe a:list_type . a:wrap
  catch /E42/
    return
  catch /E163/
    return
  endtry
  normal! zz
endfunction

" wrap around when navigating the quickfix list
nnoremap <silent> ]q :call ListJump("c", "next", "first")<CR>
nnoremap <silent> [q :call ListJump("c", "previous", "last")<CR>
nnoremap <silent> ]w :call ListJump("l", "next", "first")<CR>
nnoremap <silent> [w :call ListJump("l", "previous", "last")<CR>

if has("nvim")
  command! -nargs=* -complete=file_in_path Make lua require'async_make'.make(<q-args>)
else
  command! -nargs=* -complete=file_in_path Make silent make!
endif

nnoremap <silent> <space>q :pclose<CR>:cclose<cr>:lclose<cr>
nnoremap <silent> <space>m :Make %<CR>
nnoremap <silent> <space><space>m :make! %<CR>

function! OpenQuickfixList()
  botright cwindow 5
  if &buftype == "quickfix"
    wincmd p
  endif
endfunction

function! OpenLocationList()
  try
    botright lwindow 5
  catch /E776/
  endtry
  if &buftype == "quickfix"
    wincmd p
  endif
endfunction

nnoremap <silent><space>q :call OpenQuickfixList()<CR>
nnoremap <silent><space>l :call OpenLocationList()<CR>

augroup QuickFix
  autocmd!
  autocmd QuickFixCmdPost * call OpenQuickfixList()
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

if has("nvim-0.5.0") && filereadable(stdpath("config")."/lsp.lua") && !&diff
  packadd! nvim-lsp

  luafile /home/phelipe/.config/nvim/lsp.lua

  sign define LspDiagnosticsSignError text=❚ texthl=LspDiagnosticsSignError linehl= numhl=
  sign define LspDiagnosticsSignWarning text=❚ linehl= texthl=LspDiagnosticsSignWarning linehl= numhl=
  sign define LspDiagnosticsSignInformation text=❚ texthl=LspDiagnosticsSignInformation linehl= numhl=
  sign define LspDiagnosticsSignHint text=❚ texthl=LspDiagnosticsSignHint linehl= numhl=

  command! LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())
endif

"}}}
"{{{ treesitter

if has("nvim-0.5.0")
  luafile /home/phelipe/.config/nvim/treesitter.lua
endif

"}}}
"{{{ text objects

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

"}}}
"{{{ close tag

function! CloseTag()
  let b:old_omnifunc = &l:omnifunc
  set omnifunc=htmlcomplete#CompleteTags
  return "\<C-x>\<C-o>\<C-n>\<C-y>"
endfunction

function! Reindent()
  if (len(&indentexpr) || &cindent)
    return "\<C-F>"
  endif
  return ""
endfunction

function! Clean()
  let &l:omnifunc = b:old_omnifunc
  return ""
endfunction

inoremap <silent> <C-X>/ <Lt>/<C-r>=CloseTag()<CR><C-r>=Reindent()<CR><C-r>=Clean()<CR>

"}}}
