if executable("jq")
  setlocal formatprg=jq\ .
elseif executable("python3")
  setlocal formatprg=python3\ -m\ json.tool
endif

command! Fix %s/\[\(Object\|Array\)]/""/gc
