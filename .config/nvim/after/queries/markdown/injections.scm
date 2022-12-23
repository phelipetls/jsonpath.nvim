; extends

((inline) @_inline (#match? @_inline "^\(import\|export\)")) @tsx

((html_block) @_block (#match? @_block "\s*[<]/\?[A-Z]")) @tsx

((paragraph) @_block (#match? @_block "\s*[<]/\?[A-Z]")) @tsx
