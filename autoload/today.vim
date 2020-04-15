
let s:config = {}
let s:todo_states = [' ', 'i', 'x', 'p', 'c']
let s:new_todo = ' - [ ] '

function! today#GetConfig() abort
  if s:config == {}
    call s:loadConfig()
  endif
  return s:config
endfunction

function! s:loadConfig() abort
  let l:cmd = 'today config'
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

function! today#Toggle() abort
  let line = getline('.')

  if(match(line, '\[.\]') != -1)
    let states = copy(s:todo_states)
    for state in states
      if(match(line, '\[' . escape(state, '\') . '\]') != -1)
        let next_state = states[0]
        if index(states, state) < len(states) - 1
          let next_state = states[index(states, state) + 1]
        endif
        echo printf('state transition: %s => %s', state, next_state)
        let line = substitute(line, '\[' . escape(state, '\') . '\]', '[' . next_state . ']', '')
        break
      endif
    endfor
    call setline('.', line)
  endif
endf

function! today#Done() abort
  call today#Set('x')
endfunction

function! today#Set(state) abort
  let line = getline('.')

  if(match(line, '\[.\]') != -1)
    let line = substitute(line, '\[.\]', '[' . a:state . ']', '')
    call setline('.', line)
  endif
endfunction

function! today#Init() abort
  let l:cmd = 'today init'
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif
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

function! today#OpenToday() abort
  call s:ensureDir()
  if @% != 'today.md'
    execute "e" s:getToday()
  endif
" seems wrong
"  call s:insertInboxTodo('')
"  call feedkeys('A')
endfunction

function! today#Prompt() abort
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

function! today#Add(todo) abort
  call s:insertTodoUnderCursor(a:todo)
  call feedkeys('A')
endfunction

function! s:insertTodoUnderCursor(todo) abort
  " insert a new todo
  execute "normal! ^i".s:new_todo.a:todo."\<cr>\<esc>k"
endfunction

function! s:insertTodoInHeading(heading, todo) abort
  " insert a new todo
  execute "normal! gg/".a:heading."\<cr>jj^i".s:new_todo.a:todo."\<cr>\<esc>k"
endfunction

function! s:insertInboxTodo(todo) abort
  call s:insertTodoInHeading('# Inbox', a:todo)
endfunction

function! today#Split() abort
  call s:ensureDir()
  if @% != 'today.md'
    execute "split" s:getToday()
  endif
  call s:insertInboxTodo(todo)
  call feedkeys('A')
endfunction

function! today#Rollover() abort
  let l:cmd = 'today rollover'
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif

  execute ":e" s:getToday()
endfunction

function! today#NewFile() abort
  call inputsave()
  let name = input('New file name: ')
  call inputrestore()
  if name == ""
    return 
  endif
  let fname = name
  if name !~ '\.md$'
    let fname .= '.md'
  endif
  echom '\rname: ' . name
  execute ':e ' . s:getDir()  . '/' . fname
  execute 'normal! i# '. name . "\n\n".s:new_todo
endfunction

function! today#Refile() abort
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSinkRefile'), 'left': '25%'})
endfunction

function! s:fzfSinkRefile(arg) abort
  " delete to the 't' register and open file
  function! s:sinkWrapper(heading) closure
    execute 'delete t'
    execute 'w'
    execute 'e '. s:getFile(a:arg)
    call s:fzfSinkPasteToHeading(a:heading)
  endfunction
  call fzf#run({'source': 'today headings '.s:getFile(a:arg), 'sink': function('s:sinkWrapper'), 'left': '25%'})
  if has("nvim")
    call feedkeys('i')
  else
    startinsert
  endif
endfunction

function! s:fzfSinkPasteToHeading(heading) abort
  echom 'heading: '. a:heading
  let [lnum, col] = searchpos('^' . escape(a:heading, '\'), 'nw')
  " paste from the 't' register - see today#Refile()
  if (lnum > 0)
    execute ':'+ (lnum+1)
    normal! "tp
  endif
endfunction

function! today#Open() abort
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSink'), 'left': '25%'})
endfunction

function! s:fzfSink(arg) abort
  execute 'e '. s:getFile(a:arg)
  " insert a new todo on third line
  " call append(2, s:new_todo)
  " go to third line
  execute 3
  " enter insert mode at end of line
  " call feedkeys('A')
endfunction

" Find heading
function! today#Move() abort
  "let headings = today#ChooseHeading()
  let filename = expand('%:p') 
  return fzf#run({'source': 'today headings '.filename, 'sink': function('s:fzfSinkMoveToHeading'), 'left': '25%'})
endfunction

function! s:fzfSinkMoveToHeading(heading) abort
  echom 'heading: '. a:heading
  let [lnum, col] = searchpos('^' . escape(a:heading, '\'), 'nw')
  "echo 'moving to line ' . lnum
  if (lnum > 0)
    execute 'm ' . (lnum+1)
  else
    echo 'wat: heading not found'
    return
  endif
endfunction

" find headings
function! today#NewTodoForHeading() abort
  let filename = expand('%:p') 
  return fzf#run({'source': 'today headings '.filename, 'sink': function('s:fzfSinkHeading'), 'left': '25%'})
endfunction

function! s:fzfSinkHeading(arg) abort
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
