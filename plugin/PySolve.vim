" PySolve.vim - Python expression solver with insertion!
"
" Credit to http://vim.wikia.com/wiki/Scientific_calculator for the idea.
"
" Copyright 2017 Ronald Gil <me@ronaldgil.com>
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
  let s:pysolve_python = ':py3 '
elseif has('python')
  let s:pysolve_python = ':py '
else
  echohl WarningMsg
  echom 'PySolve requires python support.'
  echohl None
  finish
endif


" Normal mode command
:command! -nargs=+ PySolve call PySolve(0, <q-args>)
:command! -nargs=+ PySolveSave call PySolve(1, <q-args>)
:command! -nargs=+ PySolveView exec s:pysolve_python . "print(<args>)"

" Python Imports
exec s:pysolve_python 'from math import *'


" Constants
let s:input_prompt = 'Python Exp: '
let s:python_error_message = 'Error detected while processing'


" Main expression evaluator
function! PySolve(save, ...)
  " Either ask for the expression or use the one already provided
  if !a:0
    let exp = Strip(input(s:input_prompt))
  else
    let exp = a:1
  endif

  " Do nothing if the escape key was pressed
  if exp =~ "<Esc>$"
    return
  endif

  " TODO: Allow register variation
  let result_register = 'm'
  let old_register_content = GetRegister(result_register)

  let pysolve_command = s:pysolve_python.'print('.exp.')'
  call Redir(result_register, pysolve_command)

  let result = GetRegister(result_register)
  let result_len = strlen(Strip(result))

  let success = 0
  " Needs to be > 1 because empty case contains a ^J character
  " Also don't paste if there was an error
  if result_len > 1 && result !~# s:python_error_message
    call PasteAndMerge(result_register, result_len)
    let success = 1
  endif

  if !a:save || !success
    call SetRegister(result_register, old_register_content)
  endif
endfunction



function! GetRegister(register)
  exec 'let contents = @'.a:register
  return contents
endfunction

function! SetRegister(register, contents)
  exec 'let @'.a:register.' = a:contents'
endfunction

" Helper function to paste from a register and merge the lines.
" The strlen argument is used to get the cursor to the end of the pasted
" input.
function! PasteAndMerge(register, strlen)
  if a:strlen " Ignore the empty string case
    silent execute "normal! \"" . a:register . "pj:le\<enter>kgJ" . a:strlen . 'l'
  endif
endfunction

" Adapted from: https://gist.github.com/intuited/362802
function! Redir(register, command)
  exec 'redir @'.a:register
  exec a:command
  redir END
endfunction

" Substitute removes leading and trailing whitespace
" Credit to: http://stackoverflow.com/a/4479072
function! Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
