; extends

((inline) @_inline (#match? @_inline "^\(import\|export\)")) @nospell

((html_block) @_block (#match? @_block "\s*[<]/\?[A-Z]")) @nospell
