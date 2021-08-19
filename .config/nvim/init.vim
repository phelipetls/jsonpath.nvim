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
packadd! splitjoin.vim
packadd! vim-sleuth

" git
packadd! vim-fugitive
packadd! fugitive-gitlab.vim
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
  packadd! coc.nvim
endif

" web development
packadd! emmet-vim
packadd! vim-jinja
packadd! vim-javascript
packadd! yats.vim
packadd! vim-jsx-pretty
packadd! vim-hugo

"}}}
"{{{ settings

set termguicolors
colorscheme sixteen

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
set encoding=utf-8
set laststatus=2
set noshowmode
set updatetime=1000
set breakindent
set breakindentopt=shift:2
set linebreak

" don't autocomment on newline
autocmd! FileType * set formatoptions-=cro

" after reading a buffer, jump to last position before exiting it
autocmd! BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "git" |
      \   exe "normal g`\"" |
      \ endif

" tell neovim where python3 is -- this improves startup time
if has("nvim") && has("unix")
  let g:loaded_python_provider = 0
  let g:python3_host_prog = "/usr/bin/python3"
endif

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
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

" checktime when nvim resumes from suspended state
if has("nvim")
  autocmd! VimResume * checktime
endif

autocmd! FocusGained * checktime

" disable javascript browser-related keywords
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

" make fugitive buffers read only to avoid mistake of writing to them
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

function! SameBufferWinDo(cmd)
  let initial_winnr = winnr()
  let windows = filter(getwininfo(), {_, win -> win.bufnr == bufnr() && win.tabnr == tabpagenr()})
  for winnr in map(windows, {_, win -> win.winnr})
    execute winnr . "wincmd w"
    execute a:cmd
  endfor
  execute initial_winnr . "wincmd w"
endfunction

nmap <silent> gq :set opfunc=Format<CR>g@
nmap <silent> gQ :call SameBufferWinDo("let w:view = winsaveview()")<CR>
      \ :set opfunc=Format<CR>
      \ :keepjumps normal gg<CR>
      \ :keepjumps normal gqG<CR>
      \ :call SameBufferWinDo("keepjumps call winrestview(w:view)")<CR>

if has("nvim")
lua << EOF
  function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
  end
EOF
endif

"}}}
"{{{ mappings

" use gr to go to previous tab
nnoremap gr gT

" escape also cancels search highlight and redraw screen
nnoremap <silent> <esc> :nohlsearch<cr>:redraw!<cr><<esc>

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

" put the current file name under the f register
autocmd! BufEnter * let @f=expand("%:t:r")

" function used for abbreviations
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction

" emacs keybindings that I use
inoremap <C-A> <Home>
cnoremap <C-A> <Home>
cnoremap <C-X><C-A> <C-A>
inoremap <expr> <C-E> col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"

" cool mapping to get a list of dates
let date_formats = ["%Y-%m-%d","%Y-%m-%dT%H:%M:%S%Z"]
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(date_formats,'strftime(v:val)')),0)<CR>

" <space> should not move cursor in normal mode
nnoremap <space> <nop>

" when using ^R^L in command-line mode, strip out leading whitespace
cnoremap <C-R><C-L> <C-R>=substitute(getline('.'), '^\s*', '', '')<CR>

" use <Tab> as an operator for matchit
omap <Tab> %
xmap <Tab> %

" copy active file name
nnoremap yp :let @+=expand("%:p")<CR>
nnoremap y<C-p> :let @+=expand("%:p")<CR>

" copy active directory name
nnoremap yd :let @+=expand("%:h")<CR>
nnoremap y<C-d> :let @+=expand("%:h")<CR>

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

" git messenger mapping
nnoremap <silent> gb :GitMessenger<CR>

" fix netrw gx being broken
let g:netrw_nogx=1

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

if executable("xdg-open")
  nnoremap <silent> gx :call system(printf("xdg-open %s", shellescape(expand("<cWORD>"))))<CR>
  vnoremap <silent> gx :<C-U>call system(printf("xdg-open %s", shellescape(<SID>get_visual_selection())))<CR>
endif

"}}}
"{{{ statusline and tabline

function CocStatus()
  if !exists("*coc#status")
    return ''
  endif
  let status = coc#status()
  return !empty(status) ? '['.. status ..']' : ''
endfunction

function GetStatusLine(active) abort
  let fugitive = a:active ? FugitiveStatusline() : ''
  let coc = a:active ? CocStatus() : ''
  let modified = !&modifiable ? '[-]' : &modified ? '[+]' : ''
  let eol = &endofline ? '' : '[noeol]'

  return join(filter([fugitive, coc, modified, eol], "!empty(v:val)"), ' ')
endfunction

function! StatusLine(type) abort
  let statusline = ' %t '
  if a:type == 'active'
    let statusline.='%{GetStatusLine(1)}'
  else
    let statusline.='%{GetStatusLine(0)}'
  endif
  let statusline.='%='
  let statusline.='[%l/%L] %y'
  return statusline
endfunction

augroup StatusLine
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!StatusLine('active')
  autocmd WinLeave,BufLeave * setlocal statusline=%!StatusLine('inactive')
augroup end

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
set wildignore=venv*/,__pycache__/,.pytest_cache/,tags,htmlcov/.coverage,*.pyc,package-lock.json

if executable("fzf")
  let g:fzf_preview_window = ''

  nnoremap <space>b :Buffers<CR>
  nnoremap <space>f :Files<CR>
  nnoremap <space>h :Help<CR>
  nnoremap <space>t :Tags<CR>
  nnoremap <space>r :History<CR>

  function! CheckoutBranch(branch)
    exe '!' .. FugitivePrepare('checkout', a:branch)
  endfunction

  function! CheckoutBranchFzf()
    call fzf#run(fzf#wrap({
          \ 'source': FugitivePrepare('branch', '-v', '--sort', '-committerdate', '--format', '%(refname:short)'),
          \ 'sink': function('CheckoutBranch'),
          \ 'options': '--prompt "Checkout: " --preview "'..FugitivePrepare('log', '--oneline')..' {}"'
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

  if has("nvim")
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
  if empty(&l:makeprg)
    return
  endif
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

function! IsQuickfixOpen()
  return !empty(filter(getwininfo(), {_, win -> win.tabnr == tabpagenr() && win.quickfix == 1 && win.loclist == 0}))
endfunction

function! ToggleQuickfixList()
  if IsQuickfixOpen()
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

function! IsLoclistOpen()
  return !empty(filter(getwininfo(), {_, win -> win.tabnr == tabpagenr() && win.quickfix == 1 && win.loclist == 1}))
endfunction

function! ToggleLocationList()
  if IsLoclistOpen()
    lclose
    return
  endif
  call OpenLocationList()
endfunction

if has("nvim")
  nnoremap <silent> <space>q :call ToggleQuickfixList()<CR>
  nnoremap <silent> <space>w :call ToggleLocationList()<CR>
endif

augroup QuickFix
  autocmd!
  autocmd QuickFixCmdPost * call OpenQuickfixList()
augroup END

augroup CloseQuickFix
  au!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | q |endif
augroup END

"}}}
"{{{ coc

set nobackup
set nowritebackup
set updatetime=300

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> [d <Plug>(coc-definition)
nmap <silent> <C-w>d :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <silent> <C-w><C-d> :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <silent> <C-c><C-p> :call CocActionAsync("jumpDefinition", "pedit")<CR>
nmap <silent> [t <Plug>(coc-type-definition)

nmap <silent> <C-space> :call CocActionAsync("diagnosticInfo")<CR>

command! -nargs=0 References :call CocActionAsync('jumpReferences')
command! -nargs=0 Fmt :call CocAction('format')
nnoremap <silent> <M-S-O> :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

inoremap <silent> <C-c><C-p> <C-r>=CocActionAsync('showSignatureHelp')<CR>

nmap <F2> <Plug>(coc-rename)

nmap <M-CR> <Plug>(coc-codeaction-cursor)

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>g :<C-u>CocList -I symbols<cr>

let g:coc_quickfix_open_command = 'doautocmd QuickFixCmdPost | cfirst'

nnoremap <silent><expr> <c-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-y>"
nnoremap <silent><expr> <c-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-e>"

set tagfunc=CocTagFunc

"}}}
"{{{ treesitter

if has("nvim-0.5.0") && filereadable($HOME."/.config/nvim/treesitter.lua")
  luafile $HOME/.config/nvim/treesitter.lua
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

function! CleanUp()
  let &l:omnifunc = b:old_omnifunc
  return ""
endfunction

inoremap <silent> <C-X>/ <Lt>/<C-r>=CloseTag()<CR><C-r>=Reindent()<CR><C-r>=CleanUp()<CR>

"}}}
" vim: foldmethod=marker
