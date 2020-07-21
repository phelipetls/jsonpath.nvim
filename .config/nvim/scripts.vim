if did_filetype()
  finish
endif

if getline(1) =~ "^#!.*Rscript.*$"
  set ft=r
endif
