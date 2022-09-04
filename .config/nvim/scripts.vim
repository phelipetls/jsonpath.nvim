if did_filetype()
  finish
endif

if getline(1) =~# '^#!.*Rscript.*$'
  set filetype=r
endif
