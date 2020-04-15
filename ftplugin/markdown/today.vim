""" TODO: move these definitions into ftplugin/md/today.vim ?
command! -nargs=0 TodayRefile call today#Refile()
command! -nargs=0 TodayToggle call today#Toggle()
command! -nargs=0 TodayDone call today#Done()

nmap <LocalLeader>r :call today#Rollover()<CR>
nmap <LocalLeader>f :call today#Refile()<CR>
nmap <LocalLeader>x :call today#Done()<CR>
nmap <LocalLeader>a :call today#Add("")<CR>
nmap <LocalLeader>t :call today#Toggle()<CR>
nmap <LocalLeader>m :call today#Move()<CR>
nmap <LocalLeader>j :call today#Down()<CR>
nmap <LocalLeader>k :call today#Up()<CR>
""" date heading
nmap <LocalLeader>d i## <C-R>=strftime("%Y-%m-%d")<CR><CR><CR> - [ ]  
