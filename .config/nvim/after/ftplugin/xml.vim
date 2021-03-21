if executable("python3")
  let &l:formatprg='python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())'
endif
