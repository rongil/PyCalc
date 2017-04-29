" PySolve.vim - Python expression solver with insertion!
"
" Credit to http://vim.wikia.com/wiki/Scientific_calculator for the idea.
"
" Copyright 2017 Ronald Gil <rongil@mit.edu>
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

" Set python version
if has('python3')
  let s:python_version = 3
elseif has('python')
  let s:python_version = 2
else
  throw 'PySolve requires python.'
endif


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
    let mReg = @m " Store the old contents of the m register
    redir @m
    execute "py print " . exp
    redir END

    let result_len = strlen(Strip(@m))
    let success = 0

    " Needs to be > 1 because empty case contains a ^J character
    " Also don't paste if there was an error
    if result_len > 1 && @m !~# "Error detected while processing"
      call PasteAndMerge("m", result_len)
      let success = 1
    endif

    if !a:save || !success
      let @m = mReg " Restore the contents of the m register
    endif
  endif
endfunction

" Helper function to paste from a register and merge the lines.
" The strlen argument is used to get the cursor to the end of the pasted
" input.
function! PasteAndMerge(reg, strlen)
  if a:strlen " Ignore the empty string case
    silent execute "normal! \"" . a:reg . "pj:le\<enter>kgJ" . a:strlen . "l"
  endif
endfunction

" Substitute removes leading and trailing whitespace
" Credit to: http://stackoverflow.com/a/4479072
function! Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
