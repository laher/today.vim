# todo.vim

todo manager in vim.

Use the following commands to open a markdown file and add a TODO entry (a 'checkbox' like `[ ]`/`[X]`)

```
:TodoSplit
:TodoPrompt
```

Either of these will add an entry in `g:todo_dir` . '/inbox.md'.

todo.vim is compatible with fzm.vim (a fuzzy menu system). 
Use via fzm is recommended, for usability. Otherwise just map some key combinations.

## Refiling entries

To refile an entry into `g:todo_dir` . '/appointments.md'.

```
:TodoRefile appointments
```

## Config

Directory for todo files: `g:todo_dir='~/todo'`
