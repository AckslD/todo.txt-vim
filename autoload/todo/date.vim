" Checks if current todo under cursor is overdue
function! todo#date#is_current_overdue()
    let l:due_date = todo#date#get_due_date()
    if l:due_date == -1
        " No due date so not overdue
        return 0
    endif
    let l:due_date = join(split(l:due_date, '-'), '')
    return l:due_date < strftime("%Y%m%d")
endfunction

" Checks if todo at line number lnum is overdue
function! todo#date#is_todo_overdue(lnum)
    " Save the current position
    let l:curPos = getcurpos()

    call cursor(a:lnum, 1)
    let l:is_overdue = todo#date#is_current_overdue()

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return l:is_overdue
endfunction

" Returns due date (as string) of the current todo under cursor (-1 if none)
function! todo#date#get_due_date()
    return todo#todokeys#get("due")
endfunction
