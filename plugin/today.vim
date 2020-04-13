
nnoremap <buffer> <silent> <Plug>TodayPrompt :call today#prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodaySplit :call today#split()<cr>


if !hasmapto('<Plug>TodayPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodayPrompt
endif
if !hasmapto('<Plug>TodaySplit', 'n')
   nmap <buffer> <Leader>T <Plug>TodaySplit
endif

command -nargs=0 -buffer Today call today#Open()
command -nargs=0 -buffer TodayPrompt call today#Prompt()
command -nargs=0 -buffer TodaySplit call today#Split()
command -nargs=0 -buffer TodayRollover call today#Rollover()
command -nargs=0 -buffer TodayRefile call today#Refile()
command -nargs=0 -buffer TodayInstall call today#Install()
command -nargs=0 -buffer TodayUpdate call today#Update()
command -nargs=0 -buffer TodayFuzzy call today#FzTodo()


if &rtp =~ 'fzm.vim'
  call fzm#Add('Today', {'exec': 'call today#Open()'})
  call fzm#Add('Today: Prompt', {'exec': 'call today#Prompt()'})
  call fzm#Add('Today: Split', {'exec': 'call today#Split()'})
  call fzm#Add('Today: Rollover', {'exec': 'call today#Rollover()'})
  call fzm#Add('Today: Refile', {'exec': 'call today#Refile()', 'mode': 'insert', 'for': 'md'})
  call fzm#Add('Today: Chooser', {'exec': 'call today#FzTodo()', 'mode': 'insert'})
endif

