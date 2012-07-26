set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

    if !has('gui')
"set term=$TERM " Make arrow and other keys work
    endif
    filetype plugin indent on " Automatically detect file types.
    syntax on " syntax highlighting
    set mouse=a " automatically enable mouse usage
    scriptencoding utf-8
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
" always switch to the current file directory.

" set autowrite " automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT " abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " better unix / windows compatibility
    set virtualedit=onemore " allow for cursor beyond last character
    set history=1000 " Store a ton of history (default is 20)
    set spell " spell checking on
    set hidden " allow buffer switching without saving




" Formatting   {
    set nowrap " wrap long lines
    set autoindent " indent at the same level of the previous line
    set shiftwidth=4 " use indents of 4 spaces
    set expandtab " tabs are spaces, not tabs
    set tabstop=4 " an indentation every four columns
    set softtabstop=4 " let backspace delete indent
"set matchpairs+=<:> " match, to be used with %
    set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/ " auto format comment blocks
" Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" }


" Vim backup and working directories {


set backup " backups are nice ...
        if has('persistent_undo')
            set undofile "so is persistent undo ...
            set undolevels=1000 "maximum number of changes that can be undone
            set undoreload=10000 "maximum number lines to save for undo on a buffer reload
        endif
" Could use * rather than *.*, but I prefer to leave .files unsaved
        au BufWinLeave *.* silent! mkview "make vim save view (state) (folds, cursor, etc)
        au BufWinEnter *.* silent! loadview "make vim load view (state) (folds, cursor, etc)


function! InitializeDirectories()
    let separator = "."
    let parent = $HOME
    let prefix = '.vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . prefix . dirname . "/"
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
 
" }








set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

