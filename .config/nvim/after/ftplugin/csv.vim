let &l:formatprg="sed -E 's/(,|\\t){2}/\\1NA\\1/g' | column -t -e -s,$'\\t'"
