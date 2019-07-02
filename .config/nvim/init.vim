"{{{Basic
"{{{BasicConfig
if has('nvim')
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
endif
if !filereadable(expand('~/.vim/autoload/plug.vim'))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
if executable('tmux') && filereadable(expand('~/.zshrc')) && $TMUX !=# ''
    let g:VIM_Is_In_Tmux = 1
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
else
    let g:VIM_Is_In_Tmux = 0
endif
if exists('g:VIM_MANPAGER')
    let g:VIM_Enable_Startify = 0
else
    let g:VIM_Enable_Startify = 1
endif
"}}}
let g:VIM_LSP_Client = 'none'  " lcn vim-lsp none
let g:VIM_Snippets = 'coc-snippets'  " ultisnips neosnippet coc-snippets
let g:VIM_Completion_Framework = 'coc'  " deoplete ncm2 asyncomplete coc
let g:VIM_Fuzzy_Finder = 'remix'  " remix denite fzf leaderf
let g:VIM_Linter = 'ale'  " ale neomake
let g:VIM_TAGBAR = 'tagbar'  " tagbar vista
" :UpdateRemotePlugins
if exists('*VIM_Global_Settings')
    call VIM_Global_Settings()
endif
let g:VIM_AutoInstall = 1
let g:VIM_Enable_Autopairs = 1
"}}}
"{{{Global
"{{{Function
"{{{CloseOnLastTab
function! CloseOnLastTab()
    if tabpagenr('$') == 1
        execute 'windo bd'
        execute 'q'
    elseif tabpagenr('$') > 1
        execute 'windo bd'
    endif
endfunction
"}}}
"{{{HumanSize
fun! HumanSize(bytes) abort
    let l:bytes = a:bytes
    let l:sizes = ['B', 'KiB', 'MiB', 'GiB']
    let l:i = 0
    while l:bytes >= 1024
        let l:bytes = l:bytes / 1024.0
        let l:i += 1
    endwhile
    return printf('%.1f%s', l:bytes, l:sizes[l:i])
endfun
"}}}
"{{{RomaNumber
fun! RomaNumber(number) abort
    let l:number = a:number
    if l:number ==# '1'
        let l:romanumber = 'Ⅰ'
    elseif l:number ==# '2'
        let l:romanumber = 'Ⅱ'
    elseif l:number ==# '3'
        let l:romanumber = 'Ⅲ'
    elseif l:number ==# '4'
        let l:romanumber = 'Ⅳ'
    elseif l:number ==# '5'
        let l:romanumber = 'Ⅴ'
    elseif l:number ==# '6'
        let l:romanumber = 'Ⅵ'
    elseif l:number ==# '7'
        let l:romanumber = 'Ⅶ'
    elseif l:number ==# '8'
        let l:romanumber = 'Ⅷ'
    elseif l:number ==# '9'
        let l:romanumber = 'Ⅸ'
    elseif l:number ==# '10'
        let l:romanumber = 'Ⅹ'
    else
        let l:romanumber = a:number
    endif
    return l:romanumber
endfun
"}}}
"{{{NegativeCircledNumber
fun! NegativeCircledNumber(number) abort
    let l:number = a:number
    if l:number ==# '1'
        let l:nicenumber = '❶'
    elseif l:number ==# '2'
        let l:nicenumber = '❷'
    elseif l:number ==# '3'
        let l:nicenumber = '❸'
    elseif l:number ==# '4'
        let l:nicenumber = '❹'
    elseif l:number ==# '5'
        let l:nicenumber = '❺'
    elseif l:number ==# '6'
        let l:nicenumber = '❻'
    elseif l:number ==# '7'
        let l:nicenumber = '❼'
    elseif l:number ==# '8'
        let l:nicenumber = '❽'
    elseif l:number ==# '9'
        let l:nicenumber = '❾'
    elseif l:number ==# '10'
        let l:nicenumber = '❿'
    else
        let l:nicenumber = a:number
    endif
    return l:nicenumber
endfun
"}}}
"{{{ToggleObsession
function! ToggleObsession()
    if ObsessionStatusEnhance() ==# '⏹'
        execute 'Obsession ~/.cache/vim/sessions/Obsession'
    else
        execute 'Obsession'
    endif
endfunction
"}}}
"{{{ForceCloseRecursively
function! ForceCloseRecursively()
    let Loop_Var = 0
    while Loop_Var < 100
        execute 'q!'
        Loop_Var = s:Loop_Var + 1
    endwhile
endfunction
"}}}
"{{{s:go_indent
" gi, gI跳转indent
function! s:indent_len(str)
    return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction
function! s:go_indent(times, dir)
    for _ in range(a:times)
        let l = line('.')
        let x = line('$')
        let i = s:indent_len(getline(l))
        let e = empty(getline(l))

        while l >= 1 && l <= x
            let line = getline(l + a:dir)
            let l += a:dir
            if s:indent_len(line) != i || empty(line) != e
                break
            endif
        endwhile
        let l = min([max([1, l]), x])
        execute 'normal! '. l .'G^'
    endfor
endfunction
nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gI :<c-u>call <SID>go_indent(v:count1, -1)<cr>
"}}}
"{{{TerminalToggle
nnoremap <silent> <A-Z> :call nvim_open_win(bufnr('%'), v:true, {'relative': 'editor', 'anchor': 'NW', 'width': winwidth(0), 'height': 2*winheight(0)/5, 'row': 1, 'col': 0})<CR>:call TerminalToggle()<CR>
tnoremap <silent> <A-Z> <C-\><C-n>:call TerminalToggle()<CR>:q<CR>
function! TerminalCreate() abort
    if !has('nvim')
        return v:false
    endif

    if !exists('g:terminal')
        let g:terminal = {
                    \ 'opts': {},
                    \ 'term': {
                    \ 'loaded': v:null,
                    \ 'bufferid': v:null
                    \ },
                    \ 'origin': {
                    \ 'bufferid': v:null
                    \ }
                    \ }

        function! g:terminal.opts.on_exit(jobid, data, event) abort
            silent execute 'buffer' g:terminal.origin.bufferid
            silent execute 'bdelete!' g:terminal.term.bufferid

            let g:terminal.term.loaded = v:null
            let g:terminal.term.bufferid = v:null
            let g:terminal.origin.bufferid = v:null
        endfunction
    endif

    if g:terminal.term.loaded
        return v:false
    endif

    let g:terminal.origin.bufferid = bufnr('')

    enew
    call termopen(&shell, g:terminal.opts)

    let g:terminal.term.loaded = v:true
    let g:terminal.term.bufferid = bufnr('')
    startinsert
endfunction
function! TerminalToggle()
    if !has('nvim')
        return v:false
    endif

    " Create the terminal buffer.
    if !exists('g:terminal') || !g:terminal.term.loaded
        return TerminalCreate()
    endif

    " Go back to origin buffer if current buffer is terminal.
    if g:terminal.term.bufferid ==# bufnr('')
        silent execute 'buffer' g:terminal.origin.bufferid

        " Launch terminal buffer and start insert mode.
    else
        let g:terminal.origin.bufferid = bufnr('')

        silent execute 'buffer' g:terminal.term.bufferid
        startinsert
    endif
endfunction
"}}}
"{{{SynStack
function! SynStack()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
"}}}
"}}}
"{{{Setting
set encoding=utf-8 nobomb
set termencoding=utf-8
set fileencodings=utf-8,gbk,utf-16le,cp1252,iso-8859-15,ucs-bom
set fileformats=unix,dos,mac
scriptencoding utf-8
let mapleader=' '
nnoremap <SPACE> <Nop>
set mouse=a
filetype plugin indent on
set t_Co=256
let g:sessions_dir = expand('~/.cache/vim/sessions/')
syntax enable                           " 开启语法支持
set termguicolors                       " 开启GUI颜色支持
set smartindent                         " 智能缩进
set hlsearch                            " 高亮搜索
set undofile                            " 始终保留undo文件
set undodir=$HOME/.cache/vim/undo       " 设置undo文件的目录
set timeoutlen=5000                     " 超时时间为5秒
set foldmethod=marker                   " 折叠方式为按照marker折叠
set hidden                              " buffer自动隐藏
set showtabline=2                       " 总是显示标签
set scrolloff=5                         " 保持5行
set viminfo='1000                       " 文件历史个数
set autoindent                          " 自动对齐
set wildmenu                            " 命令框Tab呼出菜单
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab     " tab设定，:retab 使文件中的TAB匹配当前设置
set updatetime=100
if has('nvim')
    set inccommand=split
    set wildoptions=pum
    " set pumblend=15
endif
" "{{{
" if exists('g:loaded_sensible') || &compatible
"         finish
" else
"         let g:loaded_sensible = 'yes'
" endif
"
" " Use :help 'option' to see the documentation for the given option.
"
" set backspace=indent,eol,start
"
" set nrformats-=octal
"
" set incsearch
" set laststatus=2
" set ruler
"
" if &listchars ==# 'eol:$'
"         set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" endif
"
" if v:version > 703 || v:version == 703 && has('patch541')
"         set formatoptions+=j " Delete comment character when joining commented lines
" endif
"
" if has('path_extra')
"         setglobal tags-=./tags tags-=./tags; tags^=./tags;
" endif
"
" set autoread
"
" if &history < 1000
"         set history=1000
" endif
" if &tabpagemax < 50
"         set tabpagemax=50
" endif
" if !empty(&viminfo)
"         set viminfo^=!
" endif
" set sessionoptions-=options
"
" " Allow color schemes to do bright colors without forcing bold.
" if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
"         set t_Co=16
" endif
"
" " Load matchit.vim, but only if the user hasn't installed a newer version.
" if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &runtimepath) ==# ''
"         runtime! macros/matchit.vim
" endif
" "}}}
"}}}
"{{{Mapping
"{{{VIM-Compatible
" sed -n l
" https://stackoverflow.com/questions/5379837/is-it-possible-to-mapping-alt-hjkl-in-insert-mode
" https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
if !has('nvim')
    execute "set <M-a>=\ea"
    execute "set <M-b>=\eb"
    execute "set <M-c>=\ec"
    execute "set <M-d>=\ed"
    execute "set <M-e>=\ee"
    execute "set <M-f>=\ef"
    execute "set <M-g>=\eg"
    execute "set <M-h>=\eh"
    execute "set <M-i>=\ei"
    execute "set <M-j>=\ej"
    execute "set <M-k>=\ek"
    execute "set <M-l>=\el"
    execute "set <M-m>=\em"
    execute "set <M-n>=\en"
    execute "set <M-o>=\eo"
    execute "set <M-p>=\ep"
    execute "set <M-q>=\eq"
    execute "set <M-r>=\er"
    execute "set <M-s>=\es"
    execute "set <M-t>=\et"
    execute "set <M-u>=\eu"
    execute "set <M-v>=\ev"
    execute "set <M-w>=\ew"
    execute "set <M-x>=\ex"
    execute "set <M-y>=\ey"
    execute "set <M-z>=\ez"
    execute "set <M-,>=\e,"
    execute "set <M-.>=\e."
    execute "set <M-->=\e-"
    execute "set <M-=>=\e="
endif
"}}}
"{{{NormalMode
" Alt+X进入普通模式
nnoremap <A-x> <ESC>
if !has('nvim')
    nnoremap ^@ <ESC>
else
    nnoremap <silent> <C-l> :<C-u>wincmd p<CR>
endif
" ; 绑定到 :
nnoremap ; :
" q 绑定到:q
nnoremap <silent> q :q<CR>
" Ctrl+S保存文件
nnoremap <C-S> :<C-u>w<CR>
" Shift加方向键加速移动
nnoremap <S-up> <Esc>5<up>
nnoremap <S-down> <Esc>5<down>
nnoremap <S-left> <Esc>0
nnoremap <S-right> <Esc>$
" Shift+HJKL快速移动
nnoremap K <Esc>5<up>
nnoremap J <Esc>5<down>
nnoremap H <Esc>0
nnoremap L <Esc>$
" x删除字符但不保存到剪切板
nnoremap x "_x
" Ctrl+X剪切当前行
nnoremap <C-X> <ESC>"_dd
" <leader>+Y复制到系统剪切板
nnoremap <leader>y "+y
" <leader>+P从系统剪切板粘贴
nnoremap <leader>p "+p
" Alt+T新建tab
nnoremap <silent> <A-t> :<C-u>tabnew<CR>:call NerdtreeStartify()<CR>
" Alt+W关闭当前标签
nnoremap <silent> <A-w> :<C-u>call CloseOnLastTab()<CR>
" Alt+上下左右可以跳转和移动窗口
nnoremap <A-left> <Esc>gT
nnoremap <A-right> <Esc>gt
nnoremap <silent> <A-up> :<C-u>tabm -1<CR>
nnoremap <silent> <A-down> :<C-u>tabm +1<CR>
" Alt+h j k l可以在窗口之间跳转
nnoremap <silent> <A-h> :<C-u>wincmd h<CR>
nnoremap <silent> <A-l> :<C-u>wincmd l<CR>
nnoremap <silent> <A-k> :<C-u>wincmd k<CR>
nnoremap <silent> <A-j> :<C-u>wincmd j<CR>
" Alt+V && Alt+S新建窗口
nnoremap <silent> <A-v> :<C-u>vsp<CR>
nnoremap <silent> <A-s> :<C-u>sp<CR>
" neovim下，Alt+Shift+V, Alt+Shift+S分别切换到垂直和水平分割
if has('nvim')
    nnoremap <silent> <A-V> :<C-u>wincmd t<CR>:wincmd H<CR>
    nnoremap <silent> <A-S> :<C-u>wincmd t<CR>:wincmd K<CR>
endif
" Alt+-<>调整窗口大小
nnoremap <silent> <A-=> :<C-u>wincmd +<CR>
nnoremap <silent> <A--> :<C-u>wincmd -<CR>
nnoremap <silent> <A-,> :<C-u>wincmd <<CR>
nnoremap <silent> <A-.> :<C-u>wincmd ><CR>
" z+方向键快速跳转
nnoremap z<left> zk
nnoremap z<right> zj
nnoremap z<up> [z
nnoremap z<down> ]z
" z+hjkl快速跳转
nnoremap zh zk
nnoremap zl zj
nnoremap zj ]z
nnoremap zk [z
" zo递归局部打开折叠，zc递归局部关闭折叠
nnoremap zo zO
nnoremap zc zC
" zO递归全局打开折叠，C递归全局关闭折叠
nnoremap zO zR
nnoremap zC zM
" zf创建新的折叠，zd删除当前折叠
nnoremap zf zf
nnoremap zd zd
" zn创建新的折叠，并yard当前行的内容
nmap zn $vbda<Space><CR><Space><CR><Space><ESC>v<up><up>zfa<Backspace><down><right><Backspace><down><right><Backspace><up><up><Esc>A
" zs保存折叠视图，zl加载折叠视图
nnoremap zs :<C-u>mkview<CR>
nnoremap zl :<C-u>loadview<CR>
"}}}
"{{{InsertMode
" Alt+X进入普通模式
inoremap <A-x> <ESC><right>
if !has('nvim')
    inoremap ^@ <ESC>
endif
" Ctrl+V粘贴
inoremap <C-V> <Space><Backspace><ESC>pa
" <A-z><C-v>从系统剪切板粘贴
inoremap <A-z><C-V> <Space><Backspace><ESC>"+pa
" Ctrl+S保存文件
inoremap <C-S> <Esc>:w<CR>a
" Ctrl+Z撤销上一个动作
inoremap <C-Z> <ESC>ua
" Ctrl+R撤销撤销的动作
inoremap <C-R> <ESC><C-R>a
" Ctrl+X剪切当前行
inoremap <C-X> <ESC>"_ddi
" Alt+hjkl移动
imap <A-h> <left>
imap <A-j> <down>
imap <A-k> <up>
imap <A-l> <right>
" Shift加方向键加速移动
inoremap <S-up> <up><up><up><up><up>
inoremap <S-down> <down><down><down><down><down>
inoremap <S-left> <ESC>I
inoremap <S-right> <ESC>A
" Alt+Shift+hjkl加速移动
inoremap <A-H> <ESC>I
inoremap <A-J> <down><down><down><down><down>
inoremap <A-K> <up><up><up><up><up>
inoremap <A-L> <ESC>A
" Alt+上下左右可以跳转和移动窗口
inoremap <silent> <A-left> <Esc>:wincmd h<CR>i
inoremap <silent> <A-right> <Esc>:wincmd l<CR>i
inoremap <silent> <A-up> <Esc>:tabm -1<CR>i
inoremap <silent> <A-down> <Esc>:tabm +1<CR>i
"}}}
"{{{VisualMode
" Alt+X进入普通模式
vnoremap <A-x> <ESC>
snoremap <A-x> <ESC>
if !has('nvim')
    vnoremap ^@ <ESC>
endif
" ; 绑定到 :
vnoremap ; :
" Ctrl+S保存文件
vnoremap <C-S> :<C-u>w<CR>v
" x删除字符但不保存到剪切板
vnoremap x "_x
" Shift+方向键快速移动
vnoremap <S-up> <up><up><up><up><up>
vnoremap <S-down> <down><down><down><down><down>
vnoremap <S-left> 0
vnoremap <S-right> $<left>
" Shift+HJKL快速移动
vnoremap K 5<up>
vnoremap J 5<down>
vnoremap H 0
vnoremap L $
" <leader>+Y复制到系统剪切板
vnoremap <leader>y "+y
" <leader>+P从系统剪切板粘贴
vnoremap <leader>p "+p
"}}}
"{{{CommandMode
" Alt+X进入普通模式
cmap <A-x> <ESC>
if !has('nvim')
    cmap ^@ <ESC>
endif
" Ctrl+S保存
cmap <C-S> :<C-u>w<CR>
"}}}
"{{{TerminalMode
if has('nvim')
    " Alt+X进入普通模式
    tnoremap <A-x> <C-\><C-n>
    " Shift+方向键加速移动
    tnoremap <S-left> <C-a>
    tnoremap <S-right> <C-e>
endif
"}}}
"}}}
"{{{Command
" Q强制退出
command Q q!
"}}}
"{{{Temp
"}}}
"}}}
"{{{Plugin
"{{{vim-plug-usage
" 安装插件：
" :PlugInstall
" 更新插件：
" :PlugUpdate
" 更新vim-plug自身：
" :PlugUpgrade
" 清理插件：
" :PlugClean[!]
" 查看插件状态：
" :PlugStatus
" 查看插件更新后的更改：
" :PlugDiff
" 为当前插件生成快照：
" :PlugSnapshot[!] [output path]
" 立即加载插件：
" :call plug#load(name_list)
"
" 在vim-plug窗口的键位绑定：
" `D` - `PlugDiff`
" `S` - `PlugStatus`
" `R` - Retry failed update or installation tasks
" `U` - Update plugins in the selected range
" `q` - Close the window
" `:PlugStatus`
" - `L` - Load plugin
" `:PlugDiff`
" - `X` - Revert the update
" `o` - Preview window
" `H` - Help Docs
" `<Tab>` - Open GitHub URL in browser
" J \ K - scroll the preview window
" CTRL-N / CTRL-P - move between the commits
" CTRL-J / CTRL-K - move between the commits and synchronize the preview window
"
" on command load example:
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
"
" on filetype load example:
" Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Plug 'kovisoft/paredit', { 'for': ['clojure', 'scheme'] }
"
" on both conditions example:
" Plug 'junegunn/vader.vim',  { 'on': 'Vader', 'for': 'vader' }
"
" Load manually:
" Plug 'SirVer/ultisnips', { 'on': [] }
" Plug 'Valloric/YouCompleteMe', { 'on': [] }
" augroup load_us_ycm
"   autocmd!
"   autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
"                      \| autocmd! load_us_ycm
" augroup END
"
" more info     :h plug-options
"}}}
"{{{
" let g:plug_url_format = 'https://git::@github.com/%s.git'
" press 'o' to open preview window
augroup vim_plug_mapping
    autocmd! FileType vim-plug nmap <buffer> o <plug>(plug-preview)<c-w>P
augroup END

" automatically install missing plugins on startup
if g:VIM_AutoInstall == 1
    augroup vim_plug_auto_install
        autocmd!
        autocmd VimEnter *
                    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
                    \|   PlugInstall --sync | q
                    \| endif
    augroup END
endif

" Press 'H' to open help docs
function! s:plug_doc()
    let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
    if has_key(g:plugs, name)
        for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            execute 'tabe' doc
        endfor
    endif
endfunction
augroup PlugHelp
    autocmd!
    autocmd FileType vim-plug nnoremap <buffer> <silent> H :call <sid>plug_doc()<cr>
augroup END

" press 'gx' to open github url in browser
function! s:plug_gx()
    let line = getline('.')
    let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
    let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:')
                \ : getline(search('^- .*:$', 'bn'))[2:-2]
    let uri  = get(get(g:plugs, name, {}), 'uri', '')
    if uri !~# 'github.com'
        return
    endif
    let repo = matchstr(uri, '[^:/]*/'.name)
    let url  = empty(sha) ? 'https://github.com/'.repo
                \ : printf('https://github.com/%s/commit/%s', repo, sha)
    call netrw#BrowseX(url, 0)
endfunction
augroup PlugGx
    autocmd!
    autocmd FileType vim-plug nnoremap <buffer> <silent> <Tab> :call <sid>plug_gx()<cr>
augroup END

" J / K to scroll the preview window
" CTRL-N / CTRL-P to move between the commits
" CTRL-J / CTRL-K to move between the commits and synchronize the preview window
function! s:scroll_preview(down)
    silent! wincmd P
    if &previewwindow
        execute 'normal!' a:down ? "\<c-e>" : "\<c-y>"
        wincmd p
    endif
endfunction
function! s:setup_extra_keys()
    nnoremap <silent> <buffer> J :call <sid>scroll_preview(1)<cr>
    nnoremap <silent> <buffer> K :call <sid>scroll_preview(0)<cr>
    nnoremap <silent> <buffer> <c-n> :call search('^  \X*\zs\x')<cr>
    nnoremap <silent> <buffer> <c-p> :call search('^  \X*\zs\x', 'b')<cr>
    nmap <silent> <buffer> <c-j> <c-n>o
    nmap <silent> <buffer> <c-k> <c-p>o
endfunction
augroup PlugDiffExtra
    autocmd!
    autocmd FileType vim-plug call s:setup_extra_keys()
augroup END

command PU PlugUpdate | PlugUpgrade

call plug#begin('~/.cache/vim/plugins')
if !has('nvim') && has('python3')
    if g:VIM_Completion_Framework !=# 'ncm2'  " avoid duplication
        Plug 'roxma/nvim-yarp'
    endif
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'tpope/vim-repeat'
Plug 'ryanoasis/vim-devicons'
"}}}
" User Interface
"{{{themes
Plug 'lifepillar/vim-colortemplate', { 'as': 'colortemplate' }
Plug 'sheerun/vim-polyglot', { 'as': 'vim-syntax-polyglot' }
Plug 'sainnhe/vim-color-forest-night'
Plug 'sainnhe/vim-color-desert-night'
Plug 'sainnhe/vim-color-grimoire'
Plug 'sainnhe/vim-color-fairy-garden'
Plug 'sainnhe/vim-color-atlantis'
Plug 'sainnhe/vim-color-ice-age'
Plug 'sainnhe/vim-color-vanilla-cake'
Plug 'joshdick/onedark.vim', { 'as': 'vim-color-one' }
"}}}
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'macthecadillac/lightline-gitdiff'
if g:VIM_Is_In_Tmux == 1
    if $TMUXLINE_COLOR_SCHEME ==# 'normal' || $TMUXLINE_COLOR_SCHEME ==# 'insert' || $TMUXLINE_COLOR_SCHEME ==# 'visual' || $TMUXLINE_COLOR_SCHEME ==# 'sync'
        Plug 'sainnhe/tmuxline.vim', {'branch': 'dev'}
    endif
endif
if g:VIM_Enable_Startify == 1
    Plug 'mhinz/vim-startify'
endif
Plug 'CharlesGueunet/quickmenu.vim'
Plug 'mhinz/vim-signify'
Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides', { 'on': [] }
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/limelight.vim', { 'on': 'Limelight!!' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'roman/golden-ratio'
Plug 'sainnhe/artify.vim'
Plug 'RRethy/vim-hexokinase'

" Productivity
if g:VIM_LSP_Client ==# 'lcn'
    if executable('proxychains')
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'proxychains -q bash install.sh' }
    else
        Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
    endif
elseif g:VIM_LSP_Client ==# 'vim-lsp'
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
endif
if has('python3')
    Plug 'vim-vdebug/vdebug', { 'on': [] }
endif
Plug 'Shougo/vimproc.vim', { 'on': [], 'do' : 'make' }
Plug 'idanarye/vim-vebugger', { 'on': [] }
if g:VIM_Snippets ==# 'ultisnips'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
elseif g:VIM_Snippets ==# 'neosnippet'
    Plug 'Shougo/neosnippet.vim'
    Plug 'Shougo/neosnippet-snippets'
    Plug 'honza/vim-snippets'
elseif g:VIM_Snippets ==# 'coc-snippets'
    Plug 'honza/vim-snippets'
endif
if g:VIM_Completion_Framework ==# 'coc'
    Plug 'Shougo/neco-vim' | Plug 'neoclide/coc-neco'
    Plug 'Shougo/neoinclude.vim' | Plug 'jsfaint/coc-neoinclude'
    Plug 'wellle/tmux-complete.vim', { 'for': 'tmux' }
    Plug 'tjdevries/coc-zsh'
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }
elseif g:VIM_Completion_Framework ==# 'ncm2'
    Plug 'roxma/nvim-yarp' | Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-tagprefix', { 'on': [] }
    Plug 'ncm2/ncm2-gtags', { 'on': [] }
    Plug 'ncm2/ncm2-bufword'
    Plug 'fgrsnau/ncm2-otherbuf', { 'branch': 'ncm2'}
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-tagprefix'
    Plug 'filipekiss/ncm2-look.vim'
    Plug 'ncm2/ncm2-github'
    Plug 'Shougo/neco-syntax' | Plug 'ncm2/ncm2-syntax'
    Plug 'Shougo/neoinclude.vim' | Plug 'ncm2/ncm2-neoinclude'
    Plug 'ncm2/ncm2-pyclang', { 'for': ['c', 'cpp'] }
    Plug 'ncm2/ncm2-html-subscope', { 'for': 'html' }
    Plug 'ncm2/ncm2-jedi'
    Plug 'ncm2/ncm2-markdown-subscope', { 'for': 'markdown' }
    Plug 'Shougo/neco-vim', { 'for': 'vim' } | Plug 'ncm2/ncm2-vim', { 'for': 'vim' }
    Plug 'wellle/tmux-complete.vim', { 'for': 'tmux' }
    if g:VIM_LSP_Client ==# 'vim-lsp'
        Plug 'ncm2/ncm2-vim-lsp'
    endif
    if g:VIM_Snippets ==# 'ultisnips'
        Plug 'ncm2/ncm2-ultisnips'
    elseif g:VIM_Snippets ==# 'neosnippet'
        Plug 'ncm2/ncm2-neosnippet'
    endif
    " Plug 'ncm2/ncm2-match-highlight'
    " Plug 'ncm2/ncm2-highprio-pop'
elseif g:VIM_Completion_Framework ==# 'deoplete'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    if executable('proxychains')
        Plug 'tbodt/deoplete-tabnine', { 'do': 'proxychains -q bash ./install.sh' }
    else
        Plug 'tbodt/deoplete-tabnine', { 'do': 'bash ./install.sh' }
    endif
    Plug 'ozelentok/deoplete-gtags', { 'on': [] }
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/neoinclude.vim'
    Plug 'Shougo/context_filetype.vim'
    Plug 'Shougo/neco-vim', { 'for': 'vim' }
    Plug 'wellle/tmux-complete.vim', { 'for': 'tmux' }
    Plug 'Shougo/deoplete-clangx', { 'for': [ 'c', 'cpp' ] }
    Plug 'zchee/deoplete-clang', { 'for': [ 'c', 'cpp' ] }
    Plug 'zchee/deoplete-jedi', { 'for': 'python' }
    if g:VIM_LSP_Client ==# 'vim-lsp'
        Plug 'lighttiger2505/deoplete-vim-lsp'
    endif
elseif g:VIM_Completion_Framework ==# 'asyncomplete'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-tags.vim'
    Plug 'prabirshrestha/asyncomplete-buffer.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'Shougo/neco-syntax' | Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
    Plug 'Shougo/neoinclude.vim' | Plug 'kyouryuukunn/asyncomplete-neoinclude.vim'
    Plug 'Shougo/neco-vim', { 'for': 'vim' } | Plug 'prabirshrestha/asyncomplete-necovim.vim', { 'for': 'vim' }
    Plug 'wellle/tmux-complete.vim', { 'for': 'tmux' }
    if g:VIM_LSP_Client ==# 'vim-lsp'
        Plug 'prabirshrestha/asyncomplete-lsp.vim'
    endif
    if g:VIM_Snippets ==# 'ultisnips'
        Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
    elseif g:VIM_Snippets ==# 'neosnippet'
        Plug 'prabirshrestha/asyncomplete-neosnippet.vim'
    endif
elseif g:VIM_Completion_Framework ==# 'neocomplete'
    Plug 'Shougo/neocomplete.vim'
    Plug 'Shougo/neoinclude.vim'
    Plug 'Shougo/neco-vim'
    Plug 'Shougo/neco-syntax'
    Plug 'ujihisa/neco-look'
    Plug 'wellle/tmux-complete.vim', { 'for': 'tmux' }
endif
if g:VIM_Fuzzy_Finder ==# 'denite' || g:VIM_Fuzzy_Finder ==# 'remix'
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins'}
    Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
    Plug 'nixprime/cpsm', { 'do': 'bash ./install.sh' }
    Plug 'iamcco/denite-source.vim'
    Plug 'neoclide/denite-extra'
    Plug 'Shougo/neomru.vim'
    Plug 'chemzqm/denite-git'
    Plug 'ozelentok/denite-gtags'
    Plug 'notomo/denite-keymap'
    Plug 'tjmmm/denite-man'
    Plug 'bennyyip/denite-github-stars'
    if g:VIM_Linter ==# 'ale'
        Plug 'iyuuya/denite-ale'
    elseif g:VIM_Linter ==# 'neomake'
        Plug 'mhartington/denite-neomake'
    endif
endif
if g:VIM_Fuzzy_Finder ==# 'fzf' || g:VIM_Fuzzy_Finder ==# 'remix'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'fszymanski/fzf-quickfix'
endif
if g:VIM_Fuzzy_Finder ==# 'leaderf' || g:VIM_Fuzzy_Finder ==# 'remix'
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plug 'Yggdroot/LeaderF-marks'
    Plug 'youran0715/LeaderF-Cmdpalette'
    Plug 'markwu/LeaderF-prosessions'
    Plug 'bennyyip/LeaderF-github-stars'
endif
if g:VIM_Linter ==# 'ale'
    Plug 'w0rp/ale'
    Plug 'maximbaz/lightline-ale'
elseif g:VIM_Linter ==# 'neomake'
    Plug 'neomake/neomake'
    Plug 'sinetoami/lightline-neomake'
    if g:VIM_LSP_Client ==# 'lcn'
        Plug 'Palpatineli/lightline-lsc-nvim'
    endif
endif
Plug 'justinmk/vim-sneak'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeVCS', 'NERDTreeToggle'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': ['NERDTreeVCS', 'NERDTreeToggle'] }
Plug 'mcchrish/nnn.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'sodapopcan/vim-twiggy'
Plug 'junegunn/gv.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'rhysd/committia.vim'
Plug 'jsfaint/gen_tags.vim', { 'on': [] }
if g:VIM_TAGBAR ==# 'tagbar'
    Plug 'majutsushi/tagbar', { 'on': [] }
    if executable('proxychains')
        Plug 'vim-php/tagbar-phpctags.vim', { 'on': [], 'do': 'proxychains -q make' }
    else
        Plug 'vim-php/tagbar-phpctags.vim', { 'on': [], 'do': 'make' }
    endif
elseif g:VIM_TAGBAR ==# 'vista'
    Plug 'liuchengxu/vista.vim'
endif
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
Plug 'albertomontesg/lightline-asyncrun'
" Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'Shougo/unite.vim', { 'on': [] }
Plug 'thinca/vim-qfreplace', { 'on': [] }
Plug 'MattesGroeger/vim-bookmarks'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-surround'
Plug 'AndrewRadev/inline_edit.vim'
Plug 'airblade/vim-rooter'
Plug 'ianva/vim-youdao-translater'
Plug 'yuttie/comfortable-motion.vim'
Plug 'metakirby5/codi.vim'
Plug 'mbbill/fencview', { 'on': [ 'FencAutoDetect', 'FencView' ] }
Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }
Plug 'andymass/vim-matchup'
if exists('g:VIM_MANPAGER')
    Plug 'lambdalisue/vim-manpager'
endif
if g:VIM_Enable_Autopairs == 1
    Plug 'jiangmiao/auto-pairs'
elseif g:VIM_Completion_Framework !=# 'coc'
    Plug 'Shougo/neopairs.vim'
endif
if g:VIM_Is_In_Tmux == 0
    Plug 'rmolin88/pomodoro.vim'
endif
if executable('fcitx')
    Plug 'lilydjwg/fcitx.vim', { 'on': [] }
                \| au InsertEnter * call plug#load('fcitx.vim')
endif
Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
            \| au BufNewFile,BufRead *.html,*.css call Func_emmet_vim()
Plug 'alvan/vim-closetag', { 'for': 'html' }
            \| au BufNewFile,BufRead *.html,*.css call Func_vim_closetag()
if executable('proxychains')
    Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'proxychains -q npm install' }
else
    Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
endif
Plug 'ehamberg/vim-cute-python', { 'for': 'python' }
Plug 'elzr/vim-json', { 'for': 'json' }
            \| au BufNewFile,BufRead *.json call Func_vim_json()

" Entertainment
Plug 'mattn/vim-starwars', { 'on': 'StarWars' }
"{{{
call plug#end()
"}}}
"}}}
" User Interface
"{{{lightline.vim
"{{{lightline.vim-usage
" :h 'statusline'
" :h g:lightline.component
"}}}
"{{{functions
function! SwitchLightlineColorScheme(color)"{{{
    let g:lightline.colorscheme = a:color
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction"}}}
function! ObsessionStatusEnhance() abort"{{{
    if ObsessionStatus() ==# '[$]'
        " return \uf94a
        return '⏺'
    else
        " return \uf949
        return '⏹'
    endif
endfunction"}}}
function! TmuxBindLock() abort"{{{
    if filereadable('/tmp/.tmux-bind.lck')
        return "\uf13e"
    else
        return "\uf023"
    endif
endfunction"}}}
function! PomodoroStatus() abort"{{{
    if g:VIM_Is_In_Tmux == 0
        if pomo#remaining_time() ==# '0'
            return "\ue001"
        else
            return "\ue003 ".pomo#remaining_time()
        endif
    elseif g:VIM_Is_In_Tmux == 1
        return ''
    endif
endfunction"}}}
function! Devicons_Filetype()"{{{
    " return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction"}}}
function! Devicons_Fileformat()"{{{
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction"}}}
function! Artify_active_tab_num(n) abort"{{{
    return Artify(a:n, 'bold')." \ue0bb"
endfunction"}}}
function! Artify_inactive_tab_num(n) abort"{{{
    return Artify(a:n, 'double_struck')." \ue0bb"
endfunction"}}}
function! Artify_lightline_tab_filename(s) abort"{{{
    return Artify(lightline#tab#filename(a:s), 'monospace')
endfunction"}}}
function! Artify_lightline_mode() abort"{{{
    return Artify(lightline#mode(), 'monospace')
endfunction"}}}
function! Artify_line_percent() abort"{{{
    return Artify(string((100*line('.'))/line('$')), 'bold')
endfunction"}}}
function! Artify_line_num() abort"{{{
    return Artify(string(line('.')), 'bold')
endfunction"}}}
function! Artify_col_num() abort"{{{
    return Artify(string(getcurpos()[2]), 'bold')
endfunction"}}}
function! Artify_gitbranch() abort"{{{
    if gitbranch#name() !=# ''
        return Artify(gitbranch#name(), 'monospace')." \ue725"
    else
        return "\ue61b"
    endif
endfunction"}}}
"}}}
set laststatus=2  " Basic
set noshowmode  " Disable show mode info
augroup Lightline_Au
    autocmd!
    autocmd BufWritePost * call lightline_gitdiff#query_git() | call lightline#update()
augroup END
let g:lightline = {}
let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline#neomake#prefix_infos = 'ℹ'
let g:lightline#neomake#prefix_warnings = "\uf529"
let g:lightline#neomake#prefix_errors = "\uf00d"
let g:lightline#neomake#prefix_ok = "\uf00c"
let g:lightline_neomake#format = '%s: %d'
let g:lightline_neomake#sep = "\ue0b9"
let g:lightline#lsc#indicator_checking = "\uf110"
let g:lightline#lsc#indicator_notstarted = "\ufbab"
let g:lightline#lsc#indicator_errors = "\uf00d"
let g:lightline#lsc#indicator_ok = "\uf00c"
let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf529"
let g:lightline#ale#indicator_errors = "\uf00d"
let g:lightline#ale#indicator_ok = "\uf00c"
let g:lightline_gitdiff#indicator_added = '+'
let g:lightline_gitdiff#indicator_deleted = '-'
let g:lightline_gitdiff#indicator_modified = '*'
let g:lightline_gitdiff#min_winwidth = '70'
if g:VIM_Is_In_Tmux == 1
    let g:Lightline_StatusIndicators = [ 'obsession', 'tmuxlock' ]
elseif g:VIM_Is_In_Tmux == 0
    let g:Lightline_StatusIndicators = [ 'pomodoro', 'obsession' ]
endif
if g:VIM_Linter ==# 'ale'
    let g:Lightline_Linter = [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]
elseif g:VIM_Linter ==# 'neomake'
    let g:Lightline_Linter = [ 'neomake_warnings', 'neomake_errors', 'neomake_infos', 'neomake_ok', 'lsc_ok', 'lsc_errors', 'lsc_checking', 'lsc_warnings' ]
endif
let g:lightline.active = {
            \ 'left': [ [ 'artify_mode', 'paste' ],
            \           [ 'readonly', 'filename', 'modified', 'fileformat', 'devicons_filetype' ] ],
            \ 'right': [ [ 'artify_lineinfo' ],
            \            g:Lightline_StatusIndicators + g:Lightline_Linter,
            \           [ 'asyncrun_status' ] ]
            \ }
let g:lightline.inactive = {
            \ 'left': [ [ 'filename' , 'modified', 'fileformat', 'devicons_filetype' ]],
            \ 'right': [ [ 'artify_lineinfo' ] ]
            \ }
let g:lightline.tabline = {
            \ 'left': [ [ 'vim_logo', 'tabs' ] ],
            \ 'right': [ [ 'artify_gitbranch' ],
            \ [ 'gitstatus' ] ]
            \ }
let g:lightline.tab = {
            \ 'active': [ 'artify_activetabnum', 'artify_filename', 'modified' ],
            \ 'inactive': [ 'artify_inactivetabnum', 'filename', 'modified' ] }
let g:lightline.tab_component = {
            \ }
let g:lightline.tab_component_function = {
            \ 'artify_activetabnum': 'Artify_active_tab_num',
            \ 'artify_inactivetabnum': 'Artify_inactive_tab_num',
            \ 'artify_filename': 'Artify_lightline_tab_filename',
            \ 'filename': 'lightline#tab#filename',
            \ 'modified': 'lightline#tab#modified',
            \ 'readonly': 'lightline#tab#readonly',
            \ 'tabnum': 'lightline#tab#tabnum'
            \ }
let g:lightline.component = {
            \ 'artify_gitbranch' : '%{Artify_gitbranch()}',
            \ 'gitstatus' : '%{lightline_gitdiff#get_status()}',
            \ 'bufinfo': '%{bufname("%")}:%{bufnr("%")}',
            \ 'obsession': '%{ObsessionStatusEnhance()}',
            \ 'tmuxlock': '%{TmuxBindLock()}',
            \ 'vim_logo': "\ue7c5",
            \ 'pomodoro': '%{PomodoroStatus()}',
            \ 'nicewinnumber': '%{NegativeCircledNumber(tabpagewinnr(tabpagenr()))}',
            \ 'mode': '%{lightline#mode()}',
            \ 'artify_mode': '%{Artify_lightline_mode()}',
            \ 'absolutepath': '%F',
            \ 'relativepath': '%f',
            \ 'filename': '%t',
            \ 'filesize': "%{HumanSize(line2byte('$') + len(getline('$')))}",
            \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
            \ 'fileformat': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
            \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
            \ 'modified': '%M',
            \ 'bufnum': '%n',
            \ 'paste': '%{&paste?"PASTE":""}',
            \ 'readonly': '%R',
            \ 'charvalue': '%b',
            \ 'charvaluehex': '%B',
            \ 'percent': '%2p%%',
            \ 'percentwin': '%P',
            \ 'spell': '%{&spell?&spelllang:""}',
            \ 'lineinfo': '%2p%% %3l:%-2v',
            \ 'artify_lineinfo': "%2{Artify_line_percent()}\uf295 %3{Artify_line_num()}:%-2{Artify_col_num()}",
            \ 'line': '%l',
            \ 'column': '%c',
            \ 'close': '%999X X ',
            \ 'winnr': '%{winnr()}'
            \ }
let g:lightline.component_function = {
            \ 'gitbranch': 'gitbranch#name',
            \ 'devicons_filetype': 'Devicons_Filetype',
            \ 'devicons_fileformat': 'Devicons_Fileformat'
            \ }
let g:lightline.component_expand = {
            \ 'neomake_infos': 'lightline#neomake#infos',
            \ 'neomake_warnings': 'lightline#neomake#warnings',
            \ 'neomake_errors': 'lightline#neomke#errors',
            \ 'neomake_ok': 'lightline#neomake#ok',
            \ 'lsc_checking': 'lightline#lsc#checking',
            \ 'lsc_warnings': 'lightline#lsc#warnings',
            \ 'lsc_errors': 'lightline#lsc#errors',
            \ 'lsc_ok': 'lightline#lsc#ok',
            \ 'linter_checking': 'lightline#ale#checking',
            \ 'linter_warnings': 'lightline#ale#warnings',
            \ 'linter_errors': 'lightline#ale#errors',
            \ 'linter_ok': 'lightline#ale#ok',
            \ 'asyncrun_status': 'lightline#asyncrun#status'
            \ }
let g:lightline.component_type = {
            \ 'neomake_warnings': 'warning',
            \ 'neomake_errors': 'error',
            \ 'neomake_ok': 'middle',
            \ 'lsc_checking': 'middle',
            \ 'lsc_warnings': 'warning',
            \ 'lsc_errors': 'error',
            \ 'lsc_ok': 'middle',
            \ 'linter_checking': 'middle',
            \ 'linter_warnings': 'warning',
            \ 'linter_errors': 'error',
            \ 'linter_ok': 'middle'
            \ }
let g:lightline.component_visible_condition = {
            \     'gitstatus': 'lightline_gitdiff#get_status() !=# ""'
            \   }
"}}}
"{{{tmuxline.vim
if g:VIM_Is_In_Tmux == 1
    if $TMUXLINE_COLOR_SCHEME ==# 'normal' || $TMUXLINE_COLOR_SCHEME ==# 'insert' || $TMUXLINE_COLOR_SCHEME ==# 'visual' || $TMUXLINE_COLOR_SCHEME ==# 'sync'
        "{{{TmuxlineGen
        function! TmuxlineGen(str)
            execute 'Tmuxline lightline'
            execute 'TmuxlineSnapshot! ~/.tmux/tmuxline/'.a:str.'_normal.tmux.conf'
            execute 'Tmuxline lightline_insert'
            execute 'TmuxlineSnapshot! ~/.tmux/tmuxline/'.a:str.'_insert.tmux.conf'
            execute 'Tmuxline lightline_visual'
            execute 'TmuxlineSnapshot! ~/.tmux/tmuxline/'.a:str.'_visual.tmux.conf'
        endfunction
        "}}}
        if $TMUXLINE_COLOR_SCHEME ==# 'sync'
            augroup TmuxlineAu
                autocmd!
                autocmd VimEnter * Tmuxline lightline | AsyncRun tmux source-file ~/.tmux.conf
                autocmd InsertLeave * Tmuxline lightline | AsyncRun tmux source-file ~/.tmux.conf
                autocmd InsertEnter * Tmuxline lightline_insert | AsyncRun tmux source-file ~/.tmux.conf
                autocmd InsertEnter * Tmuxline lightline_insert | AsyncRun tmux source-file ~/.tmux.conf
            augroup END
        elseif $TMUXLINE_COLOR_SCHEME ==# 'normal'
            augroup TmuxlineAu
                autocmd!
                autocmd VimEnter * Tmuxline lightline | AsyncRun tmux source-file ~/.tmux.conf
            augroup END
        elseif $TMUXLINE_COLOR_SCHEME ==# 'insert'
            augroup TmuxlineAu
                autocmd!
                autocmd VimEnter * Tmuxline lightline_insert | AsyncRun tmux source-file ~/.tmux.conf
            augroup END
        elseif $TMUXLINE_COLOR_SCHEME ==# 'visual'
            augroup TmuxlineAu
                autocmd!
                autocmd VimEnter * Tmuxline lightline_visual | AsyncRun tmux source-file ~/.tmux.conf
            augroup END
        endif
        let g:tmuxline_preset = {
                    \'a'    : '#S',
                    \'b'    : '%R %a',
                    \'c'    : [ '#{sysstat_mem} #[fg=blue]\ufa51#{upload_speed}' ],
                    \'win'  : [ '#I', '#W' ],
                    \'cwin' : [ '#I', '#W', '#F' ],
                    \'x'    : [ "#[fg=blue]#{download_speed} \uf6d9 #{sysstat_cpu}" ],
                    \'y'    : [ '#(bash /home/sainnhe/repo/scripts/func/tmux_pomodoro.sh) \ue0bd #(bash /home/sainnhe/repo/scripts/func/tmux_lock.sh)' ],
                    \'z'    : '#H #{prefix_highlight}'
                    \}
        let g:tmuxline_separators = {
                    \ 'left' : "\ue0bc",
                    \ 'left_alt': "\ue0bd",
                    \ 'right' : "\ue0ba",
                    \ 'right_alt' : "\ue0bd",
                    \ 'space' : ' '}
    endif
endif
"}}}
"{{{colorscheme
"{{{Functions
"{{{SwitchColorScheme()
function! SwitchColorScheme(name)
    let g:VIM_Color_Scheme = a:name
    call ColorScheme()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
    if g:VIM_Is_In_Tmux == 1
        if $TMUXLINE_COLOR_SCHEME ==# 'normal' || $TMUXLINE_COLOR_SCHEME ==# 'insert' || $TMUXLINE_COLOR_SCHEME ==# 'visual' || $TMUXLINE_COLOR_SCHEME ==# 'sync'
            execute 'Tmuxline lightline'
        endif
    endif
endfunction
"}}}
"}}}
let g:VIM_Color_Scheme = 'vanilla-cake'
function! ColorScheme()
    call quickmenu#current(99)
    call quickmenu#reset()
    call g:quickmenu#append('# Dark', '')
    "{{{one
    if g:VIM_Color_Scheme ==# 'one'
        colorscheme onedark
        let g:lightline.colorscheme = 'one'
        let g:lightline#colorscheme#one#palette.tabline.right[0] = g:lightline#colorscheme#one#palette.insert.left[0]
    endif
    call g:quickmenu#append('one', 'call SwitchColorScheme("one")', '', '', 0, '')
    "}}}
    "{{{desert-night
    if g:VIM_Color_Scheme ==# 'desert-night'
        set background=dark
        colorscheme desert-night
        let g:lightline.colorscheme = 'desert_night'
    endif
    call g:quickmenu#append('desert-night', 'call SwitchColorScheme("desert-night")', '', '', 0, '')
    "}}}
    "{{{forest-night
    if g:VIM_Color_Scheme ==# 'forest-night'
        set background=dark
        colorscheme forest-night
        let g:lightline.colorscheme = 'forest_night'
    endif
    call g:quickmenu#append('forest-night', 'call SwitchColorScheme("forest-night")', '', '', 0, '')
    "}}}
    "{{{atlantis
    if g:VIM_Color_Scheme ==# 'atlantis'
        set background=light
        colorscheme atlantis
        let g:lightline.colorscheme = 'atlantis'
    endif
    call g:quickmenu#append('atlantis', 'call SwitchColorScheme("atlantis")', '', '', 0, '')
    "}}}
    call g:quickmenu#append('# Light', '')
    "{{{vanilla-cake
    if g:VIM_Color_Scheme ==# 'vanilla-cake'
        set background=light
        colorscheme vanilla-cake
        let g:lightline.colorscheme = 'vanilla_cake'
    endif
    call g:quickmenu#append('vanilla-cake', 'call SwitchColorScheme("vanilla-cake")', '', '', 0, '')
    "}}}
    "{{{grimoire
    if g:VIM_Color_Scheme ==# 'grimoire'
        set background=light
        colorscheme grimoire
        let g:lightline.colorscheme = 'grimoire'
    endif
    call g:quickmenu#append('grimoire', 'call SwitchColorScheme("grimoire")', '', '', 0, '')
    "}}}
    "{{{fairy-garden
    if g:VIM_Color_Scheme ==# 'fairy-garden'
        set background=light
        colorscheme fairy-garden
        let g:lightline.colorscheme = 'fairy_garden'
    endif
    call g:quickmenu#append('fairy-garden', 'call SwitchColorScheme("fairy-garden")', '', '', 0, '')
    "}}}
    "{{{ice-age
    if g:VIM_Color_Scheme ==# 'ice-age'
        set background=light
        colorscheme ice-age
        let g:lightline.colorscheme = 'ice_age'
    endif
    call g:quickmenu#append('ice-age', 'call SwitchColorScheme("ice-age")', '', '', 0, '')
    "}}}
endfunction
call ColorScheme()
"{{{InitBG()
function! InitBG()
    if empty($TERM_Emulator)
        let g:TransparentBG = 0
    else
        if $TERM_Emulator ==# 'konsole'
            let g:TransparentBG = 1
        else
            let g:TransparentBG = 0
        endif
    endif
endfunction
call InitBG()
"}}}
"{{{TransparentBG()
function! TransparentBG()
    if g:TransparentBG == 1
        hi Normal guibg=NONE ctermbg=NONE
    endif
endfunction
call TransparentBG()
"}}}
"{{{ToggleBG()
function! ToggleBG()
    if g:TransparentBG == 1
        let g:TransparentBG = 0
        set background=light
    elseif g:TransparentBG == 0
        let g:TransparentBG = 1
        call TransparentBG()
    endif
endfunction
"}}}
"}}}
"{{{vim-startify
if g:VIM_Enable_Startify == 1
    let g:startify_session_dir = expand('~/.cache/vim/sessions/')
    let g:startify_files_number = 5
    let g:startify_update_oldfiles = 1
    " let g:startify_session_autoload = 1
    " let g:startify_session_persistence = 1 " autoupdate sessions
    let g:startify_session_delete_buffers = 1 " delete all buffers when loading or closing a session, ignore unsaved buffers
    let g:startify_change_to_dir = 1 " when opening a file or bookmark, change to its directory
    let g:startify_fortune_use_unicode = 1 " beautiful symbols
    let g:startify_padding_left = 3 " the number of spaces used for left padding
    let g:startify_session_remove_lines = ['setlocal', 'winheight'] " lines matching any of the patterns in this list, will be removed from the session file
    let g:startify_session_sort = 1 " sort sessions by alphabet or modification time
    let g:startify_custom_indices = ['1', '2', '3', '4', '5', '1', '2', '3', '4', '5'] " MRU indices
    " line 579 for more details
    let g:startify_bookmarks = [
                \ {'R': '~/repo/'},
                \ {'N': '~/repo/notes'},
                \ {'P': '~/Documents/PlayGround/'},
                \ {'c': '~/.config/nvim/init.vim'},
                \ {'c': '~/.zshrc'},
                \ {'c': '~/.tmux.conf'}
                \ ]
    if has('nvim')
        let g:startify_commands = [
                    \ {'1': 'terminal'},
                    \ ]
    endif
    let g:startify_custom_header = [
                \ ' _,  _, _ _, _ _, _ _,_ __, __,  _, __, _,_  _, __,  _, _,_ _,  _ _, _ _,_ _  ,',
                \ "(_  /_\\ | |\\ | |\\ | |_| |_  |_) /_\\ |_) |_/ / \\ |_) / ` |_| |   | |\\ | | | '\\/",
                \ ', ) | | | | \| | \| | | |   |   | | | \ | \ |~| | \ \ , | | | , | | \| | |  /\ ',
                \ " ~  ~ ~ ~ ~  ~ ~  ~ ~ ~ ~~~ ~   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  ~  ~ ~ ~~~ ~ ~  ~ `~' ~  ~",
                \ ]
    " costom startify list
    let g:startify_lists = [
                \ { 'type': 'sessions',  'header': [" \ue62e Sessions"]       },
                \ { 'type': 'bookmarks', 'header': [" \uf5c2 Bookmarks"]      },
                \ { 'type': 'files',     'header': [" \ufa1eMRU Files"]            },
                \ { 'type': 'dir',       'header': [" \ufa1eMRU Files in ". getcwd()] },
                \ { 'type': 'commands',  'header': [" \uf085 Commands"]       },
                \ ]
    " on Start
    function! NerdtreeStartify()
        execute 'Startify'
        execute 'NERDTreeVCS'
        execute 'wincmd l'
    endfunction
    augroup Startify_Config
        autocmd VimEnter *
                    \   if !argc()
                    \ |   call NerdtreeStartify()
                    \ | endif
        " on Enter
        autocmd User Startified nmap <silent><buffer> <CR> <plug>(startify-open-buffers):NERDTreeToggle<CR>
    augroup END
    " list of commands to be executed before save a session
    let g:startify_session_before_save = [
                \ 'echo "Cleaning up before saving.."',
                \ 'silent! NERDTreeTabsClose',
                \ ]
    " MRU skipped list, do not use ~
    let g:startify_skiplist = [
                \ '/mnt/*',
                \ ]
endif
"}}}
"{{{quickmenu.vim
let g:quickmenu_options = 'HL'  " enable cursorline (L) and cmdline help (H)

call quickmenu#current(0)
call quickmenu#reset()
nnoremap <silent> <leader><leader> :call quickmenu#toggle(0)<cr>
call g:quickmenu#append('# Menu', '')
call g:quickmenu#append('Servers', 'call quickmenu#toggle(4)', '', '', 0, 'l')
if g:VIM_Is_In_Tmux == 0
    call g:quickmenu#append('Pomodoro Toggle', 'call Toggle_Pomodoro()', '', '', 0, 'p')
endif
call g:quickmenu#append('Obsession', 'call ToggleObsession()', '', '', 0, 's')
call g:quickmenu#append('Tags', 'call quickmenu#toggle(7)', '', '', 0, 't')
call g:quickmenu#append('Switch ColorScheme', 'call quickmenu#toggle(99)', '', '', 0, 'c')
call g:quickmenu#append('Undo Tree', 'UndotreeToggle', '', '', 0, 'u')
call g:quickmenu#append('Codi', 'Codi!!', '', '', 0, 'C')
call g:quickmenu#append('Toggle Indent', 'call ToggleIndent()', '', '', 0, 'i')
call g:quickmenu#append('Folding Method', 'call quickmenu#toggle(11)', '', '', 0, 'f')
call g:quickmenu#append('Focus Mode', 'Limelight!!', 'toggle focus mode', '', 0, 'F')
call g:quickmenu#append('Read Mode', 'Goyo', 'toggle read mode', '', 0, 'R')
call g:quickmenu#append('Ratio Resize', 'GoldenRatioResize', ':GoldenRatioResize  " resize current window', '', 0, 'g')
call g:quickmenu#append('Ratio Toggle', 'GoldenRatioToggle', ':GoldenRatioToggle  " toggle golden ratio', '', 0, 'G')
call g:quickmenu#append('Hexokinase Toggle', 'HexokinaseToggle', '', '', 0, 'H')
call g:quickmenu#append('FencAutoDetect', 'FencAutoDetect', 'FencAutoDetect && FencView', '', 0, '^')
call g:quickmenu#append('Entertainment', 'call quickmenu#toggle(12)', '', '', 0, '*')
call g:quickmenu#append('Help', 'call quickmenu#toggle(10)', '', '', 0, 'h')
call quickmenu#current(10)
call quickmenu#reset()
call g:quickmenu#append('# Help', '')
call g:quickmenu#append('Visual Multi', 'call Help_vim_visual_multi()', '', '', 0, 'v')
call g:quickmenu#append('Sneak', 'call Help_vim_sneak()', '', '', 0, 's')
call g:quickmenu#append('Prosession', 'call Help_vim_prosession()', '', '', 0, 'S')
call g:quickmenu#append('Neoformat', 'call Help_neoformat()', '', '', 0, 'f')
call g:quickmenu#append('Auto Pairs', 'call Help_auto_pairs()', '', '', 0, 'p')
call g:quickmenu#append('Nerd Commenter', 'call Help_nerdcommenter()', '', '', 0, 'c')
call g:quickmenu#append('Bookmarks', 'call Help_vim_bookmarks()', '', '', 0, 'b')
call g:quickmenu#append('Close Tag', 'call Help_vim_closetag()', '', '', 0, 't')
call g:quickmenu#append('Multiple Cursors', 'call Help_vim_multiple_cursors()', '', '', 0, 'm')
call g:quickmenu#append('Signify', 'call Help_vim_signify()', '', '', 0, 'S')
call g:quickmenu#append('VIM Surround', 'call Help_vim_surround()', '', '', 0, 'r')
call g:quickmenu#append('VIM Matchup', 'call Help_vim_matchup()', '', '', 0, 'M')
call quickmenu#current(11)
call quickmenu#reset()
call g:quickmenu#append('# Folding Method', '')
call g:quickmenu#append('Marker', 'set foldmethod=marker', '', '', 0, 'm')
call g:quickmenu#append('Syntax', 'set foldmethod=syntax', '', '', 0, 's')
call g:quickmenu#append('Indent', 'set foldmethod=indnet', '', '', 0, 'i')
call quickmenu#current(12)
call quickmenu#reset()
call g:quickmenu#append('# Entertainment', '')
call g:quickmenu#append('Star Wars', 'StarWars', '', '', 0, '')
"}}}
"{{{vim-signify
"{{{vim-signify-usage
" <leader>g? 显示帮助
function Help_vim_signify()
    echo "<leader>gj    next hunk\n"
    echo "<leader>gk    previous hunk\n"
    echo "<leader>gJ    last hunk\n"
    echo "<leader>gK    first hunk\n"
    echo "<leader>gt    :SignifyToggle\n"
    echo "<leader>gh    :SignifyToggleHighlight\n"
    echo "<leader>gr    :SignifyRefresh\n"
    echo "<leader>gd    :SignifyDebug\n"
    echo "<leader>g?    Show this help\n"
endfunction
nnoremap <leader>g? :call Help_vim_signify()<CR>
"}}}
let g:signify_realtime = 0
let g:signify_disable_by_default = 0
let g:signify_line_highlight = 0
let g:signify_sign_show_count = 1
let g:signify_sign_show_text = 1
let g:signify_sign_add = '+'
let g:signify_sign_delete = '_'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change = '*'
let g:signify_sign_changedelete = g:signify_sign_change
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)
nmap <leader>gJ 9999<leader>gj
nmap <leader>gK 9999<leader>gk
nnoremap <leader>gt :<C-u>SignifyToggle<CR>
nnoremap <leader>gh :<C-u>SignifyToggleHighlight<CR>
nnoremap <leader>gr :<C-u>SignifyRefresh<CR>
nnoremap <leader>gd :<C-u>SignifyDebug<CR>
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)
let g:signify_difftool = 'diff'
let g:signify_vcs_list = [ 'git' ]  " 'accurev''bzr''cvs''darcs''fossil''git''hg''perforce''rcs''svn''tfs'
let g:signify_vcs_cmds = {
            \ 'git':      'git diff --no-color --no-ext-diff -U0 -- %f',
            \ 'hg':       'hg diff --config extensions.color=! --config defaults.diff= --nodates -U0 -- %f',
            \ 'svn':      'svn diff --diff-cmd %d -x -U0 -- %f',
            \ 'bzr':      'bzr diff --using %d --diff-options=-U0 -- %f',
            \ 'darcs':    'darcs diff --no-pause-for-gui --diff-command="%d -U0 %1 %2" -- %f',
            \ 'fossil':   'fossil set diff-command "%d -U 0" && fossil diff --unified -c 0 -- %f',
            \ 'cvs':      'cvs diff -U0 -- %f',
            \ 'rcs':      'rcsdiff -U0 %f 2>%n',
            \ 'accurev':  'accurev diff %f -- -U0',
            \ 'perforce': 'p4 info '. sy#util#shell_redirect('%n') . (has('win32') ? '' : ' env P4DIFF= P4COLORS=') .' p4 diff -du0 %f',
            \ 'tfs':      'tf diff -version:W -noprompt %f',
            \ }
let g:signify_vcs_cmds_diffmode = {
            \ 'git':      'git show HEAD:./%f',
            \ 'hg':       'hg cat %f',
            \ 'svn':      'svn cat %f',
            \ 'bzr':      'bzr cat %f',
            \ 'darcs':    'darcs show contents -- %f',
            \ 'cvs':      'cvs up -p -- %f 2>%n',
            \ 'perforce': 'p4 print %f',
            \ }
" let g:signify_skip_filetype = { 'vim': 1, 'c': 1 }
" let g:signify_skip_filename = { '/home/user/.vimrc': 1 }
"}}}
"{{{indentLine
"{{{indentLine-usage
" :LeadingSpaceToggle  切换显示Leading Space
" :IndentLinesToggle  切换显示indentLine
"}}}
let g:ExcludeIndentFileType_Universal = [ 'startify', 'nerdtree', 'codi', 'help', 'man' ]
let g:ExcludeIndentFileType_Special = [ 'markdown', 'json' ]
let g:indentLine_enabled = 1
let g:indentLine_leadingSpaceEnabled = 0
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
let g:indentLine_char = "\ue621"  " ¦┆│⎸ ▏  e621
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_fileTypeExclude = g:ExcludeIndentFileType_Universal + g:ExcludeIndentFileType_Special
let g:indentLine_setColors = 0  " disable overwrite with grey by default, use colorscheme instead
"}}}
"{{{vim-indent-guides
"{{{vim-indent-guides-usage
" :IndentGuidesToggle  切换显示vim-indent-guides
"}}}
let g:HasLoadIndentGuides = 0
function! InitIndentGuides()
    let g:indent_guides_enable_on_vim_startup = 0
    let g:indent_guides_exclude_filetypes = g:ExcludeIndentFileType_Universal
    let g:indent_guides_color_change_percent = 10
    let g:indent_guides_guide_size = 1
    let g:indent_guides_default_mapping = 0
    call plug#load('vim-indent-guides')
endfunction
function! ToggleIndent()
    if g:HasLoadIndentGuides == 0
        call InitIndentGuides()
        execute 'IndentGuidesToggle'
        let g:HasLoadIndentGuides = 1
    else
        execute 'IndentGuidesToggle'
    endif
endfunction
"}}}
"{{{limelight.vim
"{{{limelight.vim-usage
" <leader>mf  toggle focus mode
"}}}
let g:limelight_default_coefficient = 0.7
"}}}
"{{{goyo.vim
"{{{goyo.vim-usage
" <leader>mr  toggle reading mode
"}}}
let g:goyo_width = 95
let g:goyo_height = 85
let g:goyo_linenr = 0
"进入goyo模式后自动触发limelight,退出后则关闭
augroup Goyo_Config
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
augroup END
nnoremap <leader><CR> :<C-u>Goyo<CR>
"}}}
"{{{golden-ratio
"{{{golden-ratio-usage
" 主quickmenu
"}}}
" 默认关闭
let g:golden_ratio_autocommand = 0
"}}}
"{{{vim-hexokinase
let g:Hexokinase_highlighters = ['background']  " ['virtual', 'sign_column', 'background', 'foreground', 'foregroundfull']
let g:Hexokinase_ftAutoload = ['html', 'css', 'javascript', 'vim', 'colortemplate']  " ['*']
let g:Hexokinase_refreshEvents = ['BufWritePost']
let g:Hexokinase_optInPatterns = ['full_hex', 'triple_hex', 'rgb', 'rgba']  " ['full_hex', 'triple_hex', 'rgb', 'rgba', 'colour_names']
"}}}
" Productivity
"{{{LanguageClient-neovim
if g:VIM_LSP_Client ==# 'lcn'
    "{{{LanguageClient-neovim-usage
    function! Help_Language_Client_neovim()
        echo '<leader>ld        definition'
        echo '<leader>lt        typeDefinition'
        echo '<leader>lI        implementation'
        echo '<leader>lr        references'
        echo '<leader>lR        rename'
        echo '<leader>la        codeAction'
        echo '<leader>lf        formatting'
    endfunction
    "}}}
    " Server Register
    let g:LanguageClient_serverCommands = {
                \ 'c': ['clangd'],
                \ 'cpp': ['clangd'],
                \ 'objc': ['clangd'],
                \ 'objcpp': ['clangd'],
                \ 'css': ['css-languageserver', '--stdio'],
                \ 'html': ['html-languageserver', '--stdio'],
                \ 'json': ['json-languageserver', '--stdio'],
                \ 'python': ['pyls'],
                \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
                \ 'sh': ['bash-language-server', 'start'],
                \ 'yaml': ['yaml-language-server']
                \ }
    " Events
    augroup LanguageClientAu
        autocmd!
        autocmd User LanguageClientStarted setlocal signcolumn=auto
        autocmd User LanguageClientStopped setlocal signcolumn=auto
        autocmd CursorHold call LanguageClient#textDocument_hover()
        autocmd CursorHold call LanguageClient#textDocument_documentHighlight()
        autocmd CursorMoved call LanguageClient#textDocument_clearDocumentHighlight()
    augroup END
    " snippets
    let g:LanguageClient_hasSnippetSupport = 1
    if g:VIM_Snippets ==# 'ultisnips'
    elseif g:VIM_Snippets ==# 'neosnippet'
        let g:neosnippet#enable_complete_done = 1
    endif
    " AutoStart
    let g:LanguageClient_autoStart = 1
    " hoverPreview: Never Auto Always
    let g:LanguageClient_hoverPreview = 'Always'
    " Override Snippets
    let g:LanguageClient_hasSnippetSupport = 0
    " Completion
    set omnifunc=LanguageClient#complete
    " Formatting
    set formatexpr=LanguageClient_textDocument_rangeFormatting()
    " Interface
    " let g:LanguageClient_selectionUI = 'fzf'  " fzf quickfix location-list
    " Mappings
    nnoremap <silent> <leader>ld :<C-u>call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <leader>lt :<C-u>call LanguageClient#textDocument_typeDefinition()<CR>
    nnoremap <silent> <leader>lI :<C-u>call LanguageClient#textDocument_implementation()<CR>
    nnoremap <silent> <leader>lr :<C-u>call LanguageClient#textDocument_references()<CR>
    nnoremap <silent> <leader>lR :<C-u>call LanguageClient#textDocument_rename()<CR>
    nnoremap <silent> <leader>la :<C-u>call LanguageClient#textDocument_codeAction()<CR>
    nnoremap <silent> <leader>lf :<C-u>call LanguageClient#textDocument_formatting()<CR>
    vnoremap <silent> <leader>lf :<C-u>call LanguageClient#textDocument_rangeFormatting()<CR>
    if g:VIM_Fuzzy_Finder ==# 'denite' || g:VIM_Fuzzy_Finder ==# 'remix'
        call quickmenu#current(4)
        call quickmenu#reset()
        call g:quickmenu#append('# Language Server', '')
        call g:quickmenu#append('Context Menu', 'call LanguageClient_contextMenu()', 'Show context menu.', '', 0, '#')
        call g:quickmenu#append('Code Action', 'Denite codeAction', 'Show code actions at current location.', '', 0, 'a')
        call g:quickmenu#append('Symbol', 'Denite documentSymbol', "List of current buffer's symbols.", '', 0, 's')
        call g:quickmenu#append('Workspace Symbol', 'Denite workspaceSymbol', "List of project's symbols.", '', 0, 'S')
        call g:quickmenu#append('Apply Edit', 'call LanguageClient#workspace_applyEdit()', 'Apply a workspace edit.', '', 0, 'A')
        call g:quickmenu#append('Command', 'call LanguageClient#workspace_executeCommand()', 'Execute a workspace command.', '', 0, 'C')
        call g:quickmenu#append('Notify', 'call LanguageClient#Notify()', 'Send a notification to the current language server.', '', 0, 'n')
        call g:quickmenu#append('Start LSC', 'LanguageClientStart', '', '', 0, '$')
        call g:quickmenu#append('Stop LSC', 'LanguageClientStop', '', '', 0, '!')
        call g:quickmenu#append('Help', 'call Help_Language_Client_neovim()', '', '', 0, 'h')
        call g:quickmenu#append('# Completion Framework', '')
        call g:quickmenu#append('Completion Framework', 'call quickmenu#toggle(5)', '', '', 0, 'c')
    else
        call quickmenu#current(4)
        call quickmenu#reset()
        call g:quickmenu#append('# Language Server', '')
        call g:quickmenu#append('Context Menu', 'call LanguageClient_contextMenu()', 'Show context menu.', '', 0, '#')
        call g:quickmenu#append('Code Action', 'call LanguageClient#textDocument_codeAction()', 'Show code actions at current location.', '', 0, 'a')
        call g:quickmenu#append('Symbol', 'call LanguageClient#textDocument_documentSymbol()', "List of current buffer's symbols.", '', 0, 's')
        call g:quickmenu#append('Workspace Symbol', 'call LanguageClient#workspace_symbol()', "List of project's symbols.", '', 0, 'S')
        call g:quickmenu#append('Apply Edit', 'call LanguageClient#workspace_applyEdit()', 'Apply a workspace edit.', '', 0, 'A')
        call g:quickmenu#append('Command', 'call LanguageClient#workspace_executeCommand()', 'Execute a workspace command.', '', 0, 'C')
        call g:quickmenu#append('Notify', 'call LanguageClient#Notify()', 'Send a notification to the current language server.', '', 0, 'n')
        call g:quickmenu#append('Start LSC', 'LanguageClientStart', '', '', 0, '$')
        call g:quickmenu#append('Stop LSC', 'LanguageClientStop', '', '', 0, '!')
        call g:quickmenu#append('Help', 'call Help_Language_Client_neovim()', '', '', 0, 'h')
        call g:quickmenu#append('# Completion Framework', '')
        call g:quickmenu#append('Completion Framework', 'call quickmenu#toggle(5)', '', '', 0, 'c')
    endif
    let g:LanguageClient_diagnosticsDisplay = {
                \ 1: {
                \ 'name': 'Error',
                \ 'texthl': 'ALEError',
                \ 'signText': "\uf65b",
                \ 'signTexthl': 'ALEErrorSign',
                \ },
                \ 2: {
                \ 'name': 'Warning',
                \ 'texthl': 'ALEWarning',
                \ 'signText': "\uf421",
                \ 'signTexthl': 'ALEWarningSign',
                \ },
                \ 3: {
                \ 'name': 'Information',
                \ 'texthl': 'ALEInfo',
                \ 'signText': "\uf7fb",
                \ 'signTexthl': 'ALEInfoSign',
                \ },
                \ 4: {
                \ 'name': 'Hint',
                \ 'texthl': 'ALEInfo',
                \ 'signText': "\uf68a",
                \ 'signTexthl': 'ALEInfoSign',
                \ },
                \ }
    "}}}
    "{{{vim-lsp
elseif g:VIM_LSP_Client ==# 'vim-lsp'
    "{{{vim-lsp-usage
    function! Help_vim_lsp()
        echo '<leader>la        CodeAction'
        echo '<leader>ld        Definition'
        echo '<leader>lD        Declaration'
        echo '<leader>lt        TypeDefinition'
        echo '<leader>lr        References'
        echo '<leader>lR        Rename'
        echo '<leader>lI        Implementation'
        echo '<leader>lf        DocumentFormat'
        echo '<leader>lJ        NextError'
        echo '<leader>lK        PreviousError'
    endfunction
    "}}}
    let g:lsp_auto_enable = 1
    let g:lsp_signs_enabled = 1         " enable signs
    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
    let g:lsp_signs_error = {'text': "\uf65b"}
    let g:lsp_signs_warning = {'text': "\uf421"}
    let g:lsp_signs_hint = {'text': "\uf68a"}
    augroup VIM_LSP_Register
        autocmd!
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'html-languageserver',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
                    \ 'whitelist': ['html', 'htm', 'xml'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'css-languageserver',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
                    \ 'whitelist': ['css', 'less', 'sass'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'json-languageserver',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'json-languageserver --stdio']},
                    \ 'whitelist': ['json'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'python-languageserver',
                    \ 'cmd': {server_info->['pyls']},
                    \ 'whitelist': ['python'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'rls',
                    \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
                    \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
                    \ 'whitelist': ['rust'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'bash-languageserver',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
                    \ 'whitelist': ['sh'],
                    \ })
        au User lsp_setup call lsp#register_server({
                    \ 'name': 'yaml-languageserver',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'yaml-language-server']},
                    \ 'whitelist': ['yaml'],
                    \ })
    augroup END
    nnoremap <silent> <leader>la <plug>(lsp-code-action)
    nnoremap <silent> <leader>ld <plug>(lsp-definition)
    nnoremap <silent> <leader>lD <plug>(lsp-declaration)
    nnoremap <silent> <leader>lt <plug>(lsp-type-definition)
    nnoremap <silent> <leader>lr <plug>(lsp-references)
    nnoremap <silent> <leader>lR <plug>(lsp-rename)
    nnoremap <silent> <leader>lI <plug>(lsp-implementation)
    nnoremap <silent> <leader>lJ <plug>(lsp-next-error)
    nnoremap <silent> <leader>lK <plug>(lsp-previous-error)
    nnoremap <silent> <leader>lf :<C-u>LspDocumentFormat<CR>
    vnoremap <silent> <leader>lf :<C-u>LspDocumentRangeFormat<CR>
    call quickmenu#current(4)
    call quickmenu#reset()
    call g:quickmenu#append('# Language Server', '')
    call g:quickmenu#append('DocumentSymbol', 'LspDocumentSymbol', 'Gets the symbols for the current document.', '', 0, 's')
    call g:quickmenu#append('WorkspaceSymbols', 'LspWorkspaceSymbols', 'Search and show workspace symbols.', '', 0, 'S')
    call g:quickmenu#append('Diagnostics', 'LspDocumentDiagnostics', 'Gets the current document diagnostics.', '', 0, 'e')
    call g:quickmenu#append('Hover', 'LspHover', 'Gets the hover information. Close preview window: <c-w><c-z>', '', 0, 'h')
    call g:quickmenu#append('Status', 'LspStatus', '', '', 0, '*')
    call g:quickmenu#append('Start LSC', 'call lsp#enable()', '', '', 0, '$')
    call g:quickmenu#append('Stop LSC', 'call lsp#disable()', '', '', 0, '!')
    call g:quickmenu#append('Help', 'call Help_vim_lsp()', '', '', 0, 'H')
    call g:quickmenu#append('# Completion Framework', '')
    call g:quickmenu#append('Completion Framework', 'call quickmenu#toggle(5)', '', '', 0, 'c')
    vnoremap lf :<C-u>LspDocumentRangeFormat<CR>
endif
"}}}
"{{{ultisnips
if g:VIM_Snippets ==# 'ultisnips'
    "{{{ultisnips-usage
    " Ctrl+J展开或跳转到下一个
    " Ctrl+K跳转到上一个
    "}}}
    let g:UltiSnipsRemoveSelectModeMappings = 0
    let g:UltiSnipsJumpForwardTrigger       = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger      = '<C-k>'
    let g:UltiSnipsExpandTrigger            = '<A-z>``l'
    " let g:UltiSnipsListSnippets = "<A-y>l"
    " let g:UltiSnipsEditSplit="vertical"
    "}}}
    "{{{neosnippet.vim
    "{{{neosnippet-usage
    " <C-J>展开或跳转到下一个
    "}}}
elseif g:VIM_Snippets ==# 'neosnippet' && g:VIM_Completion_Framework !=# 'coc'
    imap <C-j>     <Plug>(neosnippet_expand_or_jump)
    smap <C-j>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-j>     <Plug>(neosnippet_expand_target)
    if has('conceal')
        set conceallevel=2 concealcursor=niv
    endif
    let g:neosnippet#snippets_directory = expand('~/.cache/vim/plugins/vim-snippets/snippets')
endif
"}}}
"{{{deoplete.nvim
if g:VIM_Completion_Framework ==# 'deoplete'
    "{{{deoplete-usage
    " <Tab> <S-Tab> 分别向下和向上选中，
    " <S-Tab>当没有显示补全栏的时候手动呼出补全栏
    "}}}
    "{{{quickmenu
    call quickmenu#current(5)
    call quickmenu#reset()
    call g:quickmenu#append('# Deoplete', '')
    call g:quickmenu#append('Toggle Word Completion', 'call Func_ToggleDeopleteWords()', '', '', 0, 'w')
    "}}}
    "{{{extensions
    let g:necosyntax#min_keyword_length = 3
    " deoplete-jedi
    " https://github.com/zchee/deoplete-jedi
    let g:tmuxcomplete#trigger = ''
    "}}}
    let g:deoplete#enable_at_startup = 0
    augroup Deoplete_Au
        autocmd!
        autocmd InsertEnter * call deoplete#enable()
        autocmd VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
    call deoplete#custom#option({
                \ 'auto_complete_delay': 0,
                \ 'smart_case': v:true,
                \ })
    if !has('nvim')
        call deoplete#custom#option({'yarp': v:true})
    endif
    call deoplete#custom#var('around', {
                \   'range_above': 100,
                \   'range_below': 100,
                \   'mark_above': '[↑]',
                \   'mark_below': '[↓]',
                \   'mark_changes': '[*]',
                \})
    if g:VIM_Snippets ==# 'ultisnips'
        let g:UltiSnipsExpandTrigger            = '<C-j>'
    endif
    inoremap <silent><expr> <S-TAB>
                \ pumvisible() ? "\<C-p>" :
                \ <SID>check_back_space() ? "\<S-TAB>" :
                \ deoplete#mappings#manual_complete()
    function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction"}}}
    inoremap <expr> <up> pumvisible() ? deoplete#close_popup()."\<up>" : "\<up>"
    inoremap <expr> <down> pumvisible() ? deoplete#close_popup()."\<down>" : "\<down>"
    inoremap <expr> <left> pumvisible() ? deoplete#close_popup()."\<left>" : "\<left>"
    inoremap <expr> <right> pumvisible() ? deoplete#close_popup()."\<right>" : "\<right>"
    imap <expr> <CR> pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
    imap <expr> <C-z> pumvisible() ? "\<C-e>" : "\<C-z>"
    let g:Deoplete_Word_Completion_Enable = 0
    function! Func_ToggleDeopleteWords()
        if g:Deoplete_Word_Completion_Enable == 1
            let g:Deoplete_Word_Completion_Enable = 0
            setlocal dictionary+=/usr/share/dict/words
            setlocal dictionary+=/usr/share/dict/american-english
            call deoplete#custom#source(
                        \ 'dictionary', 'min_pattern_length', 4)
            call deoplete#custom#source(
                        \ 'dictionary', 'matchers', ['matcher_head'])
        elseif g:Deoplete_Word_Completion_Enable == 0
            let g:Deoplete_Word_Completion_Enable = 1
            setlocal dictionary-=/usr/share/dict/words
            setlocal dictionary-=/usr/share/dict/american-english
            call deoplete#custom#source(
                        \ 'dictionary', 'min_pattern_length', 4)
            call deoplete#custom#source(
                        \ 'dictionary', 'matchers', ['matcher_head'])
        endif
    endfunction
    " autocmd BufNewFile,BufRead *.md call Func_ToggleDeopleteWords()
    set completeopt-=preview
    function Multiple_cursors_before()
        let g:deoplete#disable_auto_complete = 1
    endfunction
    function Multiple_cursors_after()
        let g:deoplete#disable_auto_complete = 0
    endfunction
    "}}}
    "{{{ncm2
elseif g:VIM_Completion_Framework ==# 'ncm2'
    "{{{ncm2-usage
    " <Tab> <S-Tab> 分别向下和向上选中，
    " <S-Tab>当没有显示补全栏的时候手动呼出补全栏
    "}}}
    "{{{quickmenu
    call quickmenu#current(5)
    call quickmenu#reset()
    call g:quickmenu#append('# NCM2', '')
    call g:quickmenu#append('Toggle Word Completion', 'call Func_ToggleNcm2Look()', '', '', 0, 'w')
    "}}}
    "{{{ncm2-extensions
    "{{{ncm2-ultisnips
    if g:VIM_Snippets ==# 'ultisnips'
        imap <expr> <C-j> pumvisible() ? "\<Plug>(ncm2_ultisnips_expand_completed)" : "\<C-j>"
        "}}}
        "{{{ncm2-neosnippet
    elseif g:VIM_Snippets ==# 'neosnippet'
        imap <expr> <C-j> pumvisible() ? "\<Plug>(ncm2_neosnippet_expand_completed)" : "\<C-j>"
    endif
    "}}}
    "{{{ncm2-pyclang
    let g:ncm2_pyclang#library_path = '/usr/lib'
    "}}}
    "{{{ncm2-look.vim
    " enable ncm2 for all buffer
    augroup ncm2_enable_for_buffer
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
    augroup END
    " note that must keep noinsert in completeopt, the others is optional
    set completeopt=noinsert,menuone,noselect
    " Enable && Disable Globally
    let g:ncm2_look_enabled = 0
    " Enable Command
    function! Func_ToggleNcm2Look()
        if g:ncm2_look_enabled == 1
            let g:ncm2_look_enabled = 0
        elseif g:ncm2_look_enabled == 0
            let g:ncm2_look_enabled = 1
        endif
    endfunction
    " autocmd BufNewFile,BufRead *.md call Func_ToggleNcm2Look()
    " Symbol
    let g:ncm2_look_mark = "\uf02d"
    "}}}
    "{{{tmux-complete.vim
    let g:tmuxcomplete#trigger = ''
    "}}}
    "}}}
    augroup NCM2_Config
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
        autocmd TextChangedI * call ncm2#auto_trigger()  " enable auto complete for `<backspace>`, `<c-w>` keys
        autocmd VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
    set completeopt=noinsert,menuone,noselect
    imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Plug>(ncm2_manual_trigger)\<C-n>"
    inoremap <expr> <up> pumvisible() ? "\<C-y>\<up>" : "\<up>"
    inoremap <expr> <down> pumvisible() ? "\<C-y>\<down>" : "\<down>"
    inoremap <expr> <left> pumvisible() ? "\<C-y>\<left>" : "\<left>"
    inoremap <expr> <right> pumvisible() ? "\<C-y>\<right>" : "\<right>"
    imap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
    imap <expr> <C-z> pumvisible() ? "\<C-e>" : "\<C-z>"
    "}}}
    "{{{asyncomplete
elseif g:VIM_Completion_Framework ==# 'asyncomplete'
    "{{{asyncomplete-usage
    " <Tab> <S-Tab> 分别向下和向上选中，
    " <S-Tab>当没有显示补全栏的时候手动呼出补全栏
    "}}}
    "{{{quickmenu
    call quickmenu#current(5)
    call quickmenu#reset()
    call g:quickmenu#append('# Asyncomplete', '')
    "}}}
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Plug>(asyncomplete_force_refresh)\<C-n>"
    inoremap <expr> <up> pumvisible() ? "\<C-y>\<up>" : "\<up>"
    inoremap <expr> <down> pumvisible() ? "\<C-y>\<down>" : "\<down>"
    inoremap <expr> <left> pumvisible() ? "\<C-y>\<left>" : "\<left>"
    inoremap <expr> <right> pumvisible() ? "\<C-y>\<right>" : "\<right>"
    imap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
    imap <expr> <C-z> pumvisible() ? "\<C-e>" : "\<C-z>"
    if g:VIM_Snippets ==# 'ultisnips'
        imap <expr> <C-j> pumvisible() ? "\<A-z>\`\`\l" : "\<C-j>"
    endif
    let g:asyncomplete_remove_duplicates = 1
    let g:asyncomplete_smart_completion = 1
    let g:asyncomplete_auto_popup = 1
    set completeopt-=preview
    augroup Asyncomplete_Au
        autocmd!
        autocmd InsertEnter * call Asyncomplete_Register()
        autocmd VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
    function! Asyncomplete_Register()
        call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                    \ 'name': 'buffer',
                    \ 'whitelist': ['*'],
                    \ 'completor': function('asyncomplete#sources#buffer#completor'),
                    \ }))
        call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                    \ 'name': 'file',
                    \ 'whitelist': ['*'],
                    \ 'priority': 10,
                    \ 'completor': function('asyncomplete#sources#file#completor')
                    \ }))
        call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
                    \ 'name': 'neoinclude',
                    \ 'whitelist': ['c', 'cpp'],
                    \ 'refresh_pattern': '\(<\|"\|/\)$',
                    \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
                    \ }))
        call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
                    \ 'name': 'necosyntax',
                    \ 'whitelist': ['*'],
                    \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
                    \ }))
        call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
                    \ 'name': 'necovim',
                    \ 'whitelist': ['vim'],
                    \ 'completor': function('asyncomplete#sources#necovim#completor'),
                    \ }))
        if g:VIM_Snippets ==# 'ultisnips'
            call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
                        \ 'name': 'ultisnips',
                        \ 'whitelist': ['*'],
                        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
                        \ }))
        elseif g:VIM_Snippets ==# 'neosnippet'
            call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
                        \ 'name': 'neosnippet',
                        \ 'whitelist': ['*'],
                        \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
                        \ }))
        endif
        call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                    \ 'name': 'tags',
                    \ 'completor': function('asyncomplete#sources#tags#completor'),
                    \ 'config': {
                    \    'max_file_size': 50000000,
                    \  },
                    \ }))
        let g:tmuxcomplete#asyncomplete_source_options = {
                    \ 'name':      'tmuxcomplete',
                    \ 'whitelist': ['*'],
                    \ 'config': {
                    \     'splitmode':      'words',
                    \     'filter_prefix':   1,
                    \     'show_incomplete': 1,
                    \     'sort_candidates': 0,
                    \     'scrollback':      0,
                    \     'truncate':        0
                    \     }
                    \ }
        let g:tmuxcomplete#trigger = ''
    endfunction
    "}}}
    "{{{coc.nvim
elseif g:VIM_Completion_Framework ==# 'coc'
    "{{{coc.nvim-usage
    function Help_COC_LSP()
        echo '<leader>lJ        diagnostic-next'
        echo '<leader>lJ        diagnostic-next'
        echo '<leader>lK        diagnostic-prev'
        echo '<leader>li        diagnostic-info'
        echo '<leader>lI        implementation'
        echo '<leader>ld        definition'
        echo '<leader>lD        declaration'
        echo '<leader>lt        type-definition'
        echo '<leader>lr        references'
        echo '<leader>lR        rename'
        echo '<leader>lf        format'
        echo '<leader>lf        format-selected'
        echo '<leader>lF        fix-current'
        echo '<leader>la        codeaction'
        echo '<leader>la        codeaction-selected'
        echo '<leader>lA        codelens-action'
        echo '<C-l>             jump to floating window'
    endfunction
    "}}}
    "{{{coc-functions
    function! CocHighlight() abort"{{{
        if &filetype !=# 'markdown'
            call CocActionAsync('highlight')
        endif
    endfunction"}}}
    function! CocFloatingLockToggle() abort"{{{
        if g:CocFloatingLock == 0
            let g:CocFloatingLock = 1
        elseif g:CocFloatingLock == 1
            let g:CocFloatingLock = 0
        endif
    endfunction"}}}
    function! CocHover() abort"{{{
        if !coc#util#has_float() && g:CocHoverEnable == 1
            call CocActionAsync('doHover')
            call CocActionAsync('showSignatureHelp')
        endif
    endfunction"}}}
    "}}}
    "{{{quickmenu
    call quickmenu#current(4)
    call quickmenu#reset()
    call g:quickmenu#append('List', 'CocList', '', '', 0, 'l')
    call g:quickmenu#append('# Language Server', '')
    call g:quickmenu#append('Symbols', 'Denite coc-symbols', '', '', 0, 's')
    call g:quickmenu#append('Symbols Workspace', 'Denite coc-workspace', '', '', 0, 'S')
    call g:quickmenu#append('Diagnostic Lists', 'Denite coc-diagnostic', '', '', 0, 'd')
    call g:quickmenu#append('Command', "call CocActionAsync('runCommand')", 'Run global command provided by language server.', '', 0, 'c')
    call g:quickmenu#append('Help', 'call Help_COC_LSP()', '', '', 0, 'h')
    call g:quickmenu#append('# Completion Framework', '')
    call g:quickmenu#append('Restart', 'CocRestart', '', '', 0, '@')
    call g:quickmenu#append('Update Extensions', 'CocUpdate', '', '', 0, 'U')
    call g:quickmenu#append('Rebuild Extensions', 'CocRebuild', '', '', 0, 'B')
    call g:quickmenu#append('Info', 'CocInfo', ':h CocOpenLog for log', '', 0, '@')
    call g:quickmenu#append('Toggle Hover', 'let g:CocHoverEnable = g:CocHoverEnable == 1 ? 0 : 1', '', '', 0, 't')
    call g:quickmenu#append('Extension Market', 'CocList marketplace', '', '', 0, '#')
    call g:quickmenu#append('Help Mappings', 'Denite output:nnoremap output:vnoremap -input="<Plug>(coc)"', '', '', 0, '?')
    "}}}
    "{{{coc-init
    if g:VIM_Snippets ==# 'ultisnips'
        let g:Coc_Snippet = 'coc-ultisnips'
    elseif g:VIM_Snippets ==# 'coc-snippets'
        let g:Coc_Snippet = 'coc-snippets'
    endif
    call coc#add_extension(
                \       'coc-lists',
                \       'coc-marketplace',
                \       g:Coc_Snippet,
                \       'coc-syntax',
                \       'coc-highlight',
                \       'coc-emoji',
                \       'coc-dictionary',
                \       'coc-html',
                \       'coc-css',
                \       'coc-emmet',
                \       'coc-rls',
                \       'coc-json',
                \       'coc-yaml',
                \       'coc-vimlsp'
                \   )
    if g:VIM_Enable_Autopairs == 0
        call coc#add_extension( 'coc-pairs' )
    endif
    "}}}
    "{{{coc-settings
    augroup CocAu
        autocmd!
        autocmd CursorHold * silent call CocHover()
        autocmd CursorHold * silent call CocHighlight()
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        autocmd InsertEnter * call coc#util#float_hide()
        autocmd VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
    let g:CocHoverEnable = 0
    let g:tmuxcomplete#trigger = ''
    set hidden
    set completeopt=noinsert,noselect,menuone
    set dictionary+=/usr/share/dict/words
    set dictionary+=/usr/share/dict/american-english
    highlight CocHighlightText cterm=bold gui=bold
    highlight CocErrorHighlight ctermfg=Gray guifg=#888888
    highlight CocCodeLens ctermfg=Gray guifg=#888888
    "}}}
    "{{{coc-mappings
    inoremap <expr> <C-j> pumvisible() ? "\<C-y>" : "\<C-j>"
    inoremap <expr> <up> pumvisible() ? "\<Space>\<Backspace>\<up>" : "\<up>"
    inoremap <expr> <down> pumvisible() ? "\<Space>\<Backspace>\<down>" : "\<down>"
    inoremap <expr> <left> pumvisible() ? "\<Space>\<Backspace>\<left>" : "\<left>"
    inoremap <expr> <right> pumvisible() ? "\<Space>\<Backspace>\<right>" : "\<right>"
    imap <expr> <CR> pumvisible() ? "\<Space>\<Backspace>\<CR>" : "\<CR>"
    imap <expr> <C-z> pumvisible() ? "\<C-e>" : "<C-z>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-n>"
    " nnoremap <expr><C-l> coc#util#has_float() ? win_gotoid(coc#util#get_float()) : "\<C-l>"
    nnoremap <silent> <leader>lJ <Plug>(coc-diagnostic-next)
    nnoremap <silent> <leader>lK <Plug>(coc-diagnostic-prev)
    nnoremap <silent> <leader>li <Plug>(coc-diagnostic-info)
    nnoremap <silent> <leader>lI <Plug>(coc-implementation)
    nnoremap <silent> <leader>ld <Plug>(coc-definition)
    nnoremap <silent> <leader>lD <Plug>(coc-declaration)
    nnoremap <silent> <leader>lt <Plug>(coc-type-definition)
    nnoremap <silent> <leader>lr <Plug>(coc-references)
    nnoremap <silent> <leader>lR <Plug>(coc-rename)
    nnoremap <silent> <leader>lf <Plug>(coc-format)
    vnoremap <silent> <leader>lf <Plug>(coc-format-selected)
    nnoremap <silent> <leader>lF <Plug>(coc-fix-current)
    nnoremap <silent> <leader>la <Plug>(coc-codeaction)
    vnoremap <silent> <leader>la <Plug>(coc-codeaction-selected)
    nnoremap <silent> <leader>lA <Plug>(coc-codelens-action)
    "}}}
    "}}}
    "{{{neocomplete.vim
elseif g:VIM_Completion_Framework ==# 'neocomplete'
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#auto_completion_start_length = 2
    let g:neocomplete#auto_complete_delay = 50
    let g:neocomplete#enable_auto_select = 1
    let g:neocomplete#skip_auto_completion_time = ''
    set completeopt-=preview
    augroup NeocompleteAu
        autocmd!
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd VimEnter * inoremap <expr> <Tab> (pumvisible() ? "\<C-n>" : "\<Tab>")
    augroup END
    let g:tmuxcomplete#trigger = ''
    if g:VIM_Snippets ==# 'ultisnips'
        imap <expr> <C-j> pumvisible() ? "\<A-z>\`\`\l" : "\<C-j>"
    endif
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : neocomplete#start_manual_complete()."\<C-n>"
    inoremap <expr> <up> pumvisible() ? neocomplete#smart_close_popup()."\<up>" : "\<up>"
    inoremap <expr> <down> pumvisible() ? neocomplete#smart_close_popup()."\<down>" : "\<down>"
    inoremap <expr> <left> pumvisible() ? neocomplete#smart_close_popup()."\<left>" : "\<left>"
    inoremap <expr> <right> pumvisible() ? neocomplete#smart_close_popup()."\<right>" : "\<right>"
    imap <expr> <CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"
    imap <expr> <C-z> pumvisible() ? "\<C-e>" : "\<C-z>"
endif
"}}}
"{{{denite.nvim
if g:VIM_Fuzzy_Finder ==# 'denite' || g:VIM_Fuzzy_Finder ==# 'remix'
    "{{{denite.nvim-usage
    " f  cwd search
    " F  pwd search
    function! Help_denite_mappings()
        echo 'customized mappings'
        echo "\n"
        echo '"insert" mode mappings.'
        echo '{key}           {mapping}'
        echo '--------        -----------------------------'
        echo '<C-j>           <denite:move_to_next_line>'
        echo '<C-k>           <denite:move_to_previous_line>'
        echo '<S-left>        <denite:move_caret_to_head>'
        echo '<S-right>       <denite:move_caret_to_tail>'
        echo '<A-x>       <denite:enter_mode:normal>'
        echo '<C-v>           <denite:paste_from_register>'
        echo '<C-p>           <denite:do_action:preview>'
        echo '<C-d>           <denite:do_action:delete>'
        echo '<C-e>           <denite:do_action:edit>'
        echo '<S-Tab>         <denite:do_action:cd>'
        echo '"normal" mode mappings.'
        echo '{key}           {mapping}'
        echo '--------        -----------------------------'
        echo "\n"
        echo ':h denite-key-mappings'
        echo "\n"
        echo "\n"
        echo 'default mappings'
        echo "\n"
        echo '{key}           {mapping}'
        echo '--------        -----------------------------'
        echo '<C-M>           <denite:do_action:default>'
        echo '<C-Z>           <denite:suspend>'
        echo '<CR>            <denite:do_action:default>'
        echo '<Esc>           <denite:leave_mode>'
        echo '<Tab>           <denite:choose_action>'
        echo '"insert" mode mappings.'
        echo '{key}           {mapping}'
        echo '--------        -----------------------------'
        echo '<BS>            <denite:delete_char_before_caret>'
        echo '<C-B>           <denite:move_caret_to_head>'
        echo '<C-E>           <denite:move_caret_to_tail>'
        echo '<C-G>           <denite:move_to_next_line>'
        echo '<C-H>           <denite:delete_char_before_caret>'
        echo '<C-J>           <denite:input_command_line>'
        echo '<C-K>           <denite:insert_digraph>'
        echo '<C-L>           <denite:redraw>'
        echo '<C-Left>        <denite:move_caret_to_one_word_left>'
        echo '<C-N>           <denite:assign_next_text>'
        echo '<C-O>           <denite:enter_mode:normal>'
        echo '<C-P>           <denite:assign_previous_text>'
        echo '<C-Q>           <denite:insert_special>'
        echo '<C-R>           <denite:paste_from_register>'
        echo '<C-Right>       <denite:move_caret_to_one_word_right>'
        echo '<C-T>           <denite:move_to_previous_line>'
        echo '<C-U>           <denite:delete_entire_text>'
        echo '<C-V>           <denite:do_action:preview>'
        echo '<C-W>           <denite:delete_word_before_caret>'
        echo '<DEL>           <denite:delete_word_under_caret>'
        echo '<Down>          <denite:assign_next_matched_text>'
        echo '<End>           <denite:move_caret_to_tail>'
        echo '<Home>          <denite:move_caret_to_head>'
        echo '<Insert>        <denite:toggle_insert_mode>'
        echo '<Left>          <denite:move_caret_to_left>'
        echo '<PageDown>      <denite:assign_next_text>'
        echo '<PageUp>        <denite:assign_previous_text>'
        echo '<Right>         <denite:move_caret_to_right>'
        echo '<S-Down>        <denite:assign_next_text>'
        echo '<S-Left>        <denite:move_caret_to_one_word_left>'
        echo '<S-Right>       <denite:move_caret_to_one_word_right>'
        echo '<S-Up>          <denite:assign_previous_text>'
        echo '<Up>            <denite:assign_previous_matched_text>'
        echo '"normal" mode mappings.'
        echo '{key}           {mapping}'
        echo '--------        -----------------------------'
        echo '$               <denite:move_caret_to_tail>'
        echo '*               <denite:toggle_select_all>'
        echo '0               <denite:move_caret_to_head>'
        echo '<C-B>           <denite:scroll_page_backwards>'
        echo '<C-D>           <denite:scroll_window_downwards>'
        echo '<C-E>           <denite:scroll_window_up_one_line>'
        echo '<C-F>           <denite:scroll_page_forwards>'
        echo '<C-L>           <denite:redraw>'
        echo '<C-R>           <denite:restart>'
        echo '<C-U>           <denite:scroll_window_upwards>'
        echo '<C-Y>           <denite:scroll_window_down_one_line>'
        echo '<C-w>P          <denite:wincmd:P>'
        echo '<C-w>W          <denite:wincmd:W>'
        echo '<C-w>b          <denite:wincmd:b>'
        echo '<C-w>h          <denite:wincmd:h>'
        echo '<C-w>j          <denite:wincmd:j>'
        echo '<C-w>k          <denite:wincmd:k>'
        echo '<C-w>l          <denite:wincmd:l>'
        echo '<C-w>p          <denite:wincmd:p>'
        echo '<C-w>t          <denite:wincmd:t>'
        echo '<C-w>w          <denite:wincmd:w>'
        echo '<Space>         <denite:toggle_select_down>'
        echo 'A               <denite:append_to_line>'
        echo 'G               <denite:move_to_last_line>'
        echo 'H               <denite:move_to_top>'
        echo 'I               <denite:insert_to_head>'
        echo 'L               <denite:move_to_bottom>'
        echo 'M               <denite:print_messages>'
        echo 'P               <denite:change_path>'
        echo 'S               <denite:change_line>'
        echo 'U               <denite:move_up_path>'
        echo 'X               <denite:quick_move>'
        echo 'a               <denite:append>'
        echo 'b               <denite:move_caret_to_one_word_left>'
        echo 'cc              <denite:change_line>'
        echo 'cw              <denite:change_word>'
        echo 'd               <denite:do_action:delete>'
        echo 'e               <denite:do_action:edit>'
        echo 'gg              <denite:move_to_first_line>'
        echo 'h               <denite:move_caret_to_left>'
        echo 'i               <denite:enter_mode:insert>'
        echo 'j               <denite:move_to_next_line>'
        echo 'k               <denite:move_to_previous_line>'
        echo 'l               <denite:move_caret_to_right>'
        echo 'n               <denite:do_action:new>'
        echo 'p               <denite:do_action:preview>'
        echo 'q               <denite:quit>'
        echo 's               <denite:change_char>'
        echo 't               <denite:do_action:tabopen>'
        echo 'w               <denite:move_caret_to_next_word>'
        echo 'x               <denite:delete_char_under_caret>'
        echo 'y               <denite:do_action:yank>'
        echo 'zb              <denite:scroll_cursor_to_bottom>'
        echo 'zt              <denite:scroll_cursor_to_top>'
        echo 'zz              <denite:scroll_cursor_to_middle>'
        echo '<ScrollWheelUp>         <denite:scroll_window_down_one_line>'
        echo '<ScrollWheelDown>       <denite:scroll_window_downwards>'
    endfunction
    "}}}
    "{{{quickmenu
    " :h denite-commands
    " :h denite-options
    call quickmenu#current(1)
    call quickmenu#reset()
    if g:VIM_Fuzzy_Finder ==# 'denite'
        noremap <silent> f :call quickmenu#toggle(1)<cr>
    elseif g:VIM_Fuzzy_Finder ==# 'remix'
        noremap <silent> <leader>F :call quickmenu#toggle(1)<cr>
    endif
    call g:quickmenu#append('# Denite', '')
    call g:quickmenu#append('      Source', 'Denite source', '', '', 0, '#')
    if g:VIM_Linter ==# 'ale'
        call g:quickmenu#append('      Lint', 'Denite ale', '', '', 0, '>')
    elseif g:VIM_Linter ==# 'neomake'
        call g:quickmenu#append('      Lint', 'Denite neomake', '', '', 0, '>')
    endif
    call g:quickmenu#append('      Line Buffer', 'Denite line:buffers', '', '', 0, 'l')
    call g:quickmenu#append('      Line All', 'Denite line:all', '', '', 0, 'L')
    call g:quickmenu#append('  Line Backward', 'Denite line:backward', '', '', 0, 'L<up>')
    call g:quickmenu#append('Line Forward', 'Denite line:forward', '', '', 0, 'L<down>')
    call g:quickmenu#append('      Buffer', 'Denite buffer -default-action="switch"', '', '', 0, 'b')
    call g:quickmenu#append('      Buffer!', 'Denite buffer', '', '', 0, 'B')
    call g:quickmenu#append('      File MRU', 'Denite file_mru', '', '', 0, 'f')
    call g:quickmenu#append('      File', 'Denite file_rec', '', '', 0, 'F')
    call g:quickmenu#append('      Marks', 'Denite mark', '', '', 0, 'm')
    call g:quickmenu#append('      Directory MRU', 'Denite directory_mru', '', '', 0, 'd')
    call g:quickmenu#append('      Directory', 'Denite directory_rec', '', '', 0, 'D')
    call g:quickmenu#append('      Outline', 'Denite outline', '', '', 0, 't')
    call g:quickmenu#append('      Gtags', 'Denite source -input="gtags"', '', '', 0, 'T')
    call g:quickmenu#append('     Git Status', 'Denite gitstatus', '', '', 0, 'gs')
    call g:quickmenu#append('     Git Changed', 'Denite gitchanged', '', '', 0, 'gc')
    call g:quickmenu#append('     Git Branch', 'Denite gitbranch', '', '', 0, 'gb')
    call g:quickmenu#append('     Git Log', 'Denite gitlog', '', '', 0, 'gl')
    call g:quickmenu#append('     Git Log All', 'Denite gitlog', '', '', 0, 'gL')
    call g:quickmenu#append('      Register', 'Denite register', '', '', 0, 'r')
    call g:quickmenu#append('      Prosessions', 'Denite prosession', '', '', 0, 's')
    call g:quickmenu#append('     History Fils', 'Denite file/old', '', '', 0, 'hf')
    call g:quickmenu#append('     History Command', 'Denite command_history', '', '', 0, 'hc')
    call g:quickmenu#append('      Commands', 'Denite commands', '', '', 0, 'c')
    call g:quickmenu#append('     Key Mappings', 'Denite keymap:n', '', '', 0, 'MN')
    call g:quickmenu#append('     Key Mappings', 'Denite keymap:i', '', '', 0, 'MI')
    call g:quickmenu#append('     Key Mappings', 'Denite keymap:v', '', '', 0, 'MV')
    call g:quickmenu#append('      Help Tags', 'Denite help', '', '', 0, 'H')
    call g:quickmenu#append('      Change', 'Denite change', '', '', 0, 'C')
    call g:quickmenu#append('      Project', 'Denite project', '', '', 0, 'p')
    call g:quickmenu#append('      Location List', 'Denite location_list', '', '', 0, 'i')
    call g:quickmenu#append('      Quickfix', 'Denite quickfix', '', '', 0, 'q')
    call g:quickmenu#append('      Man', 'Denite man', '', '', 0, '$')
    call g:quickmenu#append('      Grep', 'Denite grep', '', '', 0, 'G')
    call g:quickmenu#append('      Github Stars', 'Denite github_stars', '', '', 0, '*')
    call g:quickmenu#append('      Help Mappings', 'call Help_denite_mappings()', '', '', 0, '?')
    "}}}
    "{{{mappings
    " :h denite-kinds
    call denite#custom#map(
                \ 'insert',
                \ '<S-left>',
                \ '<denite:move_caret_to_head>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<S-right>',
                \ '<denite:move_caret_to_tail>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<A-x>',
                \ '<denite:enter_mode:normal>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-v>',
                \ '<denite:paste_from_register>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-p>',
                \ '<denite:do_action:preview>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-j>',
                \ '<denite:move_to_next_line>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-k>',
                \ '<denite:move_to_previous_line>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-d>',
                \ '<denite:do_action:delete>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<C-e>',
                \ '<denite:do_action:edit>',
                \ 'noremap'
                \)
    call denite#custom#map(
                \ 'insert',
                \ '<S-Tab>',
                \ '<denite:do_action:cd>',
                \ 'noremap'
                \)
    "}}}
    augroup DeniteAu
        autocmd!
        autocmd User CocQuickfixChange :Denite -mode=normal quickfix
    augroup END
    let dgs#username='sainnhe'
    let g:fruzzy#usenative = 1
    " Customize Var
    " call denite#custom#var('grep', 'command', ['ag'])
    " call denite#custom#var('grep', 'default_opts',
    "             \ ['-i', '--vimgrep'])
    " call denite#custom#var('grep', 'recursive_opts', [])
    " call denite#custom#var('grep', 'pattern_opt', [])
    " call denite#custom#var('grep', 'separator', ['--'])
    " call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
                \ ['-i', '--vimgrep', '--no-heading', '--no-ignore'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('outline', 'command', ['ctags'])
    call denite#custom#var('outline', 'options', [])
    call denite#custom#var('outline', 'file_opt', '-o')
    call denite#custom#var('outline', 'ignore_types', [])
    call denite#custom#var('outline', 'encoding', 'utf-8')
    " customize options
    call denite#custom#option('default', {
                \ 'prompt': '➤ ',
                \ 'short_source_names': v:false
                \ })
    " customize sources
    " :h denite-sources
    " :h denite-source-attributes
    " :h denite-filters
    call denite#custom#source('_', 'matchers', ['matcher/cpsm'])  " matcher/fuzzy matcher/fruzzy matcher/cpsm
    call denite#custom#source('_', 'sorters', [])  " sorter/sublime (sorter/rank)
    " if in git dir, git ls-files for file/rec
    call denite#custom#alias('source', 'file/rec/git', 'file/rec')
    call denite#custom#var('file/rec/git', 'command',
                \ ['git', 'ls-files', '-co', '--exclude-standard'])
endif
"}}}
"{{{fzf.vim
if g:VIM_Fuzzy_Finder ==# 'fzf' || g:VIM_Fuzzy_Finder ==# 'remix'
    "{{{fzf.vim-usage
    " grep中用<C-p>预览
    "}}}
    "{{{quickmenu
    if g:VIM_Fuzzy_Finder ==# 'fzf'
        call quickmenu#current(1)
        call quickmenu#reset()
        noremap <silent> f :call quickmenu#toggle(1)<cr>
    elseif g:VIM_Fuzzy_Finder ==# 'remix'
        call quickmenu#current(2)
        call quickmenu#reset()
        noremap <silent> <leader>f :call quickmenu#toggle(2)<cr>
    endif
    call g:quickmenu#append('# FZF', '')
    call g:quickmenu#append(' Line Buffer', 'BLines', '', '', 0, 'l')
    call g:quickmenu#append(' Line All', 'Lines', '', '', 0, 'L')
    call g:quickmenu#append(' MRU', 'History', '', '', 0, 'f')
    call g:quickmenu#append(' File', 'Files', '', '', 0, 'F')
    call g:quickmenu#append(' Buffer', 'Buffers', '', '', 0, 'b')
    call g:quickmenu#append(' Buffer!', 'call FZF_Buffer_Open()', '', '', 0, 'B')
    call g:quickmenu#append(' Tags Buffer', 'BTags', '', '', 0, 't')
    call g:quickmenu#append(' Tags All', 'Tags', '', '', 0, 'T')
    call g:quickmenu#append(' Marks', 'Marks', '', '', 0, 'm')
    call g:quickmenu#append(' Maps', 'Maps', '', '', 0, 'M')
    call g:quickmenu#append(' Windows', 'Windows', '', '', 0, 'w')
    call g:quickmenu#append('History Command', 'History:', '', '', 0, 'hc')
    call g:quickmenu#append('History Search', 'History/', '', '', 0, 'hs')
    call g:quickmenu#append(' Snippets', 'Snippets', '', '', 0, 's')
    call g:quickmenu#append('Git Files', 'GFiles', '', '', 0, 'gf')
    call g:quickmenu#append('Git Status', 'GFiles?', '', '', 0, 'gs')
    call g:quickmenu#append('Git Commits Buffer', 'BCommits', '', '', 0, 'gc')
    call g:quickmenu#append('Git Commits All', 'Commits', '', '', 0, 'gC')
    call g:quickmenu#append(' Commands', 'Commands', '', '', 0, 'c')
    call g:quickmenu#append(' Grep', 'Ag', '', '', 0, 'G')
    call g:quickmenu#append(' Help', 'Helptags', '', '', 0, 'H')
    "}}}
    "{{{functions
    function! FZF_Buffer_Open()
        let g:fzf_buffers_jump = 0
        execute 'Buffers'
        let g:fzf_buffers_jump = 1
    endfunction
    "}}}
    augroup FZF_Au
        autocmd!
        autocmd User CocQuickfixChange :call fzf_quickfix#run()
    augroup END
    let g:fzf_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-h': 'split',
                \ 'ctrl-v': 'vsplit' }
    let g:fzf_layout = { 'down': '~40%' }
    " Customize fzf colors to match your color scheme
    let g:fzf_colors =
                \ { 'fg':      ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Comment'],
                \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
                \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
                \ 'hl+':     ['fg', 'Statement'],
                \ 'info':    ['fg', 'PreProc'],
                \ 'border':  ['fg', 'Ignore'],
                \ 'prompt':  ['fg', 'Conditional'],
                \ 'pointer': ['fg', 'Exception'],
                \ 'marker':  ['fg', 'Keyword'],
                \ 'spinner': ['fg', 'Label'],
                \ 'header':  ['fg', 'Comment'] }
    let g:fzf_history_dir = expand('~/.cache/vim/fzf-history')
    let g:fzf_buffers_jump = 1
    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
    " [Tags] Command to generate tags file
    let g:fzf_tags_command = 'ctags -R'
    " [Commands] --expect expression for directly executing the command
    let g:fzf_commands_expect = 'alt-enter,ctrl-x'
    " Command for git grep
    " - fzf#vim#grep(command, with_column, [options], [fullscreen])
    command! -bang -nargs=* GGrep
                \ call fzf#vim#grep(
                \   'git grep --line-number '.shellescape(<q-args>), 0,
                \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

    " Override Colors command. You can safely do this in your .vimrc as fzf.vim
    " will not override existing commands.
    command! -bang Colors
                \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)
    command! -bang -nargs=* Ag
                \ call fzf#vim#ag(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
                \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', 'ctrl-p'),
                \                 <bang>0)
    command! -bang -nargs=* Rg
                \ call fzf#vim#grep(
                \                 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
                \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
                \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', 'ctrl-p'),
                \                 <bang>0)
    command! -bang -nargs=? -complete=dir Files
                \ call fzf#vim#files(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
                \                 <bang>0)
    command! -bang -nargs=? GitFiles
                \ call fzf#vim#gitfiles(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
                \                 <bang>0)
    command! -bang -nargs=? GFiles
                \ call fzf#vim#gitfiles(<q-args>,
                \                 <bang>0 ? fzf#vim#with_preview('up:60%')
                \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
                \                 <bang>0)
    "     command! -bar -bang -nargs=? -complete=buffer Buffers
    "             \ call fzf#vim#buffers(<q-args>,
    "             \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    "             \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
    "             \                 <bang>0)
    " command! -bang -nargs=* Lines
    "             \ call fzf#vim#lines(<q-args>,
    "             \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    "             \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
    "             \                 <bang>0)
    " command! -bang -nargs=* BLines
    "             \ call fzf#vim#buffer_lines(<q-args>,
    "             \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    "             \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
    "             \                 <bang>0)
    " command! -bang -nargs=* Tags
    "             \ call fzf#vim#tags(<q-args>,
    "             \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    "             \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
    "             \                 <bang>0)
    " command! -bang -nargs=* BTags
    "             \ call fzf#vim#buffer_tags(<q-args>,
    "             \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    "             \                         : fzf#vim#with_preview('right:50%:hidden', 'ctrl-p'),
    "                 \                 <bang>0)
endif
"}}}
"{{{LeaderF
if g:VIM_Fuzzy_Finder ==# 'leaderf' || g:VIM_Fuzzy_Finder ==# 'remix'
    "{{{LeaderF-usage
    " f  search
    function Help_LeaderF()
        echo '<Tab>                     切换到普通模式'
        echo '<C-c> <Esc>               退出'
        echo '<C-r>                     在Fuzzy和Regex模式间切换'
        echo '<C-f>                     在FullPath和NameOnly模式间切换'
        echo '<C-v>                     从剪切板粘贴'
        echo '<C-u>                     清空输入框'
        echo '<CR> <C-X> <C-]> <A-t>    在当前窗口、新的水平窗口、新的竖直窗口、新的tab中打开'
        echo '<F5>                      刷新缓存'
        echo '<C-s>                     选择多个文件'
        echo '<C-a>                     选择所有文件'
        echo '<C-l>                     清空选择'
        echo '<C-p>                     预览'
        echo '<S-left>                  光标移到最左端'
        echo '<S-right>                 光标移到最右端'
        echo '.                         切换搜索隐藏文件的变量(normal mode)'
        echo '?                         呼出帮助窗口(normal mode)'
        echo "\n"
        echo 'Commands'
        echo '-i, --ignore-case'
        echo '-s, --case-sensitive'
        echo '--no-ignore'
        echo '--no-ignore-parent'
        echo '-t <TYPE>..., --type <TYPE>...'
        echo '-T <TYPE>..., --type-not <TYPE>...'
    endfunction
    "}}}
    "{{{quickmenu
    if g:VIM_Fuzzy_Finder ==# 'leaderf'
        call quickmenu#current(1)
        call quickmenu#reset()
        noremap <silent> f :call quickmenu#toggle(1)<cr>
    elseif g:VIM_Fuzzy_Finder ==# 'remix'
        call quickmenu#current(3)
        call quickmenu#reset()
        noremap <silent> f :call quickmenu#toggle(3)<cr>
    endif
    call g:quickmenu#append('# LeaderF', '')
    call g:quickmenu#append('Line', 'Leaderf line', 'Search Line in Current Buffer', '', 0, 'l')
    call g:quickmenu#append('Line All', 'Leaderf line --all', 'Search Line in All Buffers', '', 0, 'L')
    call g:quickmenu#append('Buffer', 'Leaderf buffer', 'Search Buffers, "open" as default action', '', 0, 'B')
    call g:quickmenu#append('MRU', 'Leaderf mru', 'Search MRU files', '', 0, 'f')
    call g:quickmenu#append('File', 'Leaderf file --nameOnly', 'Search files', '', 0, 'F')
    call g:quickmenu#append('Directory', 'Leaderf file --fullPath', 'Search directorys', '', 0, 'D')
    call g:quickmenu#append('Tags', 'Leaderf bufTag', 'Search Tags in Current Buffer', '', 0, 't')
    call g:quickmenu#append('Tags All', 'Leaderf bufTag --all', 'Search Tags in All Buffers', '', 0, 'T')
    call g:quickmenu#append('Commands', 'LeaderfCmdpalette', 'Search Commands', '', 0, 'c')
    call g:quickmenu#append('Prosessions', 'LeaderfProsessions', 'Search Prosessions', '', 0, 's')
    call g:quickmenu#append('History Command', 'Leaderf cmdHistory', 'Search History Commands', '', 0, 'hc')
    call g:quickmenu#append('History Search', 'Leaderf searchHistory', 'Search History Searching', '', 0, 'hs')
    call g:quickmenu#append('Marks', 'Leaderf marks', 'Search Marks', '', 0, 'm')
    call g:quickmenu#append('Help Docs', 'Leaderf help', 'Search Help Docs', '', 0, 'H')
    call g:quickmenu#append('Github Stars', 'LeaderfStars', 'Search Github Stars', '', 0, '*')
    call g:quickmenu#append('Grep', 'Leaderf rg --no-ignore', 'Grep on the Fly', '', 0, 'G')
    call g:quickmenu#append('Leaderf Help', 'call Help_LeaderF()', 'Leaderf Help', '', 0, '?')
    "}}}
    "{{{ToggleLfHiddenVar()
    function! ToggleLfHiddenVar()
        if g:Lf_ShowHidden == 0
            let g:Lf_ShowHidden = 1
        elseif g:Lf_ShowHidden == 1
            let g:Lf_ShowHidden = 0
        endif
    endfunction
    "}}}
    let gs#username='sainnhe'
    let g:Lf_DefaultMode = 'Fuzzy' " NameOnly FullPath Fuzzy Regex   :h g:Lf_DefaultMode
    let g:Lf_WorkingDirectoryMode = 'ac'  " g:Lf_WorkingDirectoryMode
    let g:Lf_RootMarkers = ['.git', '.hg', '.svn']
    let g:Lf_ShowHidden = 0  " search hidden files
    let g:Lf_FollowLinks = 1  " expand symbol link
    let g:Lf_RecurseSubmodules = 1  " show git submodules
    let g:Lf_DefaultExternalTool = 'ag'  " 'rg', 'pt', 'ag', 'find'
    let g:Lf_StlColorscheme = 'one'  " $HOME/.cache/vim/plugins/LeaderF/autoload/leaderf/colorscheme
    let g:Lf_StlSeparator = { 'left': '', 'right': '' }
    let g:Lf_WindowPosition = 'bottom'  " top bottom left right
    let g:Lf_WindowHeight = 0.4
    let g:Lf_CursorBlink = 1
    let g:Lf_CacheDirectory = expand('~/.cache/vim/')
    let g:Lf_NeedCacheTime = 0.5
    " let g:Lf_WildIgnore = {
    "         \ 'dir': ['.svn','.git','.hg'],
    "         \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
    "         \}
    " let g:Lf_MruFileExclude = ['*.so']
    " let g:Lf_MruWildIgnore = {
    "         \ 'dir': [],
    "         \ 'file': []
    "         \}
    " let g:Lf_CtagsFuncOpts = {
    "         \ 'c': '--c-kinds=fp',
    "         \ 'rust': '--rust-kinds=f',
    "         \ }
    let g:Lf_PreviewCode = 1  " preview code when navigating the tags
    let g:Lf_PreviewResult = {
                \ 'File': 1,
                \ 'Buffer': 1,
                \ 'Mru': 1,
                \ 'Tag': 0,
                \ 'BufTag': 1,
                \ 'Function': 1,
                \ 'Line': 1,
                \ 'Colorscheme': 0
                \}
    let g:Lf_CommandMap = {'<Home>': ['<S-left>'], '<End>': ['<S-right>'], '<C-t>': ['<A-t>']}
    let g:Lf_ShortcutF = '```zw'  " mapping for searching files
    let g:Lf_ShortcutB = '````1cv'  " mapping for searching buffers
    let g:Lf_NormalMap = {
                \ 'File':   [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Buffer': [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Mru':    [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Tag':    [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'BufTag': [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Function': [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Line':   [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'History':[['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Help':   [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Self':   [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']],
                \ 'Colorscheme': [['.', ':call ToggleLfHiddenVar()<CR>'], ['?', ':call Help_LeaderF()<CR>']]
                \}
endif
"}}}
"{{{ale
if g:VIM_Linter ==# 'ale'
    "{{{ale-usage
    let g:ALE_MODE = 1  " 0则只在保存文件时检查，1则只在normal模式下检查，2则异步检查
    " 普通模式下<leader>lk和<leader>lj分别跳转到上一个、下一个错误
    " :ALEDetail  查看详细错误信息
    "}}}
    " ls ~/.cache/vim/plugins/ale/ale_linters/
    let g:ale_linters = {
                \       'asm': ['gcc'],
                \       'c': ['cppcheck', 'flawfinder'],
                \       'cpp': ['cppcheck', 'flawfinder'],
                \       'css': ['stylelint'],
                \       'html': ['tidy'],
                \       'json': [],
                \       'markdown': [''],
                \       'python': ['pylint', 'flake8', 'mypy', 'pydocstyle'],
                \       'rust': ['cargo'],
                \       'sh': ['shellcheck'],
                \       'text': ['languagetool'],
                \       'vim': ['vint'],
                \}
    "查看上一个错误
    nnoremap <silent> <leader>lk :ALEPrevious<CR>
    "查看下一个错误
    nnoremap <silent> <leader>lj :ALENext<CR>
    "自定义error和warning图标
    let g:ale_sign_error = "\uf65b"
    let g:ale_sign_warning = "\uf421"
    "防止java在中文系统上警告和提示乱码
    let g:ale_java_javac_options = '-encoding UTF-8  -J-Duser.language=en'
    "显示Linter名称,出错或警告等相关信息
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    " 光标移动到错误的地方时立即显示错误
    let g:ale_echo_delay = 0
    " virtual text
    let g:ale_virtualtext_cursor = 1
    let g:ale_virtualtext_delay = 10
    let g:ale_virtualtext_prefix = '▸'
    " highlight ALEVirtualTextError ctermfg=Gray guifg=#8d6e6e
    " highlight ALEVirtualTextWarning ctermfg=Gray guifg=#8d816e
    highlight ALEVirtualTextError ctermfg=Gray guifg=#888888
    highlight ALEVirtualTextWarning ctermfg=Gray guifg=#888888
    highlight ALEVirtualTextInfo ctermfg=Gray guifg=#888888
    highlight link ALEVirtualTextStyleError ALEVirtualTextError
    highlight link ALEVirtualTextStyleWarning ALEVirtualTextWarning
    " ale-mode
    if g:ALE_MODE == 0
        let g:ale_lint_on_text_changed = 'never'
    elseif g:ALE_MODE == 1
        let g:ale_lint_on_text_changed = 'normal'
        let g:ale_lint_on_insert_leave = 1
    elseif g:ALE_MODE == 2
        let g:ale_lint_on_text_changed = 'always'
        let g:ale_lint_delay=100
    endif
    "}}}
    "{{{neomake
    "{{{neomake-usage
    " gj, gk分别跳转到下一个、上一个提示位置
    "}}}
elseif g:VIM_Linter ==# 'neomake'
    call neomake#configure#automake('nwr')  " 'nwri'  when writing or reading a buffer, and on changes in insert and normal mode
    let g:neomake_error_sign = {'text': "\uf65b", 'texthl': 'NeomakeErrorSign'}
    let g:neomake_warning_sign = {'text': "\uf421",'texthl': 'NeomakeWarningSign'}
    let g:neomake_message_sign = {'text': '➤','texthl': 'NeomakeMessageSign'}
    let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
    let g:neomake_virtualtext_prefix = '▸'
    let g:neomake_cursormoved_delay = 50
    nnoremap <silent> gj :lnext<CR>
    nnoremap <silent> gk :lprev<CR>
endif
"}}}
"{{{vim-sneak
"{{{vim-sneak-help
function! Help_vim_sneak()
    echo 'Normal Mode & Visual Mode:'
    echo 's[char][char]                 forward search and highlight'
    echo 'S[char][char]                 backward search and highlight'
    echo "' \"                          repeat motion"
    echo "[num]' [num]\"                repeat motion multiple times"
    echo 'C-o                           jump to start point'
    echo 's[Enter] S[Enter]             repeat last search'
endfunction
"}}}
map ' <Plug>Sneak_;
map " <Plug>Sneak_,
imap <A-s> <Esc>s
"}}}
"{{{nerdtree
"{{{nerdtree-usage
function! Help_nerdtree()
    echo '<C-b>         切换nerdtree'
    echo '?             切换官方帮助'
    echo 'h             查看帮助'
    echo '~             回到project root'
    echo '<A-f>         FuzzyFinder'
    echo '<A-g>         Grep'
    echo '<A-e>         打开nnn (或者直接buffer里<leader><A-e>)'
    echo '<A-b>         打开bufexplorer(或直接buffer里<leader><A-b>)'
endfunction
"}}}
"{{{extensions
"{{{vim-nerdtree-syntax-highlight
" disable highlight
" let g:NERDTreeDisableFileExtensionHighlight = 1
" let g:NERDTreeDisableExactMatchHighlight = 1
" let g:NERDTreeDisablePatternMatchHighlight = 1
" highlight fullname
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
" highlight folders using exact match
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
"}}}
"}}}
nnoremap <silent> <C-B> :<C-u>NERDTreeToggle<CR>
function! s:nerdtree_mappings() abort
    nnoremap <silent><buffer> ~ :<C-u>NERDTreeVCS<CR>
    nnoremap <silent><buffer> <A-f> :call Nerdtree_Fuzzy_Finder()<CR>
    nnoremap <silent><buffer> <A-g> :call Nerdtree_Grep()<CR>
    nnoremap <silent><buffer> h :call Help_nerdtree()<CR>
    nmap <silent><buffer> <A-e> <C-b>:<C-u>NnnPicker '%:p:h'<CR>
    nmap <silent><buffer> <A-b> <C-b>:<C-u>BufExplorer<CR>
endfunction
augroup NERDTreeAu
    autocmd!
    autocmd FileType nerdtree setlocal signcolumn=no
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    autocmd FileType nerdtree call s:nerdtree_mappings()
augroup END
let NERDTreeMinimalUI = 1
let NERDTreeWinSize = 35
let NERDTreeChDirMode = 0
let g:NERDTreeDirArrowExpandable = "\u00a0"
let g:NERDTreeDirArrowCollapsible = "\u00a0"
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
" let NERDTreeShowHidden = 1
function! Nerdtree_Fuzzy_Finder()
    if g:VIM_Fuzzy_Finder ==# 'leaderf'
        execute 'LeaderfFile'
    elseif g:VIM_Fuzzy_Finder ==# 'fzf'
        execute 'Files'
    elseif g:VIM_Fuzzy_Finder ==# 'denite'
        execute 'Denite file_rec'
    elseif g:VIM_Fuzzy_Finder ==# 'remix'
        execute 'LeaderfFile'
    endif
endfunction
function! Nerdtree_Grep()
    if g:VIM_Fuzzy_Finder ==# 'leaderf'
        execute 'Leaderf rg'
    elseif g:VIM_Fuzzy_Finder ==# 'fzf'
        execute 'Ag'
    elseif g:VIM_Fuzzy_Finder ==# 'denite'
        execute 'Denite grep'
    elseif g:VIM_Fuzzy_Finder ==# 'remix'
        execute 'Ag'
    endif
endfunction
"}}}
"{{{nnn.vim
"{{{nnn.vim-usage
" <leader><A-e>  打开nnn
" nerdtree里 <A-e>  打开nnn
"}}}
let g:nnn#set_default_mappings = 0
nnoremap <silent> <leader><A-e> :<C-u>NnnPicker '%:p:h'<CR>
let g:nnn#action = {
            \ '<c-t>': 'tab split',
            \ '<c-x>': 'split',
            \ '<c-v>': 'vsplit' }
let g:nnn#command = 'PAGER= nnn'
" let g:nnn#layout = 'new' "or vnew, tabnew, etc.
" let g:nnn#layout = { 'left': '~20%' }
"}}}
"{{{bufexplore
"{{{bufexplore-usage
" <leader><A-b> 打开bufexplorer
" nerdtree里 <A-b> 打开bufexplorer
" ?  显示帮助文档
"}}}
" Use Default Mappings
let g:bufExplorerDisableDefaultKeyMapping=1
nnoremap <silent> <leader><A-b> :<C-u>BufExplorer<CR>
function! s:bufexplore_mappings() abort
    nmap <buffer> ? <F1>
endfunction
augroup BufexploreAu
    autocmd!
    autocmd FileType bufexplorer call s:bufexplore_mappings()
augroup END
let g:bufExplorerShowTabBuffer=1 " 只显示当前tab的buffer
let g:bufExplorerSplitBelow=1 " explore水平分割时，在下方打开
let g:bufExplorerDefaultHelp=0 " 默认不显示帮助信息
let g:bufExplorerSplitBelow=1 " Split new window below current.
let g:bufExplorerSplitHorzSize=10 " New split window is n rows high.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
" let g:bufExplorerSortBy='extension'  " Sort by file extension.
" let g:bufExplorerSortBy='fullpath'   " Sort by full file path name.
" let g:bufExplorerSortBy='name'       " Sort by the buffer's name.
" let g:bufExplorerSortBy='number'     " Sort by the buffer's number.
"}}}
"{{{undotree
let g:undotree_WindowLayout = 3
let g:undotree_SplitWidth = 35
let g:undotree_DiffpanelHeight = 10
"}}}
"{{{vim-fugitive
"{{{twiggy
command Gbranch Twiggy
let g:twiggy_local_branch_sort = 'mru'
let g:twiggy_num_columns = 35
let g:twiggy_close_on_fugitive_command = 1
let g:twiggy_remote_branch_sort = 'date'
let g:twiggy_show_full_ui = 0
let g:twiggy_git_log_command = 'GV'
"}}}
"{{{gv
function! Help_GV()
    echo 'Commands'
    echo ':GV           open commit browser'
    echo ':GV!          only list commits that affected the current file'
    echo ':GV?          fills the location list with the revisions of the current file'
    echo ''
    echo 'Mappings'
    echo 'o or <cr> on a commit to display the content of it'
    echo 'o or <cr> on commits to display the diff in the range'
    echo 'O opens a new tab instead'
    echo 'gb for :Gbrowse'
    echo ']] and [[ to move between commits'
    echo '. to start command-line with :Git [CURSOR] SHA via fugitive'
    echo 'q to close'
endfunction
function! s:GV_Mappings() abort
    nnoremap <silent><buffer> ? :call Help_GV()<CR>
endfunction
augroup GV_Au
    autocmd!
    autocmd FileType GV call s:GV_Mappings()
augroup END
"}}}
"{{{committia.vim
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    endif

    " Scroll the diff window from insert mode
    imap <buffer><PageDown> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><PageUp> <Plug>(committia-scroll-diff-up-half)
    imap <buffer><S-PageDown> <Plug>(committia-scroll-diff-down-page)
    imap <buffer><S-PageUp> <Plug>(committia-scroll-diff-up-page)
endfunction
"}}}
"}}}
"{{{gen_tags.vim
"{{{quickmenu
call quickmenu#current(7)
call quickmenu#reset()
call g:quickmenu#append('# Ctags', '')
call g:quickmenu#append(' Generate Ctags', 'call InitCtags()', 'Generate ctags database', '', 0, 'c')
call g:quickmenu#append('Remove Ctags files', 'ClearCtags', 'Remove tags files', '', 0, 'rc')
call g:quickmenu#append('Remove all Ctags files', 'ClearCtags!', 'Remove all files, include db directory', '', 0, 'Rc')
call g:quickmenu#append('# Gtags', '')
call g:quickmenu#append(' Generate Gtags', 'call InitGtags()', 'Generate gtags database', '', 0, 'g')
call g:quickmenu#append('Remove Gtags files', 'ClearGTAGS', 'Remove GTAGS files', '', 0, 'rg')
call g:quickmenu#append('Remove all Gtags files', 'ClearGTAGS', 'Remove all files, include the db directory', '', 0, 'Rg')
call g:quickmenu#append(' Edit config', 'EditExt', 'Edit an extend configuration file for this project', '', 0, 'e')
function! InitCtags()
    call Init_gen_tags()
    execute 'GenCtags'
    if g:VIM_Completion_Framework ==# 'ncm2'
        call plug#load('ncm2-tagprefix')
    elseif g:VIM_Completion_Framework ==# 'asyncomplete'
        call plug#load('asyncomplete-tags.vim')
    endif
endfunction
function! InitGtags()
    call Init_gen_tags()
    execute 'GenGTAGS'
    if g:VIM_Completion_Framework ==# 'deoplete'
        call plug#load('deoplete-gtags')
    elseif g:VIM_Completion_Framework ==# 'ncm2'
        call plug#load('ncm2-gtags')
    endif
endfunction
"}}}
function! Init_gen_tags()
    " let g:gen_tags#ctags_opts = '--c++-kinds=+px --c-kinds=+px'
    " let g:gen_tags#gtags_opts = '-c --verbose'
    let g:gen_tags#use_cache_dir = 1  " 0: use project directory to store tags; 1: $HOME/.cache/tags_dir/<project name>
    let g:gen_tags#ctags_auto_gen = 0
    let g:gen_tags#gtags_auto_gen = 0
    let g:gen_tags#ctags_auto_update = 1
    let g:gen_tags#gtags_auto_update = 1
    let g:gen_tags#blacklist = ['$HOME']
    let g:gen_tags#gtags_default_map = 0
    call plug#load('gen_tags.vim')
    if g:VIM_Completion_Framework ==# 'coc'
        call coc#add_extension('coc-tag')
    endif
endfunction
"}}}
"{{{tagbar
if g:VIM_TAGBAR ==# 'tagbar'
    "{{{Languages
    "{{{Ansible
    let g:tagbar_type_ansible = {
                \ 'ctagstype' : 'ansible',
                \ 'kinds' : [
                \ 't:tasks'
                \ ],
                \ 'sort' : 0
                \ }
    "}}}
    "{{{ArmAsm
    let g:tagbar_type_armasm = {
                \ 'ctagsbin'  : 'ctags',
                \ 'ctagsargs' : '-f- --format=2 --excmd=pattern --fields=nksSa --extra= --sort=no --language-force=asm',
                \ 'kinds' : [
                \ 'm:macros:0:1',
                \ 't:types:0:1',
                \ 'd:defines:0:1',
                \ 'l:labels:0:1'
                \ ]
                \}
    "}}}
    "{{{AsciiDoc
    let g:tagbar_type_asciidoc = {
                \ 'ctagstype' : 'asciidoc',
                \ 'kinds' : [
                \ 'h:table of contents',
                \ 'a:anchors:1',
                \ 't:titles:1',
                \ 'n:includes:1',
                \ 'i:images:1',
                \ 'I:inline images:1'
                \ ],
                \ 'sort' : 0
                \ }
    "}}}
    "{{{Bib
    let g:tagbar_type_bib = {
                \ 'ctagstype' : 'bib',
                \ 'kinds'     : [
                \ 'a:Articles',
                \ 'b:Books',
                \ 'L:Booklets',
                \ 'c:Conferences',
                \ 'B:Inbook',
                \ 'C:Incollection',
                \ 'P:Inproceedings',
                \ 'm:Manuals',
                \ 'T:Masterstheses',
                \ 'M:Misc',
                \ 't:Phdtheses',
                \ 'p:Proceedings',
                \ 'r:Techreports',
                \ 'u:Unpublished',
                \ ]
                \ }
    "}}}
    "{{{CoffeeScript
    let g:tagbar_type_coffee = {
                \ 'ctagstype' : 'coffee',
                \ 'kinds'     : [
                \ 'c:classes',
                \ 'm:methods',
                \ 'f:functions',
                \ 'v:variables',
                \ 'f:fields',
                \ ]
                \ }
    "}}}
    "{{{CSS
    let g:tagbar_type_css = {
                \ 'ctagstype' : 'Css',
                \ 'kinds'     : [
                \ 'c:classes',
                \ 's:selectors',
                \ 'i:identities'
                \ ]
                \ }
    "}}}
    "{{{Elixir
    let g:tagbar_type_elixir = {
                \ 'ctagstype' : 'elixir',
                \ 'kinds' : [
                \ 'p:protocols',
                \ 'm:modules',
                \ 'e:exceptions',
                \ 'y:types',
                \ 'd:delegates',
                \ 'f:functions',
                \ 'c:callbacks',
                \ 'a:macros',
                \ 't:tests',
                \ 'i:implementations',
                \ 'o:operators',
                \ 'r:records'
                \ ],
                \ 'sro' : '.',
                \ 'kind2scope' : {
                \ 'p' : 'protocol',
                \ 'm' : 'module'
                \ },
                \ 'scope2kind' : {
                \ 'protocol' : 'p',
                \ 'module' : 'm'
                \ },
                \ 'sort' : 0
                \ }
    "}}}
    "{{{Fountain
    let g:tagbar_type_fountain = {
                \ 'ctagstype': 'fountain',
                \ 'kinds': [
                \ 'h:headings',
                \ 's:sections',
                \ ],
                \ 'sort': 0,
                \}
    "}}}
    "{{{Go
    let g:tagbar_type_go = {
                \ 'ctagstype' : 'go',
                \ 'kinds'     : [
                \ 'p:package',
                \ 'i:imports:1',
                \ 'c:constants',
                \ 'v:variables',
                \ 't:types',
                \ 'n:interfaces',
                \ 'w:fields',
                \ 'e:embedded',
                \ 'm:methods',
                \ 'r:constructor',
                \ 'f:functions'
                \ ],
                \ 'sro' : '.',
                \ 'kind2scope' : {
                \ 't' : 'ctype',
                \ 'n' : 'ntype'
                \ },
                \ 'scope2kind' : {
                \ 'ctype' : 't',
                \ 'ntype' : 'n'
                \ },
                \ 'ctagsbin'  : 'gotags',
                \ 'ctagsargs' : '-sort -silent'
                \ }
    "}}}
    "{{{Groovy
    let g:tagbar_type_groovy = {
                \ 'ctagstype' : 'groovy',
                \ 'kinds'     : [
                \ 'p:package:1',
                \ 'c:classes',
                \ 'i:interfaces',
                \ 't:traits',
                \ 'e:enums',
                \ 'm:methods',
                \ 'f:fields:1'
                \ ]
                \ }
    "}}}
    "{{{Haskell
    let g:tagbar_type_haskell = {
                \ 'ctagsbin'  : 'hasktags',
                \ 'ctagsargs' : '-x -c -o-',
                \ 'kinds'     : [
                \  'm:modules:0:1',
                \  'd:data: 0:1',
                \  'd_gadt: data gadt:0:1',
                \  't:type names:0:1',
                \  'nt:new types:0:1',
                \  'c:classes:0:1',
                \  'cons:constructors:1:1',
                \  'c_gadt:constructor gadt:1:1',
                \  'c_a:constructor accessors:1:1',
                \  'ft:function types:1:1',
                \  'fi:function implementations:0:1',
                \  'o:others:0:1'
                \ ],
                \ 'sro'        : '.',
                \ 'kind2scope' : {
                \ 'm' : 'module',
                \ 'c' : 'class',
                \ 'd' : 'data',
                \ 't' : 'type'
                \ },
                \ 'scope2kind' : {
                \ 'module' : 'm',
                \ 'class'  : 'c',
                \ 'data'   : 'd',
                \ 'type'   : 't'
                \ }
                \ }
    "}}}
    "{{{IDL
    let g:tagbar_type_idlang = {
                \ 'ctagstype' : 'IDL',
                \ 'kinds' : [
                \ 'p:Procedures',
                \ 'f:Functions',
                \ 'c:Common Blocks'
                \ ]
                \ }
    "}}}
    "{{{Julia
    let g:tagbar_type_julia = {
                \ 'ctagstype' : 'julia',
                \ 'kinds'     : [
                \ 't:struct', 'f:function', 'm:macro', 'c:const']
                \ }
    "}}}
    "{{{Makefile
    let g:tagbar_type_make = {
                \ 'kinds':[
                \ 'm:macros',
                \ 't:targets'
                \ ]
                \}
    "}}}
    "{{{Markdown
    let g:tagbar_type_markdown = {
                \ 'ctagstype': 'markdown',
                \ 'ctagsbin' : 'markdown2ctags',
                \ 'ctagsargs' : '-f - --sort=yes',
                \ 'kinds' : [
                \ 's:sections',
                \ 'i:images'
                \ ],
                \ 'sro' : '|',
                \ 'kind2scope' : {
                \ 's' : 'section',
                \ },
                \ 'sort': 0,
                \ }
    "}}}
    "{{{MediaWiki
    let g:tagbar_type_mediawiki = {
                \ 'ctagstype' : 'mediawiki',
                \ 'kinds' : [
                \'h:chapters',
                \'s:sections',
                \'u:subsections',
                \'b:subsubsections',
                \]
                \}
    "}}}
    "{{{NASL
    let g:tagbar_type_nasl = {
                \ 'ctagstype' : 'nasl',
                \ 'kinds'     : [
                \ 'f:function',
                \ 'u:public function',
                \ 'r:private function',
                \ 'v:variables',
                \ 'n:namespace',
                \ 'g:globals',
                \ ]
                \ }
    "}}}
    "{{{ObjectiveC
    let g:tagbar_type_objc = {
                \ 'ctagstype' : 'ObjectiveC',
                \ 'kinds'     : [
                \ 'i:interface',
                \ 'I:implementation',
                \ 'p:Protocol',
                \ 'm:Object_method',
                \ 'c:Class_method',
                \ 'v:Global_variable',
                \ 'F:Object field',
                \ 'f:function',
                \ 'p:property',
                \ 't:type_alias',
                \ 's:type_structure',
                \ 'e:enumeration',
                \ 'M:preprocessor_macro',
                \ ],
                \ 'sro'        : ' ',
                \ 'kind2scope' : {
                \ 'i' : 'interface',
                \ 'I' : 'implementation',
                \ 'p' : 'Protocol',
                \ 's' : 'type_structure',
                \ 'e' : 'enumeration'
                \ },
                \ 'scope2kind' : {
                \ 'interface'      : 'i',
                \ 'implementation' : 'I',
                \ 'Protocol'       : 'p',
                \ 'type_structure' : 's',
                \ 'enumeration'    : 'e'
                \ }
                \ }
    "}}}
    "{{{Perl
    let g:tagbar_type_perl = {
                \ 'ctagstype' : 'perl',
                \ 'kinds'     : [
                \ 'p:package:0:0',
                \ 'w:roles:0:0',
                \ 'e:extends:0:0',
                \ 'u:uses:0:0',
                \ 'r:requires:0:0',
                \ 'o:ours:0:0',
                \ 'a:properties:0:0',
                \ 'b:aliases:0:0',
                \ 'h:helpers:0:0',
                \ 's:subroutines:0:0',
                \ 'd:POD:1:0'
                \ ]
                \ }
    "}}}
    "{{{PHP
    let g:tagbar_phpctags_bin='~/.cache/vim/plugins/tagbar-phpctags.vim/bin/phpctags'
    let g:tagbar_phpctags_memory_limit = '512M'
    "}}}
    "{{{Puppet
    let g:tagbar_type_puppet = {
                \ 'ctagstype': 'puppet',
                \ 'kinds': [
                \'c:class',
                \'s:site',
                \'n:node',
                \'d:definition'
                \]
                \}
    "}}}
    "{{{R
    let g:tagbar_type_r = {
                \ 'ctagstype' : 'r',
                \ 'kinds'     : [
                \ 'f:Functions',
                \ 'g:GlobalVariables',
                \ 'v:FunctionVariables',
                \ ]
                \ }
    "}}}
    "{{{reStructuredText
    let g:tagbar_type_rst = {
                \ 'ctagstype': 'rst',
                \ 'ctagsbin' : 'rst2ctags',
                \ 'ctagsargs' : '-f - --sort=yes',
                \ 'kinds' : [
                \ 's:sections',
                \ 'i:images'
                \ ],
                \ 'sro' : '|',
                \ 'kind2scope' : {
                \ 's' : 'section',
                \ },
                \ 'sort': 0,
                \ }
    "}}}
    "{{{Ruby
    let g:tagbar_type_ruby = {
                \ 'kinds' : [
                \ 'm:modules',
                \ 'c:classes',
                \ 'd:describes',
                \ 'C:contexts',
                \ 'f:methods',
                \ 'F:singleton methods'
                \ ]
                \ }
    "}}}
    "{{{Rust
    let g:rust_use_custom_ctags_defs = 1  " if using rust.vim
    let g:tagbar_type_rust = {
                \ 'ctagsbin' : '/path/to/your/universal/ctags',
                \ 'ctagstype' : 'rust',
                \ 'kinds' : [
                \ 'n:modules',
                \ 's:structures:1',
                \ 'i:interfaces',
                \ 'c:implementations',
                \ 'f:functions:1',
                \ 'g:enumerations:1',
                \ 't:type aliases:1:0',
                \ 'v:constants:1:0',
                \ 'M:macros:1',
                \ 'm:fields:1:0',
                \ 'e:enum variants:1:0',
                \ 'P:methods:1',
                \ ],
                \ 'sro': '::',
                \ 'kind2scope' : {
                \ 'n': 'module',
                \ 's': 'struct',
                \ 'i': 'interface',
                \ 'c': 'implementation',
                \ 'f': 'function',
                \ 'g': 'enum',
                \ 't': 'typedef',
                \ 'v': 'variable',
                \ 'M': 'macro',
                \ 'm': 'field',
                \ 'e': 'enumerator',
                \ 'P': 'method',
                \ },
                \ }
    "}}}
    "{{{Scala
    let g:tagbar_type_scala = {
                \ 'ctagstype' : 'scala',
                \ 'sro'       : '.',
                \ 'kinds'     : [
                \ 'p:packages',
                \ 'T:types:1',
                \ 't:traits',
                \ 'o:objects',
                \ 'O:case objects',
                \ 'c:classes',
                \ 'C:case classes',
                \ 'm:methods',
                \ 'V:values:1',
                \ 'v:variables:1'
                \ ]
                \ }
    "}}}
    "{{{systemverilog
    let g:tagbar_type_systemverilog = {
                \ 'ctagstype': 'systemverilog',
                \ 'kinds' : [
                \'A:assertions',
                \'C:classes',
                \'E:enumerators',
                \'I:interfaces',
                \'K:packages',
                \'M:modports',
                \'P:programs',
                \'Q:prototypes',
                \'R:properties',
                \'S:structs and unions',
                \'T:type declarations',
                \'V:covergroups',
                \'b:blocks',
                \'c:constants',
                \'e:events',
                \'f:functions',
                \'m:modules',
                \'n:net data types',
                \'p:ports',
                \'r:register data types',
                \'t:tasks',
                \],
                \ 'sro': '.',
                \ 'kind2scope' : {
                \ 'K' : 'package',
                \ 'C' : 'class',
                \ 'm' : 'module',
                \ 'P' : 'program',
                \ 'I' : 'interface',
                \ 'M' : 'modport',
                \ 'f' : 'function',
                \ 't' : 'task',
                \},
                \ 'scope2kind' : {
                \ 'package'   : 'K',
                \ 'class'     : 'C',
                \ 'module'    : 'm',
                \ 'program'   : 'P',
                \ 'interface' : 'I',
                \ 'modport'   : 'M',
                \ 'function'  : 'f',
                \ 'task'      : 't',
                \ },
                \}
    "}}}
    "{{{TypeScript
    let g:tagbar_type_typescript = {
                \ 'ctagstype': 'typescript',
                \ 'kinds': [
                \ 'c:classes',
                \ 'n:modules',
                \ 'f:functions',
                \ 'v:variables',
                \ 'v:varlambdas',
                \ 'm:members',
                \ 'i:interfaces',
                \ 'e:enums',
                \ ]
                \ }
    "}}}
    "{{{VHDL
    let g:tagbar_type_vhdl = {
                \ 'ctagstype': 'vhdl',
                \ 'kinds' : [
                \'d:prototypes',
                \'b:package bodies',
                \'e:entities',
                \'a:architectures',
                \'t:types',
                \'p:processes',
                \'f:functions',
                \'r:procedures',
                \'c:constants',
                \'T:subtypes',
                \'r:records',
                \'C:components',
                \'P:packages',
                \'l:locals'
                \]
                \}
    "}}}
    "{{{WSDL
    let g:tagbar_type_xml = {
                \ 'ctagstype' : 'WSDL',
                \ 'kinds'     : [
                \ 'n:namespaces',
                \ 'm:messages',
                \ 'p:portType',
                \ 'o:operations',
                \ 'b:bindings',
                \ 's:service'
                \ ]
                \ }
    "}}}
    "{{{Xquery
    let g:tagbar_type_xquery = {
                \ 'ctagstype' : 'xquery',
                \ 'kinds'     : [
                \ 'f:function',
                \ 'v:variable',
                \ 'm:module',
                \ ]
                \ }
    "}}}
    "{{{XSD
    let g:tagbar_type_xsd = {
                \ 'ctagstype' : 'XSD',
                \ 'kinds'     : [
                \ 'e:elements',
                \ 'c:complexTypes',
                \ 's:simpleTypes'
                \ ]
                \ }
    "}}}
    "{{{XSLT
    let g:tagbar_type_xslt = {
                \ 'ctagstype' : 'xslt',
                \ 'kinds' : [
                \ 'v:variables',
                \ 't:templates'
                \ ]
                \}
    "}}}
    "}}}
    nnoremap <silent><A-b> :<C-u>call ToggleTagbar()<CR>
    let g:TagBarLoad = 0
    function! ToggleTagbar()
        if g:TagBarLoad == 0
            let g:TagBarLoad = 1
            call TagbarInit()
            execute 'TagbarToggle'
        elseif g:TagBarLoad == 1
            execute 'TagbarToggle'
        endif
    endfunction
    function! TagbarInit()
        let g:tagbar_sort = 0
        let g:tagbar_width = 35
        let g:tagbar_autoclose = 1
        let g:tagbar_foldlevel = 2
        let g:tagbar_iconchars = ['▶', '◿']
        let g:tagbar_type_css = {
                    \ 'ctagstype' : 'Css',
                    \ 'kinds'     : [
                    \ 'c:classes',
                    \ 's:selectors',
                    \ 'i:identities'
                    \ ]
                    \ }
        call plug#load('tagbar', 'tagbar-phpctags.vim')
    endfunction
    function! s:tagbar_mappings() abort
        if g:VIM_Fuzzy_Finder ==# 'denite'
            nnoremap <silent><buffer> f :<C-u>TagbarToggle<CR>:Denite outline<CR>
        elseif g:VIM_Fuzzy_Finder ==# 'fzf'
            nnoremap <silent><buffer> f :<C-u>TagbarToggle<CR>:BTags<CR>
        elseif g:VIM_Fuzzy_Finder ==# 'leaderf' || g:VIM_Fuzzy_Finder ==# 'remix'
            nnoremap <silent><buffer> f :<C-u>TagbarToggle<CR>:LeaderfBufTagAll<CR>
        endif
    endfunction
    augroup TagbarAu
        autocmd!
        autocmd FileType tagbar call s:tagbar_mappings()
    augroup END
    "}}}
    "{{{vista.vim
elseif g:VIM_TAGBAR ==# 'vista'
    "{{{g:vim_vista_lsp_client
    if g:VIM_LSP_Client ==# 'lcn'
        let g:vim_vista_lsp_client = 'lcn'
    elseif g:VIM_LSP_Client ==# 'vim-lsp'
        let g:vim_vista_lsp_client = 'vim_lsp'
    endif
    if g:VIM_Completion_Framework ==# 'coc'
        let g:vim_vista_lsp_client = 'coc'
    endif
    "}}}
    nnoremap <silent><A-b> :<C-u>Vista!!<CR>
    let g:vista_echo_cursor_strategy = 'both'
    let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
    let g:vista_sidebar_width = 35
    let g:vista_default_executive = 'ctags'
    let g:vista_executive_for = {
                \ 'c': g:vim_vista_lsp_client,
                \ 'cpp': g:vim_vista_lsp_client
                \ }
    let g:vista_fzf_preview = ['right:50%']
    let g:vista#renderer#enable_icon = 1
    let g:vista#renderer#icons = {
                \ 'function': "\uf794",
                \ 'variable': "\uf71b",
                \ }
    function! s:vista_mappings() abort
        nnoremap <silent><buffer> <A-b> :Vista!!<CR>
        nnoremap <silent><buffer> q :Vista!!<CR>
        nnoremap <silent><buffer> f :Vista finder<CR>
        nnoremap <silent><buffer> F :execute "Vista finder ".g:vim_vista_lsp_client<CR>
    endfunction
    augroup VistaAu
        autocmd!
        autocmd FileType vista_kind call s:vista_mappings()
        autocmd FileType markdown nnoremap <silent><A-b> :<C-u>Vista toc<CR>
    augroup END
endif
"}}}
"{{{neoformat
"{{{neoformat-usage
function! Help_neoformat()
    echo '<leader><Tab>         普通模式和可视模式排版'
    echo ''
    echo 'Normal Mode Syntax'
    echo ':<C-u>Neoformat python'
    echo ':<C-u>Neoformat yapf'
    echo ''
    echo 'Visual Mode Syntax'
    echo ':Neoformat! python'
    echo ':Neoformat! yapf'
endfunction
"}}}
"{{{Neoformat_Default_Filetype_Formatter
function! Neoformat_Default_Filetype_Formatter()
    if &filetype ==# 'c'
        execute 'Neoformat astyle'
    elseif &filetype ==# 'cpp'
        execute 'Neoformat astyle'
    else
        execute 'Neoformat'
    endif
endfunction
"}}}
" :h neoformat-supported-filetypes
" format on save
" augroup fmt
" autocmd!
" autocmd BufWritePre * undojoin | Neoformat
" augroup END
" Enable alignment
let g:neoformat_basic_format_align = 1
" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1
" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
nnoremap <silent> <leader><Tab> :<C-u>call Neoformat_Default_Filetype_Formatter()<CR>
vnoremap <silent> <leader><Tab> :Neoformat! &ft<CR>
"}}}
"{{{nerdcommenter
"{{{nerdcommenter-usage
" <leader>c?  显示帮助
function! Help_nerdcommenter()
    echo "[count]<Leader>cc                             NERDComComment, Comment out the current [count] line or text selected in visual mode\n"
    echo "[count]<Leader>cu                             NERDComUncommentLine, Uncomments the selected line(s)\n"
    echo "[count]<Leader>cn                             NERDComNestedComment, Same as <Leader>cc but forces nesting\n"
    echo "[count]<Leader>c<space>                       NERDComToggleComment, Toggles the comment state of the selected line(s). If the topmost selected, line is commented, all selected lines are uncommented and vice versa.\n"
    echo "[count]<Leader>cm                             NERDComMinimalComment, Comments the given lines using only one set of multipart delimiters\n"
    echo "[count]<Leader>ci                             NERDComInvertComment, Toggles the comment state of the selected line(s) individually\n"
    echo "[count]<Leader>cs                             NERDComSexyComment, Comments out the selected lines sexily'\n"
    echo "[count]<Leader>cy                             NERDComYankComment, Same as <Leader>cc except that the commented line(s) are yanked first\n"
    echo "<Leader>c$                                    NERDComEOLComment, Comments the current line from the cursor to the end of line\n"
    echo "<Leader>cA                                    NERDComAppendComment, Adds comment delimiters to the end of line and goes into insert mode between them\n"
    echo "<Leader>ca                                    NERDComAltDelim, Switches to the alternative set of delimiters\n"
    echo '[count]<Leader>cl && [count]<Leader>cb        NERDComAlignedComment, Same as NERDComComment except that the delimiters are aligned down the left side (<Leader>cl) or both sides (<Leader>cb)'
endfunction
nnoremap <silent> <leader>c? :<C-u>call Help_nerdcommenter()<CR>
"}}}
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
"}}}
"{{{async.vim
let g:lightline#asyncrun#indicator_none = ''
let g:lightline#asyncrun#indicator_run = 'Running...'
"}}}
"{{{vim-visual-multi
"{{{vim-visual-multi-usage
function! Help_vim_visual_multi()
    echo '<F1>          help'
    echo "\n"
    echo 'word 匹配'
    echo 'visual mode选中文本，<leader>]  开始匹配'
    echo ']             匹配下一个'
    echo '[             匹配上一个'
    echo '}             跳转到下一个选中'
    echo '{             跳转到上一个选中'
    echo '<C-f>         跳转到最后一个选中'
    echo '<C-b>         跳转到第一个选中'
    echo 'q             删除当前选中'
    echo 'Q             删除选中区域'
    echo '选中完成后，按i或a进入插入模式，也可以返回普通模式'
    echo '普通模式下h, j, k, l来整体挪移光标'
    echo '<Space>       切换Extend模式'
    echo '<Esc>         退出'
    echo "\n"
    echo 'position 选中'
    echo 'normal mode中，<Tab>选中当前位置'
    echo '普通模式下h, j, k, l来整体挪移光标'
    echo '<Tab>         extend mode'
    echo ']             跳转到下一个选中'
    echo '[             跳转到上一个选中'
    echo '}             跳转到下一个选中'
    echo '{             跳转到上一个选中'
    echo '<C-f>         跳转到最后一个选中'
    echo '<C-b>         跳转到第一个选中'
    echo 'q             删除当前选中'
    echo 'Q             删除选中区域'
    echo '选中完成后，按i或a进入插入模式，也可以返回普通模式'
    echo '普通模式下h, j, k, l来整体挪移光标'
    echo '<Space>       切换Extend模式'
    echo '<Esc>         退出'
    echo "\n"
    echo 'visual mode 选中'
    echo 'visual mode选中后，<Tab>添加光标'
    echo '或者在visual mode选中后，按g/搜索，将会匹配所有搜索结果并进入Extend mode'
    echo '选中完成后，按i或a进入插入模式，也可以返回普通模式'
    echo '普通模式下h, j, k, l来整体挪移光标'
    echo '<Space>       切换Extend模式'
    echo '<Esc>         退出'
    echo "\n"
    echo 'Extend 模式'
    echo '相当于visual模式'
    echo 'h, j, k, l来选中区域'
    echo '<Space>       切换Extend模式'
    echo '<Esc>         退出'
endfunction
"}}}
" https://github.com/mg979/vim-visual-multi/wiki
function! Init_visual_multi()
    vmap <leader>] <C-n>
    let g:VM_maps = {}
    let g:VM_maps['Switch Mode']                 = '<Space>'
    let g:VM_maps['Add Cursor At Pos']           = '<Tab>'
    let g:VM_maps['Visual Cursors']              = '<Tab>'
    let g:VM_maps['Add Cursor Up']               = '<M-z>``````addup'
    let g:VM_maps['Add Cursor Down']             = '<M-z>``````adddown'
    let g:VM_maps['I Arrow ge']                  = '<M-z>``````addup'
    let g:VM_maps['I Arrow e']                   = '<M-z>``````adddown'
    let g:VM_maps['Select e']                    = '<M-z>``````addright'
    let g:VM_maps['Select ge']                   = '<M-z>``````addleft'
    let g:VM_maps['I Arrow w']                   = '<M-z>``````addright'
    let g:VM_maps['I Arrow b']                   = '<M-z>``````addleft'
endfunction
call Init_visual_multi()
"}}}
"{{{vim-prosession
"{{{vim-prosession-usage
function! Help_vim_prosession()
    echo ':Prosession {dir}             switch to the session of {dir}, if doesnt exist, creat a new session'
    echo ':ProsessionDelete [{dir}]     if no {dir} specified, delete current active session'
    echo ':ProsessionList {filter}      if no {filter} specified, list all session'
endfunction
"}}}
augroup SessionAu
    autocmd!
    autocmd VimLeave * mksession! ~/.cache/vim/sessions/LastSession
augroup END
let g:prosession_dir = '~/.cache/vim/prosession/'
let g:prosession_on_startup = 0
command! -nargs=? ProsessionList echo prosession#ListSessions(<q-args>)
"}}}
"{{{vim-bookmarks
"{{{vim-bookmarks-usage
function! Help_vim_bookmarks()
    echo '<Leader>bs Search and Manage Bookmarks using unite'
    echo 'Unite Actions: preview, delete, replace, open, yank, highlight, etc.'
    echo '<Leader>bb            <Plug>BookmarkToggle'
    echo '<Leader>ba            <Plug>BookmarkAnnotate'
    echo '<Leader>bj            <Plug>BookmarkNext'
    echo '<Leader>bk            <Plug>BookmarkPrev'
    echo '<Leader>bc            <Plug>BookmarkClear'
    echo '<Leader>bC            <Plug>BookmarkClearAll'
    echo '" these will also work with a [count] prefix'
    echo '<Leader>bK            <Plug>BookmarkMoveUp'
    echo '<Leader>bJ            <Plug>BookmarkMoveDown'
    echo '<Leader>b<Tab>        <Plug>BookmarkMoveToLine'
    echo "\n"
    echo '<Leader>b?            Help'
endfunction
"}}}
"{{{Bookmark_Unite
let g:Load_Unite = 0
function! Bookmark_Unite()
    if g:Load_Unite == 0
        let g:Load_Unite = 1
        call plug#load('unite.vim', 'vim-qfreplace')
        call unite#custom#profile('source/vim_bookmarks', 'context', {
                    \   'winheight': 13,
                    \   'direction': 'botright',
                    \   'start_insert': 0,
                    \   'keep_focus': 1,
                    \   'no_quit': 1,
                    \ })
        execute 'Unite vim_bookmarks'
    elseif g:Load_Unite == 1
        execute 'Unite vim_bookmarks'
    endif
endfunction
augroup Unite_Config
    autocmd!
    autocmd FileType unite call s:unite_settings()
augroup END
function! s:unite_settings() abort
    nnoremap <silent><buffer><expr> <C-p>
                \ unite#do_action('preview')
endfunction
"}}}
let g:bookmark_sign = '✭'
let g:bookmark_annotation_sign = '☰'
let g:bookmark_auto_save = 1
let g:bookmark_auto_save_file = $HOME .'/.cache/vim/.vimbookmarks'
let g:bookmark_highlight_lines = 1
let g:bookmark_show_warning = 0
let g:bookmark_show_toggle_warning = 0
let g:bookmark_auto_close = 1
let g:bookmark_no_default_key_mappings = 1
nmap <Leader>bb <Plug>BookmarkToggle
nmap <Leader>ba <Plug>BookmarkAnnotate
nmap <silent> <Leader>bs :<C-u>call Bookmark_Unite()<CR>
nmap <Leader>bj <Plug>BookmarkNext
nmap <Leader>bk <Plug>BookmarkPrev
nmap <Leader>bc <Plug>BookmarkClear
nmap <Leader>bC <Plug>BookmarkClearAll
" these will also work with a [count] prefix
nmap <Leader>bK <Plug>BookmarkMoveUp
nmap <Leader>bJ <Plug>BookmarkMoveDown
nmap <Leader>b<Tab> <Plug>BookmarkMoveToLine
nmap <silent> <Leader>b? :<C-u>call Help_vim_bookmarks()<CR>
"}}}
"{{{suda.vim
"{{{suda.vim-usage
" :E filename  sudo edit
" :W       sudo edit
"}}}
command! -nargs=1 E  edit  suda://<args>
command W w suda://%
"}}}
"{{{vim-surround
"{{{vim-surround-usage
" 主quickmenu
function! Help_vim_surround()
    echo 'ds([          delete surround'
    echo 'cs([          change surround () to []'
    echo 'ysw[          add surround [] from current position to the end of this word'
    echo 'ysiw[         add surround [] from the begin of this word to the end'
    echo 'yss[          add surround [] from the begin of this line to the end'
endfunction
"}}}
"}}}
"{{{inline_edit.vim
nnoremap E :<C-u>InlineEdit<CR>
vnoremap E :InlineEdit<CR>
"}}}
"{{{vim-youdao-translater
"{{{vim-youdao-translater-usage
" 普通模式<leader>t翻译当前word
" 可视模式<leader>t翻译选中文本
" 普通模式<leader>T输入pattern翻译
"}}}
vnoremap <silent> <leader>t :<C-u>Ydv<CR>
nnoremap <silent> <leader>t :<C-u>Ydc<CR>
nnoremap <silent> <leader>T :<C-u>Yde<CR>
"}}}
"{{{comfortable-motion.vim
"{{{comfortable-motion.vim-usage
" <pageup> <pagedown>平滑滚动
" nvim中，<A-J>和<A-K>平滑滚动
"}}}
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0
nnoremap <silent> <pagedown> :<C-u>call comfortable_motion#flick(130)<CR>
nnoremap <silent> <pageup> :<C-u>call comfortable_motion#flick(-130)<CR>
if has('nvim')
    nnoremap <silent> <A-J> :<C-u>call comfortable_motion#flick(130)<CR>
    nnoremap <silent> <A-K> :<C-u>call comfortable_motion#flick(-130)<CR>
endif
"}}}
"{{{codi.vim
let g:codi#width = 40
let g:codi#rightsplit = 1
let g:codi#rightalign = 0
"}}}
"{{{auto-pairs
if g:VIM_Enable_Autopairs == 1
    "{{{auto-pairs-usage
    " 主quickmenu
    function! Help_auto_pairs()
        echo '插入模式下：'
        echo '<A-z>p            toggle auto-pairs'
        echo '<A-n>             jump to next closed pair'
        echo '<A-Backspace>     delete without pairs'
        echo '<A-z>[key]        insert without pairs'
    endfunction
    "}}}
    let g:AutoPairsShortcutToggle = '<A-z>p'
    let g:AutoPairsShortcutFastWrap = '<A-z>`sadsfvf'
    let g:AutoPairsShortcutJump = '<A-n>'
    let g:AutoPairsWildClosedPair = ''
    let g:AutoPairsMultilineClose = 0
    let g:AutoPairsFlyMode = 0
    let g:AutoPairsMapCh = 0
    inoremap <A-z>' '
    inoremap <A-z>" "
    inoremap <A-z>` `
    inoremap <A-z>( (
    inoremap <A-z>[ [
    inoremap <A-z>{ {
    inoremap <A-z>) )
    inoremap <A-z>] ]
    inoremap <A-z>} }
    inoremap <A-Backspace> <Space><Esc><left>"_xa<Backspace>
    " imap <A-Backspace> <A-z>p<Backspace><A-z>p
    augroup AutoPairsAu
        autocmd!
        " au Filetype html let b:AutoPairs = {"<": ">"}
    augroup END
endif
"}}}
"{{{pomodoro.vim
if g:VIM_Is_In_Tmux == 0
    let g:Pomodoro_Status = 0
    function! Toggle_Pomodoro()
        if g:Pomodoro_Status == 0
            let g:Pomodoro_Status = 1
            execute 'PomodoroStart'
        elseif g:Pomodoro_Status == 1
            let g:Pomodoro_Status = 0
            execute 'PomodoroStop'
        endif
    endfunction
    let g:pomodoro_time_work = 25
    let g:pomodoro_time_slack = 5
endif
"}}}
"{{{vim-matchup
"{{{vim-matchup-usage
function! Help_vim_matchup()
    echo 'surrounding match highlight bold, word match highlight underline'
    echo ''
    echo 'Match Word Jump:'
    echo '%     jump to next word match current cursor position'
    echo 'g%    jump to previous word match current cursor position'
    echo '[%    jump to first word match current cursor position'
    echo ']%    jump to last word match current cursor position'
    echo '[%    if at the beginning of current outer, jump to previous outer'
    echo ']%    if at the end of current outer, jump to next outer'
    echo ''
    echo 'Match Surrounding Jump:'
    echo 'z%    jump inside the nearest surrounding'
    echo '[%    jump to the beginning of current surrounding'
    echo ']%    jump to the end of current surrounding'
    echo '[%    if at the beginning of current surrounding, jump to previous outer surrounding'
    echo ']%    if at the end of current surrounding, jump to next outer surrounding'
    echo '<leader>% or double-click     select current surrounding'
    echo ''
    echo 'Exception:'
    echo '%     if not recognize, seek forwards to one and then jump to its match (surrounding or word)'
    echo 'g%    if at an open word, cycle around to the corresponding open word'
    echo 'g%    if the cursor is not on a word, seek forwards to one and then jump to its match'
    echo ''
    echo 'support [count][motion] and [action][motion] syntax'
endfunction
"}}}
let g:matchup_matchparen_deferred = 1  " highlight surrounding
let g:matchup_matchparen_hi_surround_always = 1  " highlight surrounding
let g:matchup_delim_noskips = 2  " don't recognize anything in comments
nmap <leader>% ]%V[%
nmap <2-LeftMouse> ]%V[%
hi MatchParen cterm=bold gui=bold
hi MatchParenCur cterm=bold gui=bold
hi MatchWord cterm=underline gui=underline
hi MatchWordCur cterm=underline gui=underline
"}}}
" {{{vim-manpager
if exists('g:VIM_MANPAGER')
    " {{{vim-manpager-usage
    function! Help_vim_manpager()
        echo 'shell里"man foo"启动'
        echo '<CR>              打开当前word的manual page'
        echo '<C-o>             跳转到之前的位置'
        echo '<Tab>             跳转到下一个历史'
        echo '<S-Tab>           跳转到上一个历史'
        echo '<C-j>             跳转到下一个keyword'
        echo '<C-k>             跳转到上一个keyword'
        echo 'f                 FuzzyFind'
        echo 'E                 set modifiable'
        echo '<A-w>             quit'
        echo '?                 Help'
    endfunction
    " }}}
    function! s:vim_manpager_mappings() abort
        if g:VIM_Fuzzy_Finder ==# 'denite'
            nnoremap <silent><buffer> f :<C-u>Denite line:buffer<CR>
        elseif g:VIM_Fuzzy_Finder ==# 'fzf'
            nnoremap <silent><buffer> f :<C-u>BLines<CR>
        elseif g:VIM_Fuzzy_Finder ==# 'leaderf' || g:VIM_Fuzzy_Finder ==# 'remix'
            nnoremap <silent><buffer> f :<C-u>LeaderfLine<CR>
        endif
        nnoremap <silent><buffer> ? :<C-u>call Help_vim_manpager()<CR>
        nmap <silent><buffer> <C-j> ]t
        nmap <silent><buffer> <C-k> [t
        nmap <silent><buffer> <A-w> :<C-u>call ForceCloseRecursively()<CR>
        nnoremap <silent><buffer> K zz:<C-u>call smooth_scroll#up(&scroll, 10, 1)<CR>
        nnoremap <silent><buffer> E :<C-u>set modifiable<CR>
    endfunction
    augroup ManpagerAu
        autocmd!
        autocmd FileType man call s:vim_manpager_mappings()
    augroup END
endif
" }}}
"{{{emmet-vim
"{{{emmet-vim-usage
" https://blog.zfanw.com/zencoding-vim-tutorial-chinese/
" :h emmet
"}}}
function Func_emmet_vim()
    let g:user_emmet_leader_key='<A-z>'
    let g:user_emmet_mode='in'  "enable in insert and normal mode
endfunction
"}}}
"{{{vim-closetag
"{{{vim-closetag-usage
function! Help_vim_closetag()
    echo ''
    echo '<A-z>>  Add > at current position without closing the current tag'
    echo ''
endfunction
"}}}
function! Func_vim_closetag()
    " Shortcut for closing tags, default is '>'
    let g:closetag_shortcut = '>'
    " Add > at current position without closing the current tag, default is ''
    let g:closetag_close_shortcut = '<A-z>>'
endfunction
"}}}
"{{{vim-json
function! Func_vim_json()
    let g:vim_json_syntax_conceal = 0
    set foldmethod=syntax
    call ToggleIndent()
endfunction
"}}}
"{{{vim-devicons
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols[''] = "\uf15b"
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ''
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
"}}}
