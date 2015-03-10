" PyCalc.vim - Python expression solver commands/shortcuts!
"
" Credit to http://vim.wikia.com/wiki/Scientific_calculator for the idea.
"
" Copyright 2015 Ronald Gil <rongil@mit.edu>
"
" Distributed under the terms of the Vim license. See ":help license" for
" details.
"
" Usage:
" ==============================================================================
" Insert Mode:
" <C-b> - Insert solved inputted python expression, into buffer; don't store.
" <C-B> - Insert solved inputted python expression, into buffer;
"         save into register @m.
" Normal Mode:
" :PyCalc <args> - Insert solved python expresion, args, into buffer;
"                  don't store.
" :PyCalcSave <args> - Insert solved python expresion, args, into buffer;
"                      save into register @m.
" :PyCalcView <args> - Print solved python expression, args, as a message;
"                      dont't store.
" ------------------------------------------------------------------------------

" Normal mode command
:command! -nargs=+ PyCalc call PyCalc(0, <q-args>)
:command! -nargs=+ PyCalcSave call PyCalc(1, <q-args>)
:command! -nargs=+ PyCalcView :py print <args>

" Insert mode shortcut
:imap <C-b> <C-O>:call PyCalc(0)<CR>
:imap <C-B> <C-O>:call PyCalc(1)<CR>

" Python Imports
:py from math import *


" Main expression evaluator
function! PyCalc(save, ...)

  " Either ask for the expression or use the one already provided
  if a:0 == 0
    let exp = Strip(input('Python Exp: '))
  else
    let exp = a:1
  endif

  if exp !~ "<Esc>"
    let mReg = @m "Store the old contents of the m register
    redir @m
    execute "py print " . exp
    redir END
    call PasteAndMerge("m")
    if a:save == 0
      let @m = mReg "Restore the contents of the m register
    endif
  endif
endfunction

" Helper function to paste from a register and merge the lines.
function! PasteAndMerge(reg)
  silent execute "normal! \"" . a:reg . "p\<S-J>l\"_dF\<space>"
endfunction

" Substitute removes leading and trailing whitespace
" Credit to: http://stackoverflow.com/a/4479072
function! Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
