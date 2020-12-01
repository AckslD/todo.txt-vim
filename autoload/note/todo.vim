let s:todo_paths = ["~/todo/todo.txt", "~/todo/subtasks/"]

" Add the current note to a todo
function! note#todo#add_to_todo()
    call fzf#run({
        \ 'source': 'rg -n --no-heading "" ' . join(s:todo_paths, ' '),
        \ 'sink': function('note#todo#handle_fzf_choice', ['a']),
        \})
endfunction

" Open a todo that links to the current note
function! note#todo#open_todo()
    let l:note_key = "note:" . expand("%:p")
    call fzf#run({
        \ 'source': 'rg -n --no-heading "' . l:note_key . '" ' . join(s:todo_paths, ' '),
        \ 'sink': function('note#todo#handle_fzf_choice', ['o']),
        \})
endfunction

" Handles the choice from the fzf calls
function! note#todo#handle_fzf_choice(action, todo_spec)
    let l:fields = split(a:todo_spec, ':')
    let l:todofilepath = l:fields[0]
    let l:linenum = l:fields[1]
    let l:notefilepath = expand("%:p")
    vsplit
    execute "edit " . l:todofilepath
    call cursor(l:linenum, 1)
    if a:action ==# 'o'
        " Do nothing
    elseif a:action ==# 'a'
        call todo#note#set(l:notefilepath)
        write
        quit
        echom "Added this note to todo in file: " . l:todofilepath
    else
        echoerr "Unknown action: " . a:action
    endif
endfunction
