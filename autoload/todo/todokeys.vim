" Sets the value of a key (adds if not there and replaces value otherwise)
function! todo#todokeys#set(key, value)
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if key already exists
    if search(" " . a:key . ":", "e", line("."))
        execute "normal! lcE" . a:value . "\<esc>"
    else
        execute "normal! A " . a:key . ":" . a:value . "\<esc>"
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])
endfunction

" Removes a key, and its value if it exists
function! todo#todokeys#pop(key)
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if key exists
    if search(" " . a:key . ":", "", line("."))
        execute "normal! dE" . "\<esc>"
        let l:result = 1
    else
        let l:result = 0
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:result
endfunction

" Returns the value of a key if it exists, otherwise returns -1
function! todo#todokeys#get(key)
    " Save the current position
    let l:curPos = getcurpos()
    " Save the a and b registers
    let l:aPos = getpos("'a")
    let l:bPos = getpos("'b")

    execute "normal! ^"
    " Check if key exists
    if search(" " . a:key . ":", "e", line("."))
        execute "normal! lmaEmb"
        let l:value = getline("'a")[getpos("'a")[2]-1:getpos("'b")[2]]
    else
        let l:value = -1
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])
    " Set the a and b registers back
    call setpos("'a", l:aPos)
    call setpos("'b", l:bPos)

    return l:value
endfunction

" Checks if key exists
function! todo#todokeys#has(key)
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if key exists
    if search(" " . a:key . ":", "", line("."))
        let l:has = 1
    else
        let l:has = 0
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:has
endfunction
