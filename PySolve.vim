" PySolve.vim - Python expression solver with insertion!
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
" Normal Mode:
" :PySolve <args>     - Insert solved python expresion, args, into buffer;
"                       don't store.
" :PySolveSave <args> - Insert solved python expresion, args, into buffer;
"                       save into register @m.
" :PySolveView <args> - Print solved python expression, args, as a message;
"                       dont't store.
"
" Insert Mode: (No default mappings)
" PySolve     - <YOUR_KEY> <C-O>:call PySolve(0)<CR>
" PySolveSave - <YOUR_KEY> <C-O>:call PySolve(1)<CR>
" PySolveView - <YOUR_KEY> <C-O>:call PySolveView<CR>
" ------------------------------------------------------------------------------

" Normal mode command
:command! -nargs=+ PySolve call PySolve(0, <q-args>)
:command! -nargs=+ PySolveSave call PySolve(1, <q-args>)
:command! -nargs=+ PySolveView :py print <args>

" Python Imports
:py from math import *


" Main expression evaluator
function! PySolve(save, ...)

  " Either ask for the expression or use the one already provided
  if !a:0
    let exp = Strip(input('Python Exp: '))
  else
    let exp = a:1
  endif

  if exp !~ "<Esc>"
    " TODO: Allow register variation
    let mReg = @m "Store the old contents of the m register
    redir @m
    execute "py print " . exp
    redir END
    call PasteAndMerge("m")
    if !a:save
      let @m = mReg "Restore the contents of the m register
    endif
  endif
endfunction

" Helper function to paste from a register and merge the lines.
function! PasteAndMerge(reg)
  silent execute "normal! \"" . a:reg . "pj:le\<enter>kgJ"
endfunction

" Substitute removes leading and trailing whitespace
" Credit to: http://stackoverflow.com/a/4479072
function! Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
