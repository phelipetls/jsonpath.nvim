"{{{ plugins

" text editing conveniences
packadd! vim-surround
packadd! vim-commentary
packadd! vim-repeat
packadd! vim-unimpaired
packadd! vim-speeddating
packadd! vim-abolish
packadd! matchit
packadd! vim-lion
packadd! tagalong.vim

if !exists("g:vscode")
  " git
  packadd! vim-fugitive
  packadd! diffconflicts
  packadd! git-messenger.vim
  packadd! gv.vim

  " file navigation
  set rtp+=~/.fzf
  packadd! fzf.vim
  packadd! vim-dirvish

  " vim specific improvements
  packadd! traces.vim
  packadd! vim-obsession
  packadd! editorconfig-vim
  packadd! cfilter
  packadd! vim-slime
  packadd! vim-toml
  if has("nvim")
    packadd! nvim-colorizer.lua
  endif

  " html and javascript
  packadd! emmet-vim
  packadd! vim-jinja
  packadd! vim-javascript
  packadd! yats.vim
  packadd! vim-jsx-pretty
  packadd! vim-hugo
endif

"}}}
"{{{ general settings
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
set noshowcmd nocursorline          " don't show incomplete commands nor cursor line
set nojoinspaces                    " remove spaces when joining lines
set scrolloff=3                     " when scrolling, keep three lines ahead visible
set backspace=indent,eol,start      " better backspace behaviour
set encoding=utf-8                  " set default encoding to utf-8
set laststatus=2                    " always show statusline
set noshowmode                      " don't show mode
set tags=./tags,tags;               " look for tags file
set complete=.,b,w
set updatetime=1000                 " lower updatetime, used for CursorHold event
set breakindent                     " keep indentation when lines break
set breakindentopt=shift:2          " but shift it by 2 spaces
set linebreak                       " break only at specific characters, :h breakat

filetype plugin indent on

" default identation
set expandtab
set softtabstop=2
set shiftwidth=2

" don't autocomment on newline
autocmd! FileType * set formatoptions-=cro

" tell neovim where python3 is -- this improves startup time
if has("nvim") && has("unix")
  let g:loaded_python_provider = 0
  let g:python3_host_prog = "/usr/bin/python3"
endif

" when entering a buffer, resume to the position you were when you left it
autocmd! BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "git" |
      \   exe "normal g`\"" |
      \ endif

if !exists("g:vscode")
  set termguicolors
  colorscheme sixteen

  " disable foldcolumn in diff mode
  set diffopt+=foldcolumn:0,indent-heuristic,algorithm:patience,hiddenoff

  " visually show special characters
  set list
  set fillchars=fold:-,vert:│
  set listchars=tab:»\ ,nbsp:¬,trail:·,extends:…,precedes:‹
  set showbreak=↳\ 

  " autoresize splits when vim is resized
  autocmd! VimResized * wincmd =

  " use ripgrep as the external grep command
  if executable("rg")
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  endif

  " checktime when nvim resumes from suspended state
  if has("nvim")
    autocmd! VimResume * checktime
  endif

  autocmd! FocusGained * checktime

  " disable props highlighting
  let g:yats_host_keyword = 0

  " emmet trigger key
  let g:user_emmet_leader_key = "<C-c><C-e>"

  let g:user_emmet_settings = {
        \  'javascript' : {
        \      'extends' : 'jsx',
        \      'empty_element_suffix': ' />',
        \  }
        \}

  " integrate traces.vim with vim-subvert
  let g:traces_abolish_integration = 1

  " slime
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

  " disable editorconfig for these file patterns
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

  " enable tagalong in javascript, not only jsx
  let g:tagalong_additional_filetypes = ['javascript']

  " disable saving session on BufEnter
  let g:obsession_no_bufenter = 1

  " colorizer config
  if has("nvim") && filereadable($HOME."/.config/nvim/colorizer.lua")
    luafile $HOME/.config/nvim/colorizer.lua
  endif

  " disable colors in deno and nodejs
  let $NO_COLOR=0

  " avoid showing ansi escape sequences in nvim terminal
  " such as in lint-staged output before committing
  let g:fugitive_pty=0

  " make fugitive buffers read only. avoid mistake of writing to them
  augroup FugitiveReadOnly
    au!
    autocmd BufRead fugitive://* set readonly
  augroup END

  " format range or whole file. try to not change the jumplist
  function! Format(type, ...)
    keepjumps normal! '[v']gq
    if v:shell_error > 0
      keepjumps silent undo
      echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    endif
  endfunction

  nmap <silent> gq :set opfunc=Format<CR>g@
  nmap <silent> gQ :lua require'misc'.same_buffer_windo("let w:view = winsaveview()")<CR>
        \ :set opfunc=Format<CR>
        \ :keepjumps normal gg<CR>
        \ :keepjumps normal gqG<CR>
        \ :lua require'misc'.same_buffer_windo("keepj call winrestview(w:view)")<CR>

  let g:git_messenger_floating_win_opts = {'border': 'single'}
  let g:git_messenger_popup_content_margin = v:false
endif

"}}}
"{{{ general mappings

" use gr to go to previous tab
nnoremap gr gT

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
inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"

" cool mapping to get a list of dates
let date_formats = ["%Y-%m-%d","%Y-%m-%dT%H:%M:%S%Z"]
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(date_formats,'strftime(v:val)')),0)<CR>

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
nnoremap yd :let @+=expand("%:h")<CR>
nnoremap y<C-d> :let @+=expand("%:h")<CR>

" open a new tab mapping
nnoremap <C-w>t :tabedit %<CR>

" use ctrl-k to delete rest of line
inoremap <C-k> <C-o>D
inoremap <C-x><C-k> <C-k>

" go to local/global declaration and turn off search highlight
nnoremap <silent> gd gd:nohlsearch<CR>
nnoremap <silent> gD gD:nohlsearch<CR>
nnoremap <silent> 1gd 1gd:nohlsearch<CR>
nnoremap <silent> 1gD 1gD:nohlsearch<CR>

" convenient abbreviations
inoreabbrev Taebl Table
inoreabbrev taebl table

" do not change jump list when using }
nnoremap <silent> } :keepjumps norm! }<CR>
nnoremap <silent> { :keepjumps norm! {<CR>

" git messenger mapping
nnoremap <silent> gb :GitMessenger<CR>

" fix netrw gx being broken
if executable("xdg-open")
  nnoremap <silent> gx :call system(printf("xdg-open %s", expand("<cWORD>")))<CR>
endif

"}}}
"{{{ vscode

if exists("g:vscode")
  nnoremap <silent> <c-b> <cmd>call VSCodeCall('workbench.action.toggleSidebarVisibility')<CR>

  nnoremap <silent> K <Cmd>call VSCodeCall('editor.action.showHover')<CR>
  nnoremap <silent> [d <Cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
  nnoremap <silent> <c-w>d <cmd>call VSCodeCall('editor.action.revealDefinition')<CR>
  nnoremap <silent> [t <Cmd>call VSCodeCall('editor.action.goToTypeDefinition')<CR>
  nnoremap <silent> gR <Cmd>call VSCodeCall('editor.action.rename')<CR>
  nnoremap <silent> - <Cmd>call VSCodeCall('workbench.files.action.showActiveFileInExplorer')<CR>
  nnoremap <silent> <space>f <Cmd>call VSCodeCall('workbench.action.quickOpen')<CR>
  nnoremap <silent> <space>r <Cmd>call VSCodeCall('workbench.action.showAllEditorsByMostRecentlyUsed')<CR>
  nnoremap <silent> ]g <Cmd>call VSCodeCall('editor.action.marker.nextInFiles')<CR>
  nnoremap <silent> [g <Cmd>call VSCodeCall('editor.action.marker.prevInFiles')<CR>
  finish
endif

"}}}
"{{{ statusline and tabline

let &g:statusline=' '
let &g:statusline.='%t'
let &g:statusline.=' %{FugitiveStatusline()}'
let &g:statusline.="%{!&modifiable ? '\ua0[-]' : &modified ? '\ua0[+]' : ''}"
let &g:statusline.="%{&endofline ? '' : '\ua0[noeol]'}"
let &g:statusline.='%='
let &g:statusline.='[%l/%L]'
let &g:statusline.=' %y'

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

" ignore these files while browsing
set wildignore=venv*/,__pycache__/,.pytest_cache/,tags,htmlcov/.coverage,*.pyc

if executable("fzf")
  let g:fzf_preview_window = ''

  nnoremap <space>b :Buffers<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>h :Help<CR>
  nnoremap <space>t :Tags<CR>
  nnoremap <space>r :History<CR>
  nnoremap <space>g :Rg<CR>
endif

let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
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
      \ 'header':  ['fg', 'Comment']
      \ }

"}}}
"{{{ autocompletion config

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10

if has("nvim-0.5.0")
  luafile $HOME/.config/nvim/completion.lua
endif

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
nnoremap <silent> ]w :call ListJump("l", "after", "first")<CR>
nnoremap <silent> [w :call ListJump("l", "before", "last")<CR>

if has("nvim")
  command! -nargs=* -complete=file_in_path Make lua require'async_make'.make(<q-args>)
else
  command! -nargs=* -complete=file_in_path Make silent make!
endif

function! RunMake()
  let compiler = get(b:, "current_compiler", "")
  if index(["jest", "pytest", "pyunit"], compiler) >= 0
    make! %
    return
  endif
  Make %
endfunction

nnoremap <silent> <space>m :call RunMake()<CR>

function! OpenQuickfixList()
  botright cwindow 5
  if &buftype == "quickfix"
    wincmd p
  endif
endfunction

function! ToggleQuickfixList()
  if luaeval("require'misc'.quickfix_is_visible()")
    cclose
    return
  endif
  call OpenQuickfixList()
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

function! ToggleLocationList()
  if luaeval("require'misc'.loclist_is_visible()")
    lclose
    return
  endif
  call OpenLocationList()
endfunction

nnoremap <silent> <space>q :call ToggleQuickfixList()<CR>
nnoremap <silent> <space>w :call ToggleLocationList()<CR>

augroup QuickFix
  autocmd!
  autocmd QuickFixCmdPost * call OpenQuickfixList()
augroup END

augroup CloseQuickFix
  au!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | q |endif
augroup END

"}}}
"{{{ LSP

if has("nvim-0.5.0") && filereadable($HOME."/.config/nvim/lsp.lua") && !&diff
  packadd! nvim-lsp

  luafile $HOME/.config/nvim/lsp.lua

  sign define LspDiagnosticsSignError text=▎ texthl=LspDiagnosticsSignError linehl= numhl=
  sign define LspDiagnosticsSignWarning text=▎ linehl= texthl=LspDiagnosticsSignWarning linehl= numhl=
  sign define LspDiagnosticsSignInformation text=▎ texthl=LspDiagnosticsSignInformation linehl= numhl=
  sign define LspDiagnosticsSignHint text=▎ texthl=LspDiagnosticsSignHint linehl= numhl=
endif

"}}}
"{{{ treesitter

" if has("nvim-0.5.0") && filereadable($HOME."/.config/nvim/treesitter.lua")
"   luafile $HOME/.config/nvim/treesitter.lua
" endif

"}}}
"{{{ text objects

" number text object (integer and float)
" --------------------------------------
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap <silent> in :<C-u>call VisualNumber()<CR>
onoremap <silent> in :<C-u>normal vin<CR>

" square brackets text objects
" ----------------------------
xnoremap <silent> ir i[
xnoremap <silent> ar a[
onoremap <silent> ir :normal vi[<CR>
onoremap <silent> ar :normal va[<CR>

for char in ['_', '-', '/', '*']
  execute 'xnoremap <silent> i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap <silent> i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap <silent> a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap <silent> a' . char . ' :normal va' . char . '<CR>'
endfor

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
" vim: foldmethod=marker
