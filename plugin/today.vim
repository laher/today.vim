command -nargs=0 Today call today#Open()
command -nargs=0 TodayPrompt call today#Prompt()
command -nargs=0 TodaySplit call today#Split()
command -nargs=0 TodayRollover call today#Rollover()
command -nargs=0 TodayRefile call today#Refile()
command -nargs=0 TodayInstall call today#exec#Install()
command -nargs=0 TodayUpdate call today#exec#Update()
command -nargs=0 TodayFuzzy call today#FzTodo()

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
  call fzm#Add('Today: Refile', {'exec': 'call today#Refile()', 'mode': 'insert', 'for': 'md'})
  call fzm#Add('Today: Chooser', {'exec': 'call today#FzTodo()', 'mode': 'insert'})
endif

