if exists("current_compiler")
  finish
endif
let current_compiler = "pytest"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=pytest\ -s\ --tb=native\ %
CompilerSet errorformat=\%C\ %.%#,
      \%Efile\ %f\\,\ line\ %l,
      \%ZE\ %\\{7}%m,
      \%EE\ %\\{5}File\ \"%f\"\\,\ line\ %l,
      \%CE\ %\\{3}%p^,
      \%CE\ %\\{5}%.%#,
      \%A\ \ File\ \"%f\"\\,\ line\ %l\\,\ in\ %o,
      \%+Z%[a-z_\\.]%\\+:%\\@=%m,
      \%+G\ %[+>-]%.%#,
      \%-G%.%#,

" Maybe improve this
" \%+Z%[%^\/]%\\+:%m,
" to
" \%+Z%[a-z\\.]%\\+:%m,
" to match something like
" AssertionError: 2 != 1


" file /home/phelipe/Projetos/url-minifier/tests/test_index.py, line 56
"   def test_redirect_link_not_yet_expired(now, client, db):
" E       fixture 'now' not found
" >       available fixtures: app, cache, capfd, capfdbinary, caplog, capsys, capsysbinary, class_mocker, client, db, doctest_namespace, env, mocked_datetime_now, mocker, module_mocker, monkeypa
" tch, package_mocker, pytestconfig, record_property, record_testsuite_property, record_xml_attribute, recwarn, session_mocker, tmp_path, tmp_path_factory, tmpdir, tmpdir_factory
" >       use 'pytest --fixtures [testpath]' for help on them.
