
function! todo#folding#set_focus_context(all, contexts)
    let b:focus_contexts = {"all": a:all, "tags": a:contexts}
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_project(all, projects)
    let b:focus_projects = {"all": a:all, "tags": a:projects}
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_due_date(focus)
    let b:focus_due_date = a:focus
    execute "normal! zxzM"
endfunction

function! todo#folding#init_buffer()
    let l:initial_contexts = []
    if exists("g:todo_focus_initial_contexts")
        l:initial_contexts = g:todo_focus_initial_contexts
    endif
    if ! exists("b:focus_contexts")
        let b:focus_contexts = {"all": 1, "contexts": l:initial_contexts}
    endif

    let l:initial_projects = []
    if exists("g:todo_focus_initial_projects")
        l:initial_projects = g:todo_focus_initial_projects
    endif
    if ! exists("b:focus_projects")
        let b:focus_projects = {"all": 1, "tags": l:initial_projects}
    endif
    if ! exists("b:focus_due_date")
        let b:focus_due_date = 0
    endif
endfunction

function! todo#folding#get_current_focus_str()
    call todo#folding#init_buffer()
    return s:get_current_tags_str('c', b:focus_contexts) . " " . s:get_current_tags_str('p', b:focus_projects)
endfunction

function! s:get_current_tags_str(type, focus)
    if len(a:focus.tags) == 0
        return ""
    elseif len(a:focus.tags) == 1
        let l:str = a:focus.tags[0]
    else
        if a:focus.all
            let l:str = "all("
        else
            let l:str = "any("
        endif
        let l:str = l:str . join(a:focus.tags, ',') . ')'
    endif
    return a:type . ':' . l:str
endfunction

function! todo#folding#toggle_focus_due_date()
    call todo#folding#init_buffer()
    call todo#folding#set_focus_due_date(!b:focus_due_date)
endfunction

function! todo#folding#focus_query_tag()
    let l:querylst = ["Pick contex/project to focus on:"]
    let l:index = 1
    let l:contexts = todo#tags#get_all_tags("context")
    let l:projects = todo#tags#get_all_tags("project")
    for context in l:contexts
        call add(l:querylst, l:index . ". " . context)
        let l:index += 1
    endfor
    for project in l:projects
        call add(l:querylst, l:index . ". " . project)
        let l:index += 1
    endfor
    let l:answer = inputlist(l:querylst)
    if l:answer <=# 0
        echo "\nNo choice"
        return -1
    endif
    if l:answer < len(l:contexts)
        let l:tag = l:contexts[l:answer-1]
        call todo#folding#set_focus_context(1, [l:tag])
    else
        let l:tag = l:projects[l:answer-len(l:contexts)-1]
        call todo#folding#set_focus_project(1, [l:tag])
    endif
endfunction

" Get the folding level of a line based on the current focused project and
" context
function! todo#folding#foldlevel(lnum)
    call todo#folding#init_buffer()
    let l:foldlevel = 0
    " Completed
    if match(getline(a:lnum), "^[xX]\\ ") == 0
        return 1
    endif
    " Due date
    if b:focus_due_date
        if ! todo#date#is_todo_overdue(a:lnum)
            return 1
        endif
    endif
    " Focused contexts and projects
    for focus in [b:focus_contexts, b:focus_projects]
        if ! focus.all && len(focus.tags) > 0
            let l:foldlevel = 1
        endif
        for tag in focus.tags
            if focus.all
                if match(getline(a:lnum), tag) == -1
                    return 1
                endif
            else
                if match(getline(a:lnum), tag) != -1
                    let l:foldlevel = 0
                    break
                endif
            endif
        endfor
        if l:foldlevel == 1
            return 1
        endif
    endfor
endfunction

" Toggle focus to current project under line
function! todo#folding#toggle_focus_project()
    call todo#folding#toggle_focus_tag("project")
endfunction

" Toggle focus to current context under line
function! todo#folding#toggle_focus_context()
    call todo#folding#toggle_focus_tag("context")
endfunction

" Toggle focus on project or context at current line
function! todo#folding#toggle_focus_tag(tag_type)
    call todo#folding#init_buffer()
    if a:tag_type ==# "project"
        let l:focus_tags = b:focus_projects
        let l:SetFocusTag = function("todo#folding#set_focus_project")
    elseif a:tag_type ==# "context"
        let l:focus_tags = b:focus_contexts
        let l:SetFocusTag = function("todo#folding#set_focus_context")
    else
        echoerr "Unknown tag type: " . a:tag_type
        return
    endif
    if len(l:focus_tags.tags) > 0
        echo "Unfocus " . a:tag_type
        call l:SetFocusTag(1, [])
        return
    endif
    let l:tags = todo#tags#get_current_tags(a:tag_type)
    if len(l:tags) == 0
        echo "No " . a:tag_type . " to focus on"
        return
    endif
    if len(l:tags) > 1
        let l:querylst = ["Multiple " . a:tag_type . "s, which to focus on:", "1. all", "2. any"]
        let l:index = 3
        for tag in l:tags
            call add(l:querylst, l:index . ". " . tag)
            let l:index += 1
        endfor
        let l:answer = inputlist(l:querylst)
        if l:answer <=# 0
            echo "\nNo choice"
            return -1
        endif
        if l:answer == 1
            let l:all = 1
        elseif l:answer == 2
            let l:all = 0
        else
            let l:tags = [l:tags[l:answer-3]]
            let l:all = 1
        endif
    else
        let l:all = 1
    endif
    call l:SetFocusTag(l:all, l:tags)
endfunction
