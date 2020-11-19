let b:current_context = ""
let b:current_project = ""
let b:current_due_date = ""
let b:curdir = expand('<sfile>:p:h')
let s:script_dir = b:curdir . "/../../syntax/python/"

function! todo#folding#escape_prefix(str, prefix)
    " Negative lookbehind to check if already escaped
    let l:neg_lookbehind = "\\(\\\\\\)\\@<!"
    return substitute(a:str, l:neg_lookbehind . a:prefix, "\\\\" . a:prefix, "g")
endfunction

function! todo#folding#set_focus_context(context)
    let b:current_context = todo#folding#escape_prefix(a:context, "@")
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_project(project)
    let b:current_project = todo#folding#escape_prefix(a:project, "+")
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_due_date(due_date)
    let b:current_due_date = a:due_date
    execute "normal! zxzM"
endfunction

function! todo#folding#toggle_focus_due_date()
    if len(b:current_due_date) > 0
        echo "Unfocus due date"
        call todo#folding#set_focus_due_date("")
        return
    endif
    " TODO Add check for load python etc
    " TODO python needed? Can also just compare with the date?
    python3 sys.argv = ["--focus"]
    execute "py3file " . s:script_dir. "todo.py"
    execute "normal! zxzM"
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
        call todo#folding#set_focus_context(l:tag)
    else
        let l:tag = l:projects[l:answer-len(l:contexts)-1]
        call todo#folding#set_focus_project(l:tag)
    endif
endfunction

function! todo#folding#get_focus_regex()
    return "\\v^[^xX]" . todo#folding#regex_all([b:current_project, b:current_context, b:current_due_date]) . "$"
endfunction

" Get the folding level of a line based on the current focused project and
" context
function! todo#folding#foldlevel(lnum)
    " TODO instead of building one big regex, we could also make use of
    " if-statements here?
    return 0 - match(getline(a:lnum),todo#folding#get_focus_regex())
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
    if a:tag_type ==# "project"
        let l:current_tag = b:current_project
        let l:SetFocusTag = function("todo#folding#set_focus_project")
    elseif a:tag_type ==# "context"
        let l:current_tag = b:current_context
        let l:SetFocusTag = function("todo#folding#set_focus_context")
    else
        echoerr "Unknown tag type: " . a:tag_type
        return
    endif
    if len(l:current_tag) > 0
        echo "Unfocus " . a:tag_type
        call l:SetFocusTag("")
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
            let l:tag = todo#folding#regex_all(l:tags)
        elseif l:answer == 2
            let l:tag = todo#folding#regex_any(l:tags)
        else
            let l:tag = l:tags[l:answer-3]
        endif
    else
        let l:tag = l:tags[0]
    endif
    call l:SetFocusTag(l:tag)
endfunction

" Returns a regex pattern matching if all the patterns in the list matches, in
" some order
" NOTE assuming very magic
function! todo#folding#regex_all(patterns)
    let l:regex_all = ""
    for pattern in a:patterns
        let l:regex_all = l:regex_all . "(.*" . pattern . ")@="
    endfor
    let l:regex_all = l:regex_all . ".*"
    return l:regex_all
endfunction

" Returns a regex pattern matching any of the pattern in a list
" NOTE assuming very magic
function! todo#folding#regex_any(patterns)
    let l:regex_any = ".*("
    let l:index = 0
    for pattern in a:patterns
        let l:regex_any = l:regex_any . pattern
        if l:index < len(a:patterns) - 1
            let l:regex_any = l:regex_any . "|"
        endif
        let l:index += 1
    endfor
    let l:regex_any = l:regex_any . ").*"
    return l:regex_any
endfunction
