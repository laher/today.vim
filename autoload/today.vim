
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
endfunction

function! today#Prompt()
  call s:ensureDir()
  let curfile = @%
  if curfile != 'today.md'
    execute "split" s:getToday()
  endif
  call inputsave()
  let name = input('Enter todo: ')
  call inputrestore()
  " insert a new todo on second line
  call append(1, ' - [ ] ' . name)
  if curfile != 'today.md'
    hide
  endif
endfunction

function! today#Split()
  call s:ensureDir()
  if @% != 'today.md'
    execute "split" s:getToday()
  endif
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

function! today#Rollover()
  let l:cmd = printf('today rollover')
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif

  execute ":e"
endfunction

function! today#Refile()
  "let name = input('Move to file: ')
  execute 'delete t'
  execute 'w'
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSinkRefile'), 'left': '25%'})
endfunction

function! today#FzTodo()
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSink'), 'left': '25%'})
endfunction

function! s:fzfSinkRefile(arg)
  execute 'e '. s:getFile(a:arg)
  execute 2
  normal! "tp
  call feedkeys('A')
endfunction

function! s:fzfSink(arg)
  execute 'e '. s:getFile(a:arg)
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
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
" Refile
" Tagging
"
"
function! TodoM()
  let b:lines=[]
  while matchstr('^#\+ ', 'n')
    call add(b:lines, m)
  endwhile
  call fzf#vim#complete(b:lines)
endfunction

function! today#Update()
  call s:install_binary(1)
endfunction

function! today#Install()
  call s:install_binary(0)
endfunction

function! s:install_binary(update)
  let today_addr = 'github.com/laher/today'
  let argv = ['go', 'get']
  if a:update
    call add(argv, '-u')
  endif
  let argv += [ '-v', today_addr]
  call today#exec#run_maybe_async(argv)
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
