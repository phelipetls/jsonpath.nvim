hi clear
set background=dark

let g:colors_name = 'sixteen'

"{{{ Syntax groups
hi Normal ctermbg=NONE ctermfg=7

hi Comment ctermfg=8

hi Constant ctermfg=5
hi String ctermfg=2
hi link Character Constant
hi link Number Constant
hi link Boolean Constant
hi link Float Constant

hi Identifier ctermfg=3 cterm=NONE
hi Function ctermfg=4 cterm=NONE

hi Statement ctermfg=9

hi PreProc ctermfg=6
hi link Include Statement

hi Type ctermfg=4

hi Special ctermfg=5
hi SpecialChar ctermfg=5
hi link Delimiter SpecialChar
hi link SpecialComment SpecialChar

hi Underlined ctermfg=1 cterm=UNDERLINE

hi Ignore ctermbg=NONE ctermfg=7

"}}}
"{{{ Misc
hi DiffAdd ctermbg=NONE ctermfg=green cterm=BOLD
hi DiffDelete ctermbg=black ctermfg=red
hi DiffChange ctermbg=NONE ctermfg=NONE
hi DiffText ctermbg=NONE ctermfg=NONE cterm=BOLD

hi Error ctermbg=1 ctermfg=0
hi link ErrorMsg Error
hi link WarningMsg Error

hi ModeMsg ctermfg=7 cterm=NONE
hi MoreMsg ctermfg=3

hi Question ctermfg=8

hi Todo ctermbg=2 ctermfg=0

hi LineNr ctermfg=8
hi CursorLineNr ctermfg=8
hi SignColumn ctermbg=0 ctermfg=8

hi CursorColumn ctermbg=8 ctermfg=NONE

hi Directory ctermfg=1

hi NonText ctermbg=NONE ctermfg=8

hi Visual ctermbg=6 ctermfg=0
hi VisualNOS ctermbg=NONE ctermfg=1
hi Search ctermbg=8 ctermfg=7
hi IncSearch ctermbg=1 ctermfg=7 cterm=BOLD

hi Pmenu ctermbg=8 ctermfg=7
hi PmenuSbar ctermbg=6 ctermfg=7
hi PmenuSel ctermbg=4 ctermfg=0
hi PmenuThumb ctermbg=8 ctermfg=8

hi CursorLine ctermbg=0 ctermfg=NONE cterm=BOLD

hi VertSplit ctermbg=0 ctermfg=0

hi StatusLine ctermbg=7 ctermfg=0
hi StatusLineNC ctermbg=8 ctermfg=0
hi TabLine ctermbg=NONE ctermfg=8
hi TabLineFill ctermbg=NONE ctermfg=8 cterm=UNDERLINE
hi TabLineSel ctermbg=8 ctermfg=7

hi MatchParen ctermbg=8 ctermfg=7

hi SpellBad ctermbg=NONE ctermfg=1 cterm=UNDERLINE
hi SpellCap ctermbg=NONE ctermfg=4 cterm=UNDERLINE
hi SpellLocal ctermbg=NONE ctermfg=5 cterm=UNDERLINE
hi SpellRare ctermbg=NONE ctermfg=6 cterm=UNDERLINE

hi FoldColumn ctermbg=NONE ctermfg=7
hi Folded ctermbg=NONE ctermfg=8

hi WildMenu ctermfg=0 ctermbg=11

if has("nvim")
  hi MsgArea ctermfg=7 ctermbg=NONE
  hi link QuickFixLine CursorLine
  hi Whitespace ctermbg=NONE ctermfg=8
endif

hi Title ctermfg=5

if has("nvim-0.5.0")
  hi LspDiagnosticsSignInformation ctermfg=yellow
  hi LspDiagnosticsSignWarning ctermfg=red
  hi LspDiagnosticsSignError ctermfg=red
  hi LspDiagnosticsSignHint ctermfg=yellow
endif

"}}}
