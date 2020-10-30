if exists("current_compiler")
  finish
endif
let current_compiler = "hugo"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=%.%#file\ \"%f\"\\,\ line\ %l\\,\ col\ %c:%m,
      \ERROR.....................%m

" Error: Error building site: TOCSS: failed to transform "sass/main.scss" (text/x-scss): SCSS processing failed: file "/home/phelipe/Projetos/blog/assets/sass/_mixins.scss", line 25, col 35: Undefined variable: "$orange".
" ERROR 2020/10/30 14:16:21 Failed to get JSON resource "https://api.instagram.com/oembed/?url=https://instagram.com/p/BWNjjyYFxVx/&hidecaption=1": Failed to retrieve remote file: Bad Request
