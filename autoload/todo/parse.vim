" Gets string between markers
function todo#parse#get_str_markers(mark1, mark2)
    return getline(a:mark1)[getpos(a:mark1)[2]-1:getpos(a:mark2)[2]-1]
endfunction

" Helper function to retreive content of current line
" The `regex` should be such that when searched for,
" one ends up at the start of the element we're looking for.
" The `motion` should then take us from the start to the end.
" For example to find project tags use:
"   regex="\\s@\\zs\\S\\+\\ze\\(\\s\\|\\n\\)"
"   motion="e"
function! todo#parse#get_elements(regex, motion)
    " Save the current position
    let l:curPos = getcurpos()
    " Save the a and b registers
    let l:aPos = getpos("'a")
    let l:bPos = getpos("'b")

    execute "normal! ^"

    "Find all elements
    let l:elements = []
    while search(a:regex, "W", line("."))
        execute "normal! ma" . a:motion . "mb"
        call add(l:elements, todo#parse#get_str_markers("'a", "'b"))
    endwhile

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])
    " Set the a and b registers back
    call setpos("'a", l:aPos)
    call setpos("'b", l:bPos)

    return l:elements
endfunction

" Helper function to get the first occurence of an element
" similiar to get_elements above
" returns -1 if it doesn't exist
function! todo#parse#get_first(regex, motion)
    let l:elements = todo#parse#get_elements(a:regex, a:motion)
    if len(l:elements) == 0
        return -1
    else
        return l:elements[0]
    endif
endfunction

" Helper function to check if element exists
" similiar to get_elements above
function! todo#parse#has(regex, motion)
    let l:elements = todo#parse#get_elements(a:regex, a:motion)
    if len(l:elements) == 0
        return 0
    else
        return 1
    endif
endfunction

" Helper function to pop an element if it exists
" similiar to get_elements above
function! todo#parse#pop(regex, motion)
    " Save the current position
    let l:curPos = getcurpos()

    execute "normal! ^"
    " Check if element exists
    if search(a:regex, "", line("."))
        execute "normal! d" . a:motion . "\<esc>"
        let l:result = 1
    else
        let l:result = 0
    endif

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:result
endfunction
