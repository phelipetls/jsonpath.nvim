; extends

((inline) @_inline (#match? @_inline "^\(import\|export\)")) @tsx

((inline) @_inline (#match? @_inline "^[<][A-Z]")) @tsx
