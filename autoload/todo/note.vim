function! todo#note#open()
    " TODO dir from environment variable
    call todo#files#open("note", g:todo_root_folder . "/notes/", ".md")
endfunction

function! todo#note#set(filepath)
    call todo#todokeys#set("note", a:filepath)
endfunction

function! todo#note#pop()
    call todo#todokeys#pop("note")
endfunction
