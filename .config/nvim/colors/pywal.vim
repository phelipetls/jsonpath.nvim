hi clear
set background=dark

let g:colors_name = 'pywal'

let pywal_file = "$HOME/.cache/wal/colors-wal.vim"

if filereadable(expand(pywal_file))
  exe "source ".pywal_file
else
  echoerr "No pywal generated file"
  finish
endif

if has("nvim")
  call luaeval('require("nvim-web-devicons").set_default_icon("", _A[1])', [foreground])
endif

"{{{ Syntax groups
exe "hi Normal ctermbg=NONE guibg=NONE ctermfg=15 guifg=".color15
exe "hi NormalFloat ctermbg=0 guibg=".color0." ctermfg=15 guifg=".color15
exe "hi link NormalFloat Normal"

exe "hi Comment ctermfg=8 guifg=".color8

exe "hi Constant ctermfg=5 guifg=".color5
exe "hi String ctermfg=2 guifg=".color2
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Constant

exe "hi Identifier ctermfg=3 guifg=".color3." cterm=NONE gui=NONE"
exe "hi Function ctermfg=4 guifg=".color4." cterm=NONE gui=NONE"

exe "hi Statement ctermfg=9 guifg=".color9." gui=NONE"

exe "hi PreProc ctermfg=6 guifg=".color6
hi link Include Statement

exe "hi Type ctermfg=4 guifg=".color4" gui=NONE"

exe "hi Special ctermfg=5 guifg=".color5
exe "hi SpecialChar ctermfg=5 guifg=".color5
exe "hi SpecialKey ctermfg=5 guifg=".color5
hi link Delimiter SpecialChar
hi link SpecialComment SpecialChar

exe "hi Underlined ctermfg=1 guifg=".color1." cterm=UNDERLINE gui=UNDERLINE"

exe "hi Ignore ctermbg=NONE guibg=NONE ctermfg=15 guifg=".color15
"}}}
"{{{ Misc
exe "hi DiffDelete ctermfg=1 ctermbg=NONE guibg=#572E33 guifg=NONE"
exe "hi DiffAdd ctermfg=2 ctermbg=0 guibg=#26332c guifg=NONE"
exe "hi DiffChange ctermfg=NONE ctermbg=NONE guifg=NONE guibg=#273842"
exe "hi DiffText ctermfg=15 ctermbg=2 guibg=#314753 guifg=NONE"

exe "hi diffAdded ctermfg=2 guifg=".color2
exe "hi diffRemoved ctermfg=1 guifg=".color1
hi link diffBDiffer WarningMsg
hi link diffCommon WarningMsg
hi link diffDiffer WarningMsg
hi link diffIdentical WarningMsg
hi link diffIsA WarningMsg
hi link diffNoEOL WarningMsg
hi link diffOnly WarningMsg

exe "hi Error ctermbg=1 guibg=".color1." ctermfg=0 guifg=".color15
exe "hi ErrorMsg ctermbg=1 guibg=".color1." ctermfg=0 guifg=".color15
exe "hi WarningMsg ctermbg=1 guibg=".color1." ctermfg=0 guifg=".color15

exe "hi ModeMsg ctermfg=15 guifg=".color15." cterm=NONE gui=NONE"
exe "hi MoreMsg ctermfg=3 guifg=".color3." gui=NONE"
exe "hi Title ctermfg=3 guifg=".color3." gui=NONE"
exe "hi Question ctermfg=8 guifg=".color8." gui=NONE"

exe "hi Todo ctermbg=NONE guibg=NONE ctermfg=2 guifg=".color2." cterm=BOLD gui=BOLD"

exe "hi LineNr ctermfg=8 guifg=".color8
exe "hi CursorLineNr ctermfg=8 guifg=".color8
exe "hi SignColumn ctermbg=NONE guibg=NONE ctermfg=15 guifg=".color15

exe "hi CursorColumn ctermbg=0 guibg=".color0

exe "hi Directory ctermfg=1 guifg=".color1

exe "hi NonText ctermbg=NONE guibg=NONE ctermfg=8 guifg=".color8

exe "hi Visual ctermbg=4 guibg=".color4." ctermfg=0 guifg=".color0
exe "hi VisualNOS ctermbg=NONE guibg=NONE ctermfg=1 guifg=".color1
exe "hi Search ctermbg=8 guibg=".color8." ctermfg=15 guifg=".color15
exe "hi IncSearch ctermbg=1 guibg=".color1." ctermfg=15 guifg=".color15." cterm=BOLD gui=BOLD"

exe "hi Pmenu ctermbg=8 guibg=".color8." ctermfg=15 guifg=".color15
exe "hi PmenuSbar ctermbg=6 guibg=".color6." ctermfg=15 guifg=".color15
exe "hi PmenuSel ctermbg=4 guibg=".color4." ctermfg=0 guifg=".color0
exe "hi PmenuThumb ctermbg=8 guibg=".color8." ctermfg=8 guifg=".color8

exe "hi CursorLine ctermbg=NONE guibg=NONE ctermfg=NONE cterm=BOLD gui=BOLD"

exe "hi VertSplit ctermbg=NONE guibg=NONE ctermfg=8 guifg=".color8." cterm=NONE gui=NONE"

exe "hi StatusLine ctermbg=8 guibg=".color8." ctermfg=15 guifg=".color15." cterm=BOLD gui=BOLD"
exe "hi TabLineSel ctermbg=8 guibg=".color8." ctermfg=15 guifg=".color15
exe "hi StatusLineNC ctermbg=8 guibg=".color8." ctermfg=7 guifg=".color7." cterm=NONE gui=NONE"
exe "hi TabLine ctermbg=0 guibg=".color0." ctermfg=7 guifg=".color7." cterm=NONE gui=NONE"
exe "hi TabLineFill ctermbg=0 guibg=".color0." cterm=NONE gui=NONE"

exe "hi ColorColumn ctermbg=0 guibg=".color0." cterm=NONE gui=NONE"

exe "hi MatchParen ctermbg=8 guibg=".color8." ctermfg=15 guifg=".color15

exe "hi SpellBad ctermbg=NONE guibg=NONE ctermfg=1 guifg=".color1." cterm=UNDERLINE gui=UNDERLINE"
exe "hi SpellCap ctermbg=NONE guibg=NONE ctermfg=4 guifg=".color4." cterm=UNDERLINE gui=UNDERLINE"
exe "hi SpellLocal ctermbg=NONE guibg=NONE ctermfg=5 guifg=".color5." cterm=UNDERLINE gui=UNDERLINE"
exe "hi SpellRare ctermbg=NONE guibg=NONE ctermfg=6 guifg=".color6." cterm=UNDERLINE gui=UNDERLINE"

exe "hi FoldColumn ctermbg=NONE guibg=NONE guibg=NONE ctermfg=15 guifg=".color15
exe "hi Folded ctermbg=NONE guibg=NONE guibg=NONE ctermfg=8 guifg=".color8

exe "hi WildMenu ctermfg=0 guifg=".color0." ctermbg=11 guibg=".color11

if has("nvim")
 exe "hi MsgArea ctermfg=15 guifg=".color15." ctermbg=NONE guibg=NONE gui=NONE"
 hi link QuickFixLine CursorLine
 exe "hi Whitespace ctermbg=NONE guibg=NONE ctermfg=8 guifg=".color8
endif

if has("nvim-0.5.0")
 exe "hi LspError ctermfg=1 guifg=".color1
 exe "hi LspWarning ctermfg=1 guifg=".color3
 exe "hi LspInfo ctermfg=1 guifg=".color4
 exe "hi LspHint ctermfg=1 guifg=".color4

 hi link LspDiagnosticsSignError LspError
 hi link LspDiagnosticsSignWarning LspWarning
 hi link LspDiagnosticsSignInformation LspInformation
 hi link LspDiagnosticsSignHint LspHint

 hi link LspDiagnosticsVirtualTextError LspError
 hi link LspDiagnosticsVirtualTextWarning LspWarning
 hi link LspDiagnosticsVirtualTextInformation LspInformation
 hi link LspDiagnosticsVirtualTextHint LspHint

 hi link LspDiagnosticsUnderlineError LspError
 hi link LspDiagnosticsUnderlineWarning LspWarning
 hi link LspDiagnosticsUnderlineInformation LspInformation
 hi link LspDiagnosticsUnderlineHint LspHint

 hi link LspReferenceText Search
 hi link LspReferenceRead Search
 hi link LspReferenceWrite Search

 hi link CocErrorSign LspError
 hi link CocWarningSign LspWarning
 hi link CocHintSign LspHint
 hi link CocInfoSign LspInfo

 hi link CocErrorFloat Normal
 hi link CocWarningFloat Normal
 hi link CocHintFloat Normal
 hi link CocInfoFloat Normal

 exe "hi CocFadeOut ctermbg=NONE guibg=NONE ctermfg=8 guifg=".color8
endif

"}}}
