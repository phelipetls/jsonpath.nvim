; extends

(element) @tag.outer
(element . (start_tag) . (_) @_start @_end (_)? @_end (end_tag) . (#make-range! "tag.inner" @_start @_end))
