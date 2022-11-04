"{{{ encoding

set encoding=utf-8
scriptencoding utf-8

"}}}
"{{{ plugins

" text editing conveniences
packadd! vim-surround
packadd! vim-commentary
packadd! vim-repeat
packadd! vim-unimpaired
packadd! vim-speeddating
packadd! vim-abolish
packadd! vim-eunuch
packadd! matchit
packadd! vim-lion
packadd! splitjoin.vim
packadd! vim-sleuth
packadd! inline_edit.vim

" git
packadd! vim-fugitive
packadd! fugitive-gitlab.vim
packadd! vim-rhubarb
packadd! vim-fugitive-blame-ext

" file navigation
packadd! vim-dirvish

" fuzzy finder
set runtimepath+=~/.fzf
packadd! fzf.vim

" vim specific improvements
packadd! traces.vim
packadd! vim-obsession
packadd! editorconfig-vim
packadd! cfilter
packadd! vim-slime
packadd! LargeFile
packadd! coc.nvim
packadd! vim-jqplay
if has('nvim')
  packadd! plenary.nvim
  packadd! jsonpath.nvim
endif

" web development
packadd! vim-hugo

" aesthetics
if has('nvim')
  packadd! lualine.nvim
  packadd! nvim-colorizer.lua
endif

"}}}
"{{{ settings

set termguicolors
if has('nvim-0.7.0')
  let g:moonflyWinSeparator = 2
  colorscheme moonfly
else
  colorscheme evening
endif

filetype plugin indent on

set nonumber
set noruler
set hidden
set wildmenu
set wildmode=full
set wildcharm=<Tab>
set lazyredraw
set mouse=nv
set clipboard+=unnamedplus
set splitbelow splitright
set ignorecase smartcase
set noshowcmd nocursorline
set nojoinspaces
set scrolloff=3
set backspace=indent,eol,start
set laststatus=2
set noshowmode
set updatetime=1000
set breakindent
set breakindentopt=shift:2
set linebreak
set showtabline=2

" tell neovim where python3 is -- this improves startup time
if has('nvim') && has('unix')
  let g:loaded_python_provider = 0
  let g:python3_host_prog = '/usr/bin/python3'
endif

set diffopt+=foldcolumn:0,hiddenoff

if has('nvim')
  set diffopt+=indent-heuristic,internal,algorithm:patience
endif

" visually show special characters
set list
set fillchars=fold:-,vert:│,stlnc:-
if has('nvim')
  set fillchars=horiz:━,horizup:┻,horizdown:┳,vert:┃,vertleft:┨,vertright:┣,verthoriz:╋
endif
set listchars=tab:»\ ,nbsp:¬,trail:·,extends:…,precedes:‹
set showbreak=↳\ 

" use ripgrep as the external grep command
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

if has('nvim')
lua << EOF
  function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
  end
EOF
endif

" persist workspace folders
" see https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders#persist-workspace-folders
set sessionoptions+=globals

if has('wsl')
  let g:clipboard = {
        \   'name': 'Windows',
        \   'copy': {
        \     '+': 'clip.exe',
        \     '*': 'clip.exe',
        \   },
        \   'paste': {
        \     '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \     '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \   },
        \ }
endif

"}}}
"{{{ plugins config

" integrate traces.vim with vim-abolish
let g:traces_abolish_integration = 1

" vim-slime configuration
if exists('$TMUX')
  let g:slime_target = 'tmux'
  let g:slime_default_config = {'socket_name': 'default', 'target_pane': '{last}'}
  let g:slime_dont_ask_default = 1
  let g:slime_bracketed_paste = 1
elseif has('unix') && !exists('$WAYLAND_DISPLAY')
  let g:slime_target = 'x11'
else
  let g:slime_target = 'neovim'
endif

nnoremap <silent> <C-c><C-c> <Plug>SlimeRegionSend
nnoremap <silent> <C-c><C-w> :execute ":SlimeSend1 " . expand('<cword>')<CR>
nnoremap <silent> <C-c>% :%SlimeSend<CR>
nnoremap <silent> <C-c><C-l> :execute ":silent !tmux send-keys -t " . b:slime_config['target_pane'] . " '^L'"<CR>

" disable editorconfig for these file patterns
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" disable saving session on BufEnter
let g:obsession_no_bufenter = 1

" disable colors in deno and nodejs terminal output
let $NO_COLOR=0

" avoid showing ansi escape sequences in nvim terminal
" such as in lint-staged output before committing
let g:fugitive_pty=0

" remove -F flag I use in my .profile, that would automatically close terminal
" window if output in less is too short
let $LESS='RX'

" inline_edit.vim
nnoremap <C-c>' :InlineEdit<CR>
let g:inline_edit_autowrite=1

" colorizer
if has('nvim')
lua << EOF
require("colorizer").setup({
  filetypes = {
    javascript = { names = false },
    typescript = { names = false },
    typescriptreact = { names = false },
    javascriptreact = { names = false },
    css = { names = false },
    html = { names = false },
    vim = { names = false },
    json = { names = false },
  },
  rgb_fn = true,
  tailwind = true,
})
EOF
endif

" dirvish
" show directories first
let g:dirvish_mode = ':sort ,^.*[\/],'

" open jqplay buffers in vertical splits
let g:jqplay = {
    \ 'mods': 'vertical'
    \ }

"}}}
"{{{ autocommands

augroup GlobalAutocmds
  autocmd!
  " don't autocomment on newline
  autocmd FileType * set formatoptions-=cro

  " after reading a buffer, jump to last position before exiting it
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "git" |
        \   execute "normal g`\"" |
        \ endif

  " autoresize splits when vim is resized
  autocmd VimResized * wincmd =

  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,sh,yaml,vim,lua,json,html,css set expandtab shiftwidth=2 softtabstop=2
  autocmd FileType python set expandtab shiftwidth=4 softtabstop=4

  " put the current file name under the f register
  autocmd BufEnter * let @f=expand("%:t:r")

  " allows me to preview a commit when rebasing with K
  autocmd FileType gitrebase setlocal keywordprg=:Git!\ show

  " create intermediate directories if necessary before saving file
  autocmd BufWritePre * call utils#create_dir_on_save(expand("<afile>"))
augroup END

if has('nvim')
  " VimResume is Neovim-only
  augroup GlobalNeovimOnlyAutocmds
    autocmd!
    " autoupdate file when nvim resumes from suspended state or gains focus
    autocmd VimResume * if empty(getcmdwintype()) | checktime | endif
    autocmd FocusGained * if empty(getcmdwintype()) | checktime | endif

    " reload fugitive status buffer when vim resumes from background
    autocmd VimResume * call fugitive#ReloadStatus()

    " highlight yanked region
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="Search", on_visual=false}
  augroup END
endif

"}}}
"{{{ mappings

" use gr to go to previous tab
nnoremap gr gT

" escape also cancels search highlight and redraw screen
nnoremap <silent> <esc> :nohlsearch<CR>:redraw!<CR><esc>

" go to vimrc file
nnoremap <silent> <space>ev :execute ":edit ".resolve($MYVIMRC)<CR>

" source current file, only if it is .vim file
nnoremap <expr> <space>ss (&ft == "vim" ? ":source %<CR>" : &ft == "lua" ? ":lua require('plenary.reload').reload_module(vim.fn.expand('%:t:r'))<CR>" : "")

" make <c-u> and <c-w> undoable
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>

" vertical movement
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Y consistent with C, D etc.
nnoremap Y y$

" ' is more convenient to jump to the exact location of a mark
nnoremap ' `

" better maps to move between splits
nnoremap <silent> <C-w><C-q> :close<CR>
nnoremap <silent> <C-j> <C-w><C-j>
nnoremap <silent> <C-k> <C-w><C-k>
nnoremap <silent> <C-l> <C-w><C-l>
nnoremap <silent> <C-h> <C-w><C-h>

" resize splits with arrow keys
nnoremap <silent> <c-left>  <C-w>>
nnoremap <silent> <c-right> <C-w><
nnoremap <silent> <c-down>  <C-w>-
nnoremap <silent> <c-up>    <C-w>+

" re-select region when indenting
vnoremap <silent> > >gv
vnoremap <silent> < <gv

" select last yanked text
nnoremap <silent> gy `[v`]

" disable key to Ex mode and command-line window (press c_CTRL-F instead)
nnoremap Q <nop>

" mapping to change the word under the cursor. use . to repeat
nnoremap <silent> <C-n> *Ncgn

" format paragraph
nnoremap <M-q> gwip

" emacs keybindings that I use
inoremap <C-A> <Home>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"

" cool mapping to get a list of dates
let date_formats = ['%Y-%m-%d','%Y-%m-%dT%H:%M:%S%Z']
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(date_formats,'strftime(v:val)')),0)<CR>

" <space> should not move cursor in normal mode
nnoremap <space> <nop>

" when using ^R^L in command-line mode, strip out leading whitespace
cnoremap <C-R><C-L> <C-R>=substitute(getline('.'), '^\s*', '', '')<CR>

" use <Tab> as an operator for matchit
omap <Tab> %
xmap <Tab> %

" copy current file name
nnoremap y<C-p> :let @+=expand("%:p")<CR>

" use ctrl-k to delete until end of line in insert mode
inoremap <C-k> <C-o>D
inoremap <C-x><C-k> <C-k>

" go to local/global declaration and turn off search highlight afterwards
nnoremap <silent> gd gd:nohlsearch<CR>
nnoremap <silent> gD gD:nohlsearch<CR>
nnoremap <silent> 1gd 1gd:nohlsearch<CR>
nnoremap <silent> 1gD 1gD:nohlsearch<CR>

" convenient abbreviations
inoreabbrev Taebl Table
inoreabbrev taebl table

nnoremap <silent> gb :call gitblame#BlameLine()<CR>

" fix netrw gx being broken
let g:netrw_nogx=1

augroup OpenFileWithF5
  autocmd!
  autocmd FileType html,dirvish,svg nnoremap <silent><buffer> <F5> :call os#open_file(bufname())<CR>
augroup END

nnoremap <silent> gx :call os#open_file_under_cursor(v:false)<CR>
vnoremap <silent> gx :<C-U>call os#open_file_under_cursor(v:true)<CR>

nmap <silent> gq :set operatorfunc=format#operatorfunc<CR>g@
vmap <silent> gq :<C-U>set operatorfunc=format#operatorfunc<CR>gvg@

command! -bang FormatPrg call format#file(<bang>0)
nmap <silent> gQ :FormatPrg<CR>
nmap <silent> <space>Q :FormatPrg!<CR>

" add mapping to do fugitive related tasks more quickly
nmap <space>g :Git<space>

" add unimpaired-style mappings ignore whitespace on diffs
nmap [oi :set diffopt+=iwhite
nmap ]oi :set diffopt-=iwhite
nmap yoi :call iwhite#toggle()

"}}}
"{{{ commands

" handle annoying command line typos
command! -bang -nargs=* -complete=file_in_path E e<bang>
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Qall qall<bang>

" show information about highlight group under cursor
command! Hi execute 'hi ' . synIDattr(synID(line("."), col("."), 0), "name")

"}}}
"{{{ statusline and tabline

if has('nvim')
  luafile $HOME/.config/nvim/lualine.lua
endif

function! Tabline() abort
  let tabline = ''
  for tab in range(1, tabpagenr('$'))
    " Get tab infos
    let tabwinnr = tabpagewinnr(tab)

    " Get buf infos
    let buflist = tabpagebuflist(tab)
    let tabbufnr = buflist[tabwinnr - 1]
    let bufname = bufname(tabbufnr)
    let fname = fnamemodify(bufname, ':t')
    let dir = fnamemodify(bufname, ':p:h:t')
    let ext = fnamemodify(bufname, ':e')

    " Set tab state
    let tabline .= '%' . tab . 'T'

    " Get tab highlight group
    let is_tab_selected = tab == tabpagenr()
    let tabline_hl = is_tab_selected ? 'TabLineSel' : 'TabLine'
    let tabline .= '%#' . tabline_hl . '#'

    let spacing = repeat(' ', 2)

    let tabline .= spacing

    " Set tab highlight
    let tabline .= '%#' . tabline_hl . '#'

    " Set tab label
    if empty(bufname)
      let tabline .= '[No Name]'
    elseif getbufvar(tabbufnr, '&filetype') ==# 'dirvish'
      let tabline .= fnamemodify(bufname, ':p')
    elseif bufname =~# '^fugitive://'
      let fugitive_commitfile = get(FugitiveParse(bufname), 0, '')

      if empty(fugitive_commitfile)
        let tabline = 'fugitive'
      else
        if fugitive_commitfile == ':'
          let tabline .= 'fugitive-summary'
        else
          let tabline .= fugitive_commitfile
        endif
      endif
    elseif fname =~# '^index\.\k\+$'
      let tabline .= dir . '/' . fname
    else
      let tabline .= fname
    endif

    let tabline .= spacing
  endfor
  let tabline .= '%#TabLineFill#'
  return tabline
endfunction

set tabline=%!Tabline()

""}}}
"{{{ file navigation

set path=.,,..

" ignore these files while browsing
set wildignore=venv*/,__pycache__/,.pytest_cache/,tags,htmlcov/.coverage,*.pyc,package-lock.json

"}}}
"{{{ fuzzy finder

if executable('fzf')
  let g:fzf_preview_window = ''

  nnoremap <space>b :Buffers<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>h :Help<CR>
  nnoremap <space>r :History<CR>
  nnoremap <space>p :Commands<CR>

  function! CheckoutBranch(branch)
    execute '!' FugitiveShellCommand('checkout', a:branch)
  endfunction

  function! CheckoutBranchFzf()
    call fzf#run(fzf#wrap({
          \ 'source': FugitiveShellCommand('branch', '-v', '--sort', '-committerdate', '--format', '%(refname:short)'),
          \ 'sink': function('CheckoutBranch'),
          \ 'options': '--prompt "Checkout: " --preview "' . FugitiveShellCommand('log', '--oneline') . ' {}"'
          \ }))
  endfunction

  nnoremap <space>cb :call CheckoutBranchFzf()<CR>

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

  if has('nvim')
    let $FZF_DEFAULT_OPTS .= ' --margin=0,2'

    function! FloatingFZF()
      let width = float2nr(&columns * 0.9)
      let height = float2nr(&lines * 0.6)
      let opts = {
            \ 'relative': 'editor',
            \ 'border': 'single',
            \ 'row': (&lines - height) / 2,
            \ 'col': (&columns - width) / 2,
            \ 'width': width,
            \ 'height': height
            \ }

      let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
      call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
    endfunction

    let g:fzf_layout = { 'window': 'call FloatingFZF()' }
  endif
endif

"}}}
"{{{ quickfix config

" wrap around when navigating the quickfix list
nnoremap <silent> ]q :call qflist#jump("cnext")<CR>
nnoremap <silent> [q :call qflist#jump("cprevious")<CR>
nnoremap <silent> ]l :call loclist#jump("lnext")<CR>
nnoremap <silent> [l :call loclist#jump("lprevious")<CR>

if has('nvim')
  nnoremap <silent> <space>q :call qflist#toggle()<CR>
  nnoremap <silent> <space>l :call loclist#toggle()<CR>
endif

augroup QuickFix
  autocmd!
  autocmd QuickFixCmdPost * call qflist#open()
augroup END

augroup CloseQuickFix
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | quit | endif
augroup END

"}}}
"{{{ coc

nmap <space>cr :CocRestart<CR>

let g:coc_global_extensions = [
      \'coc-tsserver',
      \'coc-json',
      \'coc-html',
      \'coc-css',
      \'coc-prettier',
      \'coc-eslint',
      \'coc-syntax',
      \'coc-styled-components',
      \'coc-sumneko-lua',
      \'coc-rust-analyzer',
      \]

set nobackup
set nowritebackup
set updatetime=300

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10
set tagfunc=CocTagFunc

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ pumvisible() ? "\<C-n>"  :
      \ utils#check_back_space() ? "\<TAB>" :
      \ coc#rpc#ready() ? coc#refresh() :
      \ !empty(&omnifunc) ? "\<C-x>\<C-o>" :
      \ "\<C-n>"
inoremap <silent><expr> <c-space>
      \ coc#rpc#ready() ? coc#refresh() :
      \ !empty(&omnifunc) ? "\<C-x>\<C-o>" :
      \ ""
inoremap <expr><s-tab> coc#pum#visible() ? coc#pum#prev(1) : pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

function! s:showDocumentation() abort
  if CocHasProvider('hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nnoremap <silent> K :call <SID>showDocumentation()<CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" jump to defition
nmap <silent> [d <Plug>(coc-definition)
nmap <silent> <C-w>d :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <silent> <C-w><C-d> :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <silent> <C-w>} :call CocActionAsync('jumpDefinition', 'pedit')<CR>
nmap <silent> [t <Plug>(coc-type-definition)
nmap <silent> <C-space> :call CocActionAsync("diagnosticInfo")<CR>

nnoremap <silent> <M-S-O> :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
nmap <F2> <Plug>(coc-rename)

" code actions
nmap <M-CR> <Plug>(coc-codeaction-cursor)
nmap <space>a <Plug>(coc-codeaction-cursor)

" scroll through hover floating window
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-d>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-u>"
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
endif

" symbols and diagnostics
nnoremap <space>s :<C-u>CocList -I symbols<CR>
let g:coc_quickfix_open_command = 'doautocmd QuickFixCmdPost | cfirst'

" miscellaneous commands
command! -nargs=0 References :call CocActionAsync('jumpReferences')
command! -nargs=0 Fmt :call CocAction('format')
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" better ui to run coc command
nnoremap <space>c :CocList commands<CR>

"}}}
"{{{ treesitter

if has('nvim')
  luafile $HOME/.config/nvim/treesitter.lua
endif

"}}}
"{{{ text objects

" number text object (integer and float)
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal! v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap <silent> in :<C-u>call VisualNumber()<CR>
onoremap <silent> in :<C-u>normal vin<CR>

" square brackets text objects
xnoremap <silent> ir i[
xnoremap <silent> ar a[
onoremap <silent> ir :normal vi[<CR>
onoremap <silent> ar :normal va[<CR>

for char in ['_', '-', '/', '*', ',']
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
  return ''
endfunction

function! CleanUp()
  let &l:omnifunc = b:old_omnifunc
  return ''
endfunction

inoremap <silent> <C-x>/ <Lt>/<C-r>=CloseTag()<CR><C-r>=Reindent()<CR><C-r>=CleanUp()<CR>

"}}}
" vim: foldmethod=marker
