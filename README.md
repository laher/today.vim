# today.vim

todo manager in vim.

Use the following commands to open a markdown file and add a TODO entry (a 'checkbox' like `[ ]`/`[x]`)

```
:TodaySplit
:TodayPrompt
```

Either of these will add an entry in `g:today_dir` . '/today.md'.

today.vim is compatible with fzm.vim (a fuzzy menu system). 
Use via fzm is recommended, for usability. Otherwise just map some key combinations.

## Refiling entries

To refile an entry into `g:today_dir` . '/appointments.md'.

```
:TodayRefile appointments
```

## Config

Directory for todo files: `g:today_dir='~/today'`
