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


if &rtp =~ 'fuzzymenu.vim'
  call fuzzymenu#Add('Today', {'exec': 'call today#OpenToday()'})
  call fuzzymenu#Add('Today: Open', {'exec': 'call today#Open()'})
  call fuzzymenu#Add('Today: Prompt', {'exec': 'call today#Prompt()'})
  call fuzzymenu#Add('Today: Split', {'exec': 'call today#Split()'})
  call fuzzymenu#Add('Today: Rollover', {'exec': 'call today#Rollover()'})
  call fuzzymenu#Add('Today: File Chooser', {'exec': 'call today#FzTodo()', 'mode': 'insert'})
  call fuzzymenu#Add('Today: New File', {'exec': 'call today#NewFile()', 'mode': 'insert'})
  call fuzzymenu#Add('Today: Init', {'exec': 'call today#Init()'})

  """ Only for markdown files
  call fuzzymenu#Add('Today: Refile', {'exec': 'call today#Refile()', 'mode': 'insert', 'for': 'md'})
  call fuzzymenu#Add('Today: Toggle', {'exec': 'call today#Toggle()', 'for': 'md'})
endif

