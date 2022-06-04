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
packadd! matchit
packadd! vim-lion
packadd! tagalong.vim
packadd! splitjoin.vim
packadd! jsonc.vim
packadd! vim-sleuth
packadd! inline_edit.vim
if has('nvim')
  packadd! copilot.vim
endif

" git
packadd! vim-fugitive
packadd! fugitive-gitlab.vim
packadd! vim-rhubarb
packadd! diffconflicts
packadd! git-messenger.vim

" file navigation
packadd! vim-dirvish

" fuzzy finder
set rtp+=~/.fzf
packadd! fzf.vim

" vim specific improvements
packadd! traces.vim
packadd! vim-obsession
packadd! editorconfig-vim
packadd! cfilter
packadd! vim-slime
packadd! vim-toml
if has('nvim')
  packadd! nvim-colorizer.lua
  packadd! coc.nvim
endif

" web development
packadd! vim-javascript
packadd! yats.vim
packadd! vim-jsx-pretty
packadd! vim-hugo

" aesthetics
if has('nvim-0.5.0')
  packadd! nvim-web-devicons
  packadd! lualine.nvim
  packadd! nvim-notify
endif

"}}}
"{{{ settings

set termguicolors
colorscheme pywal

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
set fillchars=fold:-,vert:│
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

"}}}
"{{{ plugins config

" disable javascript browser-related keywords
let g:yats_host_keyword = 0

" integrate traces.vim with vim-subvert
let g:traces_abolish_integration = 1

" slime
if exists('$TMUX')
  let g:slime_target = 'tmux'
  let g:slime_default_config = {'socket_name': 'default', 'target_pane': '{last}'}
  let g:slime_dont_ask_default = 1
elseif has('unix')
  let g:slime_target = 'x11'
else
  let g:slime_target = 'neovim'
endif

nnoremap <silent> <C-c><C-c> <Plug>SlimeRegionSend
nnoremap <silent> <C-c><C-w> :exe ":SlimeSend1 " . expand('<cword>')<CR>
nnoremap <silent> <C-c>% :%SlimeSend<CR>
nnoremap <silent> <C-c><C-l> :exe ":silent !tmux send-keys -t " . b:slime_config['target_pane'] . " '^L'"<CR>

" disable editorconfig for these file patterns
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" enable tagalong in javascript, not only jsx
let g:tagalong_additional_filetypes = ['javascript']

" disable saving session on BufEnter
let g:obsession_no_bufenter = 1

" colorizer config
if has('nvim') && filereadable(printf('%s/%s', fnamemodify(expand('<sfile>'),':h'), 'colorizer.lua')) && !empty(&termguicolors)
  luafile $HOME/.config/nvim/colorizer.lua
endif

" disable colors in deno and nodejs
let $NO_COLOR=0

" avoid showing ansi escape sequences in nvim terminal
" such as in lint-staged output before committing
let g:fugitive_pty=0

let $LESS='RX'

let g:git_messenger_floating_win_opts = {'border': 'single'}
let g:git_messenger_popup_content_margin = v:false

augroup GitMessenger
  autocmd!
  autocmd FileType gitmessengerpopup setlocal keywordprg=git\ show
augroup END

imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

nnoremap <C-c>' :InlineEdit<CR>

let g:inline_edit_autowrite=1

"}}}
"{{{ autocommands

augroup GlobalAutocmds
  autocmd!
  " don't autocomment on newline
  autocmd FileType * set formatoptions-=cro

  " after reading a buffer, jump to last position before exiting it
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "git" |
        \   exe "normal g`\"" |
        \ endif

  " autoresize splits when vim is resized
  autocmd VimResized * wincmd =

  autocmd FocusGained * checktime

  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,sh,yaml,vim,lua,json,html,css set expandtab shiftwidth=2 softtabstop=2
  autocmd FileType python set expandtab shiftwidth=4 softtabstop=4

  " put the current file name under the f register
  autocmd BufEnter * let @f=expand("%:t:r")
augroup END

if has('nvim')
  " VimResume is Neovim-only
  augroup GlobalNeovimOnlyAutocmds
    autocmd!
    " checktime when nvim resumes from suspended state
    autocmd VimResume * checktime

    " reload fugitive status buffer when vim resumes from background
    autocmd VimResume * call fugitive#ReloadStatus()
  augroup END
endif

"}}}
"{{{ mappings

" use gr to go to previous tab
nnoremap gr gT

" escape also cancels search highlight and redraw screen
nnoremap <silent> <esc> :nohlsearch<CR>:redraw!<CR><<esc>

" go to vimrc file
nnoremap <silent> <space>ev :edit $MYVIMRC<CR>

" source current file, only if it is .vim file
nnoremap <silent><expr> <space>ss (&ft == "vim" ? ":source %<CR>" : "")

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

" handle annoying command line typos
command! -bang -nargs=* -complete=file_in_path E e<bang>
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Qall qall<bang>

" mapping to change the word under the cursor. use . to repeat
nnoremap <silent> <C-n> *Ncgn

" show information about highlight group under cursor
command! Hi exe 'hi ' . synIDattr(synID(line("."), col("."), 0), "name")

" highlight yanked region
if has('nvim-0.5.0')
  augroup highlight_yank
      autocmd!
      autocmd TextYankPost * silent!
            \ au TextYankPost * silent!
            \ lua vim.highlight.on_yank {higroup="Search", on_visual=false}
  augroup END
endif

" format paragraph
nnoremap <M-q> gwip

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

augroup FugitiveMappings
  autocmd!
  autocmd User FugitiveIndex unmap <buffer> P
  autocmd User FugitiveIndex nnoremap <buffer> P<space> :Git push<space>
  autocmd User FugitiveIndex nnoremap <buffer> F<space> :Git pull<space>
  autocmd User FugitiveIndex nnoremap <buffer> Fp :Git pull origin @{push}<space>
  autocmd User FugitiveIndex nnoremap <buffer> Fu :Git pull origin @{upstream}<space>
augroup end

" convenient abbreviations
inoreabbrev Taebl Table
inoreabbrev taebl table
inoreabbrev github GitHub

" git messenger mapping
nnoremap <silent> gb :GitMessenger<CR>

" fix netrw gx being broken
let g:netrw_nogx=1

function! s:getVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection ==# 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:OpenFileUnderCursor(is_visual_mode)
  let s:open_command =
        \ has('mac') && executable('open') ?
        \ 'open'
        \ : has('unix') && executable('xdg-open')
        \ ? 'xdg-open'
        \ : ''

  if empty(s:open_command)
    echohl ErrorMsg
    echo 'Could not determine a command to open file'
    echohl None

    return
  endif

  if &ft ==? 'dirvish'
    let s:fname = getline('.')
  elseif a:is_visual_mode
    let s:fname = <SID>getVisualSelection()
  else
    let s:fname = expand('<cfile>')
  endif

  call system(printf('%s %s', s:open_command, shellescape(s:fname)))
endfunction

nnoremap <silent> gx :call <SID>OpenFileUnderCursor(v:false)<CR>
vnoremap <silent> gx :<C-U>call <SID>OpenFileUnderCursor(v:true)<CR>

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
    execute winnr . 'wincmd w'
    execute a:cmd
  endfor
  execute initial_winnr . 'wincmd w'
endfunction

nmap <silent> gq :set opfunc=Format<CR>g@
nmap <silent> gQ :call SameBufferWinDo("let w:view = winsaveview()")<CR>
      \ :set opfunc=Format<CR>
      \ :keepjumps normal gg<CR>
      \ :keepjumps normal gqG<CR>
      \ :call SameBufferWinDo('keepjumps call winrestview(w:view)')<CR>

nmap <space>g :Git<space>

"}}}
"{{{ statusline and tabline

if has('nvim')
lua << END

local fugitivestatusline = function()
  local fugitive = vim.fn['FugitiveStatusline']()

  local _, _, revision = string.find(fugitive, '%[Git:(%w+)%(')
  local _, _, branch = string.find(fugitive, '%[Git%((.+)%)')

  return revision or branch or ''
end

require('lualine').setup({
  options = {
    theme = 'pywal',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return ' ' end }
    },
    lualine_b = {
      {
        fugitivestatusline,
        fmt = function(commit)
          if commit == '' then
            return ''
          end

          return string.format(' %s', commit)
        end,
        cond = function()
          return vim.fn.winwidth(0) == vim.o.columns
        end
      },
      'g:async_make_status',
    },
    lualine_c = {
      {
        'filename',
        path = 0,
        symbols = {
          modified = ' [+]',
          readonly = ' [-]',
        }
      }
    },
    lualine_x = {'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {
      {
        '%l:%L',
        type = 'stl'
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      'filetype',
      'location',
    }
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        max_length = vim.o.columns,
        mode = 2
      }
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {
    'quickfix',
    'fugitive',
    {
      sections = {
        lualine_a = {
          {
            function()
              return #vim.fn.argv()
            end,
            fmt = function(args)
              return string.format('%d args', args)
            end
          }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      filetypes = {'dirvish'}
    }
  },
})
END
endif

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

  function! GoIntoDirectory(...)
    let s:path = get(a:, 1, getcwd())
    let s:source = printf('%s . %s', $FZF_ALT_C_COMMAND, shellescape(expand(s:path)))
    call fzf#run(fzf#wrap({
          \ 'source': s:source,
          \ 'sink': 'edit',
          \ 'options': '--prompt "Directory: " --preview "tree {}"'
          \ }))
  endfunction

  nnoremap <space>cd :call GoIntoDirectory()<CR>
  command! -complete=dir -nargs=? Cd :call GoIntoDirectory(<q-args>)

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

if has('nvim')
  command! -nargs=* -complete=file_in_path Make lua require'async_make'.make(<q-args>)
else
  command! -nargs=* -complete=file_in_path Make silent make!
endif

function! RunMake()
  if empty(&l:makeprg)
    return
  endif
  let compiler = get(b:, 'current_compiler', '')
  if index(['jest', 'pytest', 'pyunit'], compiler) >= 0
    make! %
    return
  endif
  Make %
endfunction

nnoremap <silent> <space>m :call RunMake()<CR>

function! OpenQuickfixList()
  botright cwindow 5
  if &buftype ==# 'quickfix'
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
  if &buftype ==# 'quickfix'
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

if has('nvim')
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

nmap <space>cc :CocStart<CR>
nmap <space>cr :CocRestart<CR>
nmap <space>cs :CocRestart<CR>

let g:coc_global_extensions = [
      \'coc-tsserver',
      \'coc-json'
      \]

set nobackup
set nowritebackup
set updatetime=300

set completeopt=menuone,noselect,noinsert
set shortmess+=c
set pumheight=10

function! s:checkBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>checkBackSpace() ? "\<TAB>" :
      \ coc#rpc#ready() ? coc#refresh() :
      \ !empty(&omnifunc) ? "\<C-x>\<C-o>" :
      \ "\<C-n>"

inoremap <silent><expr> <c-space>
      \ !empty(&omnifunc) ? "\<C-x>\<C-o>" :
      \ coc#rpc#ready() ? coc#refresh() :
      \ ""

function! s:showDocumentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() :"\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

set tagfunc=CocTagFunc

nmap <silent> [d <Plug>(coc-definition)
nmap <silent> <C-w>d :call CocActionAsync('jumpDefinition', 'split')<CR>
nmap <silent> <C-w><C-d> :call CocActionAsync('jumpDefinition', 'split')<CR>

nmap <silent> <C-c><C-p> :call CocActionAsync("jumpDefinition", 'pedit')<CR>
nmap <silent> <C-w>} :call CocActionAsync('jumpDefinition', 'pedit')<CR>

nmap <silent> [t <Plug>(coc-type-definition)

nmap <silent> <C-space> :call CocActionAsync("diagnosticInfo")<CR>

command! -nargs=0 References :call CocActionAsync('jumpReferences')
command! -nargs=0 Fmt :call CocAction('format')
nnoremap <silent> <M-S-O> :call CocActionAsync('runCommand', 'editor.action.organizeImport')<CR>
nnoremap <silent> K :call <SID>showDocumentation()<CR>

inoremap <silent> <C-c><C-p> <C-r>=CocActionAsync('showSignatureHelp')<CR>

nmap <F2> <Plug>(coc-rename)

nmap <M-CR> <Plug>(coc-codeaction-cursor)

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

nnoremap <silent><expr> <C-y> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-y>"
nnoremap <silent><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-e>"

let g:coc_quickfix_open_command = 'doautocmd QuickFixCmdPost | cfirst'

nnoremap <space>s :<C-u>CocList -I symbols<CR>
nnoremap <space>d :CocDiagnostics<CR>

lua << EOF
vim.notify = require("notify")

vim.notify.setup({
  stages = 'static'
})

local coc_status_record = {}

function coc_status_notify(msg, level)
  local notify_opts = { title = "LSP Status", timeout = 500, hide_from_history = true, on_close = reset_coc_status_record }
  -- if coc_status_record is not {} then add it to notify_opts to key called "replace"
  if coc_status_record ~= {} then
    notify_opts["replace"] = coc_status_record.id
  end
  coc_status_record = vim.notify(msg, level, notify_opts)
end

function reset_coc_status_record(window)
  coc_status_record = {}
end
EOF

function! s:StatusNotify() abort
  let l:status = get(g:, 'coc_status', '')
  let l:level = 'info'
  if empty(l:status) | return '' | endif
  call v:lua.coc_status_notify(l:status, l:level)
endfunction

function! s:InitCoc() abort
  " load overrides
  runtime! autoload/coc/ui.vim
  execute "lua vim.notify('Initialized coc.nvim for LSP support', 'info', { title = 'LSP Status' })"
endfunction

" notifications
augroup Coc
  autocmd!
  autocmd User CocNvimInit call s:InitCoc()
  autocmd User CocStatusChange call s:StatusNotify()
augroup END

"}}}
"{{{ text objects

" number text object (integer and float)
" --------------------------------------
function! VisualNumber()
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal! v
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
