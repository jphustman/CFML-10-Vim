" VIM filetype plugin file
" Language:	cfml
" Maintainer:	Jeremey Hustman
" Last Changed:	26 July 2012

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim







let &cpo = s:cpo_save
unlet s:cpo_save
