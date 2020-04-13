command -nargs=0 Today call today#Open()
command -nargs=0 TodayPrompt call today#Prompt()
command -nargs=0 TodaySplit call today#Split()
command -nargs=0 TodayRollover call today#Rollover()
command -nargs=0 TodayInstall call today#exec#Install()
command -nargs=0 TodayUpdate call today#exec#Update()
command -nargs=0 TodayFuzzy call today#FzTodo()
command -nargs=0 TodayNewFile call today#NewFile()
command -nargs=0 TodayInit call today#Init()

""" TODO: move these definitions into ftplugin/md/today.vim ?
command -nargs=0 TodayRefile call today#Refile()
command -nargs=0 TodayToggle call today#Toggle()

nnoremap <buffer> <silent> <Plug>TodayPrompt :call today#Prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodaySplit :call today#Split()<cr>

if !hasmapto('<Plug>TodayPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodayPrompt
endif
if !hasmapto('<Plug>TodaySplit', 'n')
   nmap <buffer> <Leader>T <Plug>TodaySplit
endif


if &rtp =~ 'fzm.vim'
  call fzm#Add('Today', {'exec': 'call today#Open()'})
  call fzm#Add('Today: Prompt', {'exec': 'call today#Prompt()'})
  call fzm#Add('Today: Split', {'exec': 'call today#Split()'})
  call fzm#Add('Today: Rollover', {'exec': 'call today#Rollover()'})
  call fzm#Add('Today: File Chooser', {'exec': 'call today#FzTodo()', 'mode': 'insert'})
  call fzm#Add('Today: New File', {'exec': 'call today#NewFile()', 'mode': 'insert'})
  call fzm#Add('Today: Init', {'exec': 'call today#Init()'})

  """ Only for markdown files
  call fzm#Add('Today: Refile', {'exec': 'call today#Refile()', 'mode': 'insert', 'for': 'md'})
  call fzm#Add('Today: Toggle', {'exec': 'call today#Toggle()', 'for': 'md'})
endif

