if exists('current_compiler')
  finish
endif
let current_compiler = 'pyunit'

if exists(':CompilerSet') != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=python3\ -m\ unittest\ -p\ %:S
CompilerSet errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m


     " 1	==============================================================
     " 2	FAIL: testGetTypeIdCachesResult (dbfacadeTest.DjsDBFacadeTest)
     " 3	--------------------------------------------------------------
     " 4	Traceback (most recent call last):
     " 5	  File "unittests/dbfacadeTest.py", line 89, in testFoo
     " 6	    self.assertEquals(34, dtid)
     " 7	  File "/usr/lib/python2.2/unittest.py", line 286, in
     " 8	 failUnlessEqual
     " 9	    raise self.failureException, \
    " 10	AssertionError: 34 != 33
    " 11
    " 12	--------------------------------------------------------------
    " 13	Ran 27 tests in 0.063s
