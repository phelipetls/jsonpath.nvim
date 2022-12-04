; extends

(jsx_element) @tag.outer
(jsx_element . (jsx_opening_element) (_) @_start @_end (_)? @_end (jsx_closing_element) . (#make-range! "tag.inner" @_start @_end))
