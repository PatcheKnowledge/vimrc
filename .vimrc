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

" common operations at ','
noremap ,,w :w %<CR>
noremap ,,q :q<CR>
noremap ,,e :e<space>
noremap ,,x :call Clear()<CR>
noremap ,,c :call Copy()<CR>
noremap ,,p :call CopyPath()<CR>
noremap ,,t :call Template()<CR>

" compile at 'c'
noremap ,cc :call Compile()<CR>
noremap ,cx :call QuickRun()<CR>
noremap ,cb :call TestWith()<CR>
noremap ,cz :call Clear()<CR>

" interpret at 's'
noremap ,sr :call RunScript()<CR>

" git at 'g'
noremap ,ga :silent !git add %<CR><C-l>
noremap ,gs :!git status<CR>
noremap ,gc :!git commit -m<space>
noremap ,ge :silent !git config --edit<CR><C-l>
noremap ,gp :!git pull<CR>
noremap ,gpom :!git push origin master<CR>

" competitive programming at 'c' (space)
noremap <space>cl ggO#define LL long long<ESC><C-o>
noremap <space>cd ggO#define debug(expr) expr<ESC><C-o>

function Cd()
    cd %:h
    w %
endfunction

function Clear()
    :call Cd()
    silent !rm %:r
    redraw!
endfunction

function Copy()
    silent !xsel -b < %
    redraw!
endfunction

function CopyPath()
    silent !echo %:p | xsel -b
    redraw!
endfunction

function TestWith()
    :call Cd()
    if empty(glob('%:r'))
        Compile()
    endif
    !xsel -b | ./%:r
endfunction

function Template()
    r ~/.vim/sources/template.%:e
    normal ggddG
endfunction

function Compile()
    :call Cd()
    if expand('%:e') == 'hs'
        !ghc % -o %:r -O2 && rm %:r.hi %:r.o
    elseif expand('%:e') == 'cpp'
        !g++ % -o %:r -O2 -std=gnu++17
    elseif expand('%:e') == 'c'
        !gcc % -o %:r -O2 -std=c99
    else
        !echo 'Invalid filetype. No compiler is specified.'
    endif
endfunction

function QuickRun()
    :call Cd()
    if !empty(glob('%:r'))
        " target file exists. just run it.
        !echo 'Program %:r is running' && ./%:r
    else
        " compile
        if expand('%:e') == 'hs'
            silent !ghc % -o %:r && echo '\nCompiled with GHC.'
            silent !rm %:r.hi %:r.o
        elseif expand('%:e') == 'cpp'
            silent !g++ % -o %:r -std=gnu++17 && echo '\nCompiled with G++.'
        elseif expand('%:e') == 'c'
            silent !gcc % -o %:r -std=c99 && echo '\nCompiled with GCC.'
        else
            !echo 'Invalid filetype. No compiler is specified.'
            return
        endif
        " run
        !echo 'Program %:r is running' && ./%:r
        silent !rm %:r
    endif
    redraw!
endfunction

function RunScript()
    Cd()
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
