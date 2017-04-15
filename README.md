# PySolve.vim - Python expression solver with insertion!

Credit to http://vim.wikia.com/wiki/Scientific_calculator for the idea.

## Usage:
Note: There are no default mappings.

#### Normal Mode:
`:PySolve <args>` - Insert solved python expresion, args, into buffer; don't store.<br>
`:PySolveSave <args>` - Insert solved python expresion, args, into buffer; save into register @m.<br>
`:PySolveView <args>` - Print solved python expression, args, as a message; dont't store.

#### Insert Mode:
PySolve → *<YOUR_KEY>* `<C-O>:call PySolve(0)<CR>`<br>
PySolveSave → *<YOUR_KEY>* `<C-O>:call PySolve(1)<CR>`<br>
PySolveView → *<YOUR_KEY>* `<C-O>:call PySolveView<CR>`<br>
