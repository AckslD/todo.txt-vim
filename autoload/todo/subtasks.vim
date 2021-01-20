function! todo#subtasks#open()
    call todo#files#open("subtasks", "~/todo/subtasks/", ".todo.txt")
endfunction

function! todo#subtasks#pop()
    call todo#todokeys#pop("subtasks")
endfunction
