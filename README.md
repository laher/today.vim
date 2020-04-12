# today.vim

today-focused todo list in vim.

## Install

Install the plugin [optionally with async.vim] in the usual way (depending on what plugin manager you use).

DEPENDENCY NOTE: `today.vim` depends on a go binary `today`. For now you need `go` on your system to install it (I'll precompile binaries in future)

For example, using vim-plug:

```viml
Plug 'prabirshrestha/async.vim'
Plug 'laher/today.vim', { 'do': ':TodayUpdate' }
```

## Usage

Use one of the following commands to open the 'today' markdown file and add a TODO entry (a 'checkbox' like `[ ]`/`[x]`)

```
:Today                  """ <- just open the file
:TodaySplit             """ <- split-open the file
:TodayPrompt            """ <- add an entry from a prompt 
```

These will add an entry in `g:today_dir` . '/today.md'.


### Usage with FZF/FZM

`today.vim` is compatible with `fzm.vim` (a fuzzy menu system). 
Use via fzm is recommended, for learnability. 
Otherwise, I recommend just mapping some key combinations.

For installing today.vim alongside fzf/fzm:

```viml
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'laher/fzm.vim'
Plug 'prabirshrestha/async.vim'
Plug 'laher/today.vim', { 'do': ':TodayUpdate' }
```

## Refiling entries

To refile an entry into `g:today_dir` . '/appointments.md'.

```
:TodayRefile appointments
```

## Config

Directory for todo files: `g:today_dir='~/today'`
