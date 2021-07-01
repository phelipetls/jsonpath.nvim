setlocal formatprg=prettier\ --parser=css

" workaround css completion bug when writing media queries
let b:after = '"'
