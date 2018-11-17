" basic settings:
set nocompatible
set number
filetype indent on
syntax on

" tab and autoshift:
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" highlight current line:
set cursorline
highlight CursorLine cterm=NONE
highlight CursorLineNr ctermfg=blue

" keymap
noremap <C-z> :shell<CR>
noremap <F2> :call Copy()<CR>
noremap <F9> :call Compile()<CR>
noremap <F10> :call QuickRun()<CR>
noremap <F11> :call RunScript()<CR>

function Copy()
    silent !xsel -b < %
    redraw!
endfunction

function Compile()
    cd %:h
    w %
    " compile
    if expand('%:e') == 'hs'
        silent !ghc % -o %:r -O2 && echo 'Compiled with GHC.'
        silent !rm %:r.hi %:r.o
    elseif expand('%:e') == 'cpp'
        silent !g++ % -o %:r -O2 -std=gnu++17 && echo 'Compiled with G++.'
    elseif expand('%:e') == 'c'
        silent !gcc % -o %:r -O2 -std=c99 && echo 'Compiled with GCC.'
    else
        !echo 'Invalid filetype. No compiler is specified.'
        return
    endif
    redraw!
endfunction

function QuickRun()
    cd %:h
    w %
    if !empty(glob('%:r'))
        " target file exists. just run it.
        !./%:r
    else
        " compile
        if expand('%:e') == 'hs'
            silent !ghc % -o %:r && echo 'Compiled with GHC.'
            silent !rm %:r.hi %:r.o
        elseif expand('%:e') == 'cpp'
            silent !g++ % -o %:r -std=gnu++17 && echo 'Compiled with G++.'
        elseif expand('%:e') == 'c'
            silent !gcc % -o %:r -std=c99 && echo 'Compiled with GCC.'
        else
            !echo 'Invalid filetype. No compiler is specified.'
            return
        endif
        " run
        !./%:r
        silent !rm %:r
    endif
    redraw!
endfunction

function RunScript()
    cd %:h
    w %
    " run by extension
    if expand('%:e') == 'py'
        !echo 'CPython is running...' && python %
    else
        !echo 'Invalid filetype. No Interpreter is specified.'
    endif
endfunction

" disable chinese input method (fcitx) when enter the normal mode
autocmd InsertLeave * let g:fcitx_tmp = system('fcitx-remote -c') " call Fcitx2en()

" vim plug: a fast, elegant plugin manager

" auto install vim-plug
if empty(glob( '~/.vim/autoload/plug.vim'))
	!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" begin plugin list:
call plug#begin()

Plug 'tpope/vim-surround'
Plug 'racer-rust/vim-racer'         " racer language server
Plug 'cespare/vim-toml'             " toml support
"Plug 'plasticboy/vim-markdown'      " markdown support
"Plug 'fatih/vim-go'                 " golang support
Plug 'jlapolla/vim-coq-plugin'      " coq highlighting
Plug 'rust-lang/rust.vim'           " rust support. function with racer.
Plug 'idris-hackers/idris-vim'      " idris support
Plug 'neovimhaskell/haskell-vim'    " haskell support

" end plugin list:
call plug#end()
