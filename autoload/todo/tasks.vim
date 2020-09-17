" Inserts priority and date in the current cursor position
function! todo#tasks#insert_new()
    execute "normal! \<esc>i(A) " . strftime("%Y-%m-%d") . " "
endfunction

" Inserts new task below
function! todo#tasks#insert_new_below()
    execute "normal! o"
    call todo#tasks#insert_new()
endfunction

" Inserts new task above
function! todo#tasks#insert_new_above()
    execute "normal! O"
    call todo#tasks#insert_new()
endfunction
