function! todo#subtasks#open()
    call todo#files#open("subtasks", g:todo_root_folder . "/subtasks/", ".todo.txt")
endfunction

function! todo#subtasks#pop()
    call todo#todokeys#pop("subtasks")
endfunction
