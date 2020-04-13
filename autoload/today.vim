
let s:config = {}

function! today#GetConfig()
  if s:config == {}
    call s:loadConfig()
  endif
  return s:config
endfunction

function! s:loadConfig()
  let l:cmd = printf('today config')
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif

  silent! let result = json_decode(l:out)

  " We want to output the error message in case the result isn't a JSON
  if type(result) != type({})
    call s:handle_errors(l:out)
    return
  endif
  let s:config = result
  return result
endfunction

function! s:getToday() abort
  return today#GetConfig().today
endfunction

function! s:getFile(name) abort
  return today#GetConfig().base . '/' . a:name
endfunction

function! s:getDir() abort
  return today#GetConfig().base 
endfunction

function! s:ensureDir() abort
  let dir = s:getDir()
  if !isdirectory(dir)
      call mkdir(dir, "p")
  endif
endfunction

function! today#Open()
  call s:ensureDir()
  if @% != 'today.md'
    execute "e" s:getToday()
  endif
  call s:insertInboxTodo('')
  call feedkeys('A')
endfunction

function! today#Prompt()
  call s:ensureDir()
  let curfile = @%
  if curfile != 'today.md'
    execute "split" s:getToday()
  endif
  call inputsave()
  let todo = input('Enter todo: ')
  call inputrestore()
  call s:insertInboxTodo(todo)
  if curfile != 'today.md'
    execute 'w'
    hide
  endif
endfunction

function! s:insertTodoInHeading(heading, todo) 
  " insert a new todo
  execute "normal! gg/".a:heading."\<cr>jj^i- [ ] ".a:todo."\<cr>\<esc>k"
endfunction

function! s:insertInboxTodo(todo) 
  call s:insertTodoInHeading('# Inbox', a:todo)
endfunction

function! today#Split()
  call s:ensureDir()
  if @% != 'today.md'
    execute "split" s:getToday()
  endif
  call s:insertInboxTodo(todo)
  call feedkeys('A')
endfunction

function! today#Rollover()
  let l:cmd = printf('today rollover')
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif

  execute ":e" s:getToday()
endfunction

function! today#Refile()
  " delete to the 't' register
  execute 'delete t'
  execute 'w'
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSinkRefile'), 'left': '25%'})
endfunction

function! today#FzTodo()
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSink'), 'left': '25%'})
endfunction

function! s:fzfSinkRefile(arg)
  execute 'e '. s:getFile(a:arg)
  execute 3
  " paste from the 't' register - see today#Refile()
  normal! "tp
  call feedkeys('A')
endfunction

function! s:fzfSink(arg)
  execute 'e '. s:getFile(a:arg)
  " insert a new todo on third line
  call append(2, ' - [ ] ')
  " go to third line
  execute 3
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

" Find heading
function! today#MoveToHeading()
  let name = input('Move to heading: ')
  let [lnum, col] = searchpos('^#\+ ' . name, 'n')
  if (lnum > 0)
    execute 'm ' . lnum
  else
    echo ''
    echo 'not found'
  endif
endfunction

" find headings
function! today#ChooseHeading()
  let b:lines=[]
  let flags = "cW"
  norm! gg
  while search("^#", flags) != 0
      call add(b:lines, getline("."))
      let flags = "W"
  endwhile
  call fzf#run({'source': b:lines, 'sink': function('s:fzfSinkHeading'), 'left': '25%'})
endfunction

function! s:fzfSinkHeading(arg)
  echom 'heading: '. a:arg
  call s:insertTodoInHeading(a:arg, ' -  [ ] ')
endfunction


function! s:handle_errors(content) abort
  let l:lines = split(a:content, '\n')
  let l:errors = []
  for l:line in l:lines
    let l:tokens = matchlist(l:line, '^\(.\{-}\):\(\d\+\):\(\d\+\)\s*\(.*\)')
    if empty(l:tokens)
      continue
    endif
    call add(l:errors,{
          \'filename': l:tokens[1],
          \'lnum':     l:tokens[2],
          \'col':      l:tokens[3],
          \'text':     l:tokens[4],
          \ })
  endfor

  if len(l:errors)
    call setloclist(0, l:errors, 'r')
    call setloclist(0, [], 'a', {'title': 'Format'})
    lopen
  else
    echomsg join(l:lines, "\n")
  endif
endfunction
