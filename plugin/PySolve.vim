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

  if strlen(exp) == 0 || exp =~ "<Esc>$"
    return
  endif

  if a:save
    " TODO: Allow register variation
    let result_register = 'm'
  else
    " Original register contents will be preserved
    " so the particular register is unimportant
    let result_register = 'm'
  endif

  let pysolve_command = s:pysolve_python.'print('.exp.')'

  redir => result
  exec pysolve_command
  redir END

  " Remove extra starting byte and
  " leading/trailing whitespace
  let result = Strip(strpart(result, 1))

  if strlen(result) > 0 && result !~# s:python_error_message
    if a:save
      call setreg(result_register, result)
    else
      let old_register_content = getreg(result_register, 1)
      call setreg(result_register, result)
      silent exec "normal! \"".result_register."Pl"
      call setreg(result_register, old_register_content)
    endif
  endif
endfunction


" Substitute removes leading and trailing whitespace
" Credit to: http://stackoverflow.com/a/4479072
function! Strip(input_string)
  return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction
