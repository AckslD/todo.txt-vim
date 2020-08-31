" Executes a function which might move the cursor and returns to the original
" position
function! todo#execute_and_return(function, ...)
    " Save the current position
    let l:curPos = getcurpos()
    call call(function, a:000)
    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])
endfunction
