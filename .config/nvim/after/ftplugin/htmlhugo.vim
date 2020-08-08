setlocal path+=layouts,resources,content,archetypes,static,data,layouts/_default,layouts/partials,..

let b:surround_{char2nr("h")} = "{{ \r }}"
let b:surround_{char2nr("H")} = "{{ \1control flow: \1 \r }}\n{{ end }}"
