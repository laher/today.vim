command -nargs=0 Today call today#OpenToday()
command -nargs=0 TodayPrompt call today#Prompt()
command -nargs=0 TodaySplit call today#Split()
command -nargs=0 TodayRollover call today#Rollover()
command -nargs=0 TodayInstall call today#exec#Install()
command -nargs=0 TodayUpdate call today#exec#Update()
command -nargs=0 TodayOpen call today#Open()
command -nargs=0 TodayNewFile call today#NewFile()
command -nargs=0 TodayInit call today#Init()


nnoremap <buffer> <silent> <Plug>TodayPrompt :call today#Prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodaySplit :call today#Split()<cr>

if !hasmapto('<Plug>TodayPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodayPrompt
endif
if !hasmapto('<Plug>TodaySplit', 'n')
   nmap <buffer> <Leader>T <Plug>TodaySplit
endif


if exists('g:fuzzymenu_loaded')
  call fuzzymenu#AddAll({
        \ 'Today': {'exec': 'call today#OpenToday()'},
        \ 'Open another note': {'exec': 'call today#Open()'},
        \ 'Prompt': {'exec': 'call today#Prompt()'},
        \ 'Split': {'exec': 'call today#Split()'},
        \ 'Rollover': {'exec': 'call today#Rollover()'},
        \ 'Init': {'exec': 'call today#Init()'},
      \ },
      \ {'tags': ['today']})
  call fuzzymenu#AddAll({
        \ 'File Chooser': {'exec': 'call today#FzTodo()'},
        \ 'New File': {'exec': 'call today#NewFile()'},
      \ },
      \ {'after': 'call fuzzymenu#InsertMode()', 'tags': ['today', 'fzf']})

  "" Only for markdown files
  call fuzzymenu#Add('Refile', {'exec': 'call today#Refile()', 'after': 'call fuzzymenu#InsertMode()', 'for': {'ft': 'md'}, 'tags': ['today', 'fzf']})
  call fuzzymenu#Add('Toggle', {'exec': 'call today#Toggle()', 'for': {'ft': 'md'}, 'tags': ['today']})
endif

