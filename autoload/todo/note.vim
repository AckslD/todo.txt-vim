function! todo#note#open()
    call todo#files#open("note", "~/.notes/", ".md")
endfunction

function! todo#note#set(filepath)
    call todo#todokeys#set("note", a:filepath)
endfunction
