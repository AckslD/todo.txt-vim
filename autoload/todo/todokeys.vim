" Gets string between markers
function todo#todokeys#get_str_markers(mark1, mark2)
    return getline(a:mark1)[getpos(a:mark1)[2]-1:getpos(a:mark2)[2]-1]
endfunction

" Asks for a key if not given
function! todo#todokeys#query_key(key, action)
    " TODO query existing keys
    let l:currentkeys = todo#todokeys#current_keys()
    if len(l:currentkeys) ==# 0
        return a:key
    endif
    if strlen(a:key) ==# 0
        let l:querylst = ["Select key to " . a:action . ":"]
        let l:index = 1
        for key in l:currentkeys
            call add(l:querylst, l:index . ". " . key)
            let l:index += 1
        endfor
        let l:answer = inputlist(l:querylst)
        if l:answer <=# 0
            return -1
        endif
        return l:currentkeys[l:answer-1]
    else
        return a:key
    endif
endfunction

" Returns the current keys
function! todo#todokeys#current_keys()
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"

    "Find all keys
    let l:keys = []
    while search("\\S*:", "W", line("."))
        execute "normal! mat:mb"
        call add(l:keys, todo#todokeys#get_str_markers("'a", "'b"))
    endwhile

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:keys
endfunction

" Sets the value of a key (adds if not there and replaces value otherwise)
function! todo#todokeys#set(key, value)
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if key already exists
    if search("\\s*" . a:key . ":", "e", line("."))
        execute "normal! lcE" . a:value . "\<esc>"
    else
        execute "normal! A " . a:key . ":" . a:value . "\<esc>"
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])
endfunction

" Removes a key, and its value if it exists
function! todo#todokeys#pop(key)
    let l:key = todo#todokeys#query_key(a:key, "delete")
    if l:key ==# -1
        return 0
    endif

    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if key exists
    if search("\\s*" . l:key . ":", "", line("."))
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
    if search("\\s*" . a:key . ":", "e", line("."))
        execute "normal! lmaEmb"
        let l:value = todo#todokeys#get_str_markers("'a", "'b")
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
    if search("\\s*" . a:key . ":", "", line("."))
        let l:has = 1
    else
        let l:has = 0
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:has
endfunction
