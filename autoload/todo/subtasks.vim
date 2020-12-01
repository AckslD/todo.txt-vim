function! todo#subtasks#open()
    call todo#files#open("subtasks", "~/todo/subtasks/", ".txt")
endfunction

function! todo#subtasks#pop()
    call todo#todokeys#pop("subtasks")
endfunction
