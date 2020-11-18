let s:current_context = "\\@work"
let s:current_project = ""
let s:current_due_date = ""
let b:curdir = expand('<sfile>:p:h')
let s:script_dir = b:curdir . "/../../syntax/python/"

function! todo#folding#set_focus_context(context)
    let s:current_context = a:context
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_project(project)
    let s:current_project = a:project
    execute "normal! zxzM"
endfunction

function! todo#folding#set_focus_due_date(due_date)
    let s:current_due_date = a:due_date
    execute "normal! zxzM"
endfunction

function! todo#folding#toggle_focus_due_date()
    if len(s:current_due_date) > 0
        echo "Unfocus due date"
        call todo#folding#set_focus_due_date("")
        return
    endif
    " TODO Add check for load python etc
    python3 sys.argv = ["--focus"]
    execute "py3file " . s:script_dir. "todo.py"
    execute "normal! zxzM"
endfunction

function! todo#folding#get_focus_regex()
    return "\\v^[^xX]" . todo#folding#regex_all([s:current_project, s:current_context, s:current_due_date]) . "$"
endfunction

" Get the folding level of a line based on the current focused project and
" context
function! todo#folding#foldlevel(lnum)
    return 0 - match(getline(a:lnum),todo#folding#get_focus_regex())
    " /\v^[^xX](.*)@=(.*Make)@=(.*from)@=.* 
    " /\v^[^xX](.*)@=(.*@work)@=.*$
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
        let l:current_tag = s:current_project
        let l:SetFocusTag = function("todo#folding#set_focus_project")
    elseif a:tag_type ==# "context"
        let l:current_tag = s:current_context
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
            echo "No choice"
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
