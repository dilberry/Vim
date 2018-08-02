" Vi Compatibility {
	if &compatible
		set nocompatible
	endif
" }

" Platform detection {
	let s:is_windows = has('win16') || has('win32') || has('win64')
	let s:is_cygwin  = has('win32unix')
	let s:is_mac     = !s:is_windows && !s:is_cygwin
						\ && (has('mac') || has('macunix') || has('gui_macvim') ||
						\    (!executable('xdg-open') && system('uname') =~? '^darwin'))
" }

" Windows defaults {
	if s:is_windows
		source $VIMRUNTIME/mswin.vim
	endif
" }

" Diff Function {
	set diffexpr=
	function! MyDiff()
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
" }

" Path correction {
	" This is to make the Vim installation portable
	" Set the VIMHOME path variable to where this vimrc is sourced
	let $VIMHOME = expand('<sfile>:p:h')

	if s:is_windows
		let g:python_host_prog = 'C:\Python27\python.exe'
		let g:python3_host_prog = 'C:\Python37\python.exe'

		if !executable('xmllint')
			" Add xmllint binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\xmllint\bin\'
		endif

		if !executable('AStyle')
			" Add AStyle binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\AStyle\bin\'
		endif

		if !executable('ctags')
			" Add ctags binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\ctags\'
		endif

		if !executable('fzf')
			" Add fzf binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\fzf\'
		endif

		if !executable('rg')
			" Add ripgrep binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\rg\'
		endif
	endif

	" Add pylint settings folder
	let $PATH .= ';'.$VIMHOME.'\pylint\'
" }

" Plug {
	let g:dein_dir = expand($VIMHOME.'\vimfiles\dein.vim')
	let g:dein_plugins_dir = expand($VIMHOME.'\vimfiles\plugins')
	exec 'set runtimepath^='.g:dein_dir

	" Specify a directory for plugins
	if dein#load_state(g:dein_plugins_dir)
		call dein#begin(g:dein_plugins_dir)

		call dein#add(g:dein_plugins_dir)

		" UI {
			" syntastic
			call dein#add('https://github.com/vim-syntastic/syntastic.git')

			" vim-airline
			call dein#add('https://github.com/vim-airline/vim-airline.git')

			" vim-colorschemes
			call dein#add('https://github.com/flazz/vim-colorschemes.git')

			" colour-schemes
			call dein#add('https://github.com/daylerees/colour-schemes.git', { 'rtp': 'vim'})

			" random-colorscheme-picker
			call dein#add('https://github.com/dilberry/random-colorscheme-picker.git')

			" vim-indent-guides
			call dein#add('https://github.com/nathanaelkane/vim-indent-guides.git')

			" rainbow
			call dein#add('https://github.com/luochen1990/rainbow.git')
		" }

		" Git {
			" vim-fugitive
			call dein#add('https://github.com/tpope/vim-fugitive.git', { 'rev': 'v2.3'})

			" gitv
			call dein#add('https://github.com/gregsexton/gitv.git')

			" vim-gitgutter
			call dein#add('https://github.com/airblade/vim-gitgutter.git')
		" }

		" Editing {
			" Align
			call dein#add('https://github.com/lboulard/Align.git')

			" vim-surround
			call dein#add('https://github.com/tpope/vim-surround.git')

			" YAIFA
			call dein#add('https://github.com/Raimondi/YAIFA.git')

			" vim-repeat
			call dein#add('https://github.com/tpope/vim-repeat.git')

			" vim-unimpaired
			call dein#add('https://github.com/tpope/vim-unimpaired.git')

			" vim-qfreplace
			call dein#add('https://github.com/thinca/vim-qfreplace.git')
		" }

		" Browsing {
			" fzf
			call dein#add('https://github.com/junegunn/fzf.git', { 'merged': 0 })

			" fzf-vim
			call dein#add('https://github.com/junegunn/fzf.vim.git', { 'merged': 0, 'depends': ['fzf'] })

			" denite
			call dein#add('https://github.com/Shougo/denite.nvim.git')

			" vim-leader-guide
			call dein#add('https://github.com/hecal3/vim-leader-guide.git')

			" vim-vinegar
			call dein#add('https://github.com/tpope/vim-vinegar.git')
		" }

		" Omnicompletion {
			" deoplete
			" This needs python3 neovim package to be installed
			if has('nvim')
				call dein#add('https://github.com/Shougo/deoplete.nvim.git')
			else
				call dein#add('https://github.com/Shougo/deoplete.nvim.git')
				call dein#add('https://github.com/roxma/nvim-yarp.git')
				call dein#add('https://github.com/roxma/vim-hug-neovim-rpc.git')
			endif

			" neco-syntax
			call dein#add('https://github.com/Shougo/neco-syntax.git', { 'depends': 'deoplete.nvim'})

			" omnisharp-vim
			call dein#add('https://github.com/OmniSharp/omnisharp-vim.git', { 'on_ft': 'cs' })

			" deoplete-jedi
			call dein#add('https://github.com/zchee/deoplete-jedi.git', { 'depends': ['deoplete.nvim', 'jedi'], 'on_ft': 'python'})

			" deoplete-omnisharp
			call dein#add('https://github.com/gautamnaik1994/deoplete-omnisharp.git', { 'depends': ['deoplete.nvim'], 'on_ft': 'cs'})
		" }

		" Tags {
			" tagbar
			call dein#add('https://github.com/majutsushi/tagbar.git')

			" vim-gutentags
			call dein#add('https://github.com/ludovicchabant/vim-gutentags.git')
		" }

		" File types{
			" vim-csharp
			call dein#add('https://github.com/OrangeT/vim-csharp.git', { 'on_ft': 'cs' })

			" vim-jsbeautify
			call dein#add('https://github.com/maksimr/vim-jsbeautify.git', { 'on_ft': ['javascript', 'json', 'jsx', 'html', 'css']})
		" }

		" Check for unmet dependencies
		if !executable('python')
			call dein#disable('deoplete.nvim')
			call dein#disable('deoplete-omnisharp')
		endif

		if !executable('ctags')
			call dein#disable('tagbar')
			call dein#disable('vim-gutentags')
		endif

		if !executable('node')
			call dein#disable('vim-jsbeautify')
		endif

		if !executable('git')
			call dein#disable('vim-fugitive')
		endif

		" Initialise plugin system
		call dein#end()
		call dein#save_state()
	endif
" }

" Encoding {
	set encoding=utf-8
" }

" Leader mapping function {
    let s:leader_bind_callbacks = []
	function! s:leader_bind(map, keys, value, long_name, short_name, is_cmd)
		if a:is_cmd
			" If a:value is a complete command e.g. :Gblame<CR>
			let l:value = ':' . a:value . '<CR>'
			" The underscore denotes the leader key (space).
			let l:long_name = a:long_name . ' (_' . join(a:keys, '') . ')'
			let l:cmd_value = a:value
			let l:short_name = a:short_name
		else
			let l:value = a:value
			let l:long_name = a:long_name . ' (_' . join(a:keys, '') . ') (nop)'
			let l:cmd_value = ''
			let l:short_name = a:short_name . ' (nop)'
		endif

		execute a:map . ' <leader>' . join(a:keys, '') . ' ' . l:value

        for CallBack in s:leader_bind_callbacks
            call CallBack(a:keys, l:long_name, l:cmd_value)
        endfor
	endfunction
" }

" Key Remapping {
	" Set Leader to Space
	let mapleader = ' '

	" Remove the Windows ^M - when the encodings gets messed up
	noremap <Leader>M mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

	" Buffer cycle
	nnoremap <Tab> :bnext<CR>
	nnoremap <S-Tab> :bprevious<CR>

	" Increment/Decrement remapping
	noremap <C-kPlus> <C-A>
	noremap <C-kMinus> <C-X>

	" Swap Normal and Visual mode semicolon and colon
	nnoremap ; :
	nnoremap : ;
	vnoremap ; :
	vnoremap : ;

	" Retain selection after shift operations
	" Taken from http://vimbits.com/bits/20
	vnoremap < <gv
	vnoremap > >gv

	" Yank to EOL, making Y behave more like the other capitals (C and D).
	" Taken from http://vimbits.com/bits/11
	noremap Y y$
" }

" Misc options {
	set backspace=indent,eol,start " Allow backspacing over everything in insert mode.
	set ruler                      " Show the cursor position all the time
	set showcmd                    " Display incomplete commands
	set nowrap                     " Set lines to no wrap
	set viminfo+=!                 " Set viminfo to store and restore global variables
	set history=700                " Sets how many lines of history VIM has to remember
	set modeline                   " Use modelines
	set number                     " Display line numbers
	set autochdir                  " Auto change working directory to the current file
	set hidden                     " Allow changing buffer without saving
	set autoread                   " auto-reload files, if there's no conflict
	set shortmess+=IA              " no intro message, no swap-file message
	set updatetime=500             " this setting controls how long to wait (in ms) before fetching type / symbol information.
	set cmdheight=2                " Remove 'Press Enter to continue' message when type information is longer than one line.
	set nrformats-=octal           " Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it confusing.
	set nofoldenable               " Disable folding
	set timeoutlen=100
	set ttimeoutlen=100
" }

" Saving options {
	" Disable swap files and backup files
	set nobk
	set nobackup
	set nowritebackup
	set noswapfile
	set noundofile
" }

" Search options {
	set ignorecase " Ignore case when searching
	set hlsearch   " Highlight search things
	set incsearch  " Make search act like search in modern browsers
" }

" Tab options {
	" Completion options
	set completeopt=longest,menuone

	" Tab completion in commands
	set wildmenu
	set wildmode=list:longest
" }

" Filetype options {
	filetype on        " Enable filetypes
	syntax on          " Enable syntax highlighting
	filetype plugin on " Enable filetype plugins

	" XML options {
		let g:xml_syntax_folding = 1
		au FileType xml setlocal foldmethod=syntax
	" }
" }

" Indent options {
	filetype indent on " Enable filetype indentation
	set autoindent     " Auto indent for code blocks
	set smarttab       " Backspace to remove space-indents
" }

" GUI options {
	set nolazyredraw " Don't redraw while executing macros

	if has('gui_running')
		if s:is_windows
			set guioptions-=t
			autocmd GUIEnter * simalt ~x             " Maximise on GUI entry
			set guifont=PragmataPro:h10:cANSI:qDRAFT " Select GUI font
		endif
		autocmd GUIEnter * set vb t_vb=              " Disable audible bell
	endif
" }

" Slickfix {
	" Quickfix and qfreplace
	" Turn into leader command with line search of current pattern, open quickfix
	" and qfreplace. On buffer save, save changes back but don't write to file
	function! Slickfix()
		call setqflist([])
		let s:ft_backup = &filetype
		:g//caddexpr expand("%").":".line(".").":". getline(".")
		execute "cw"
		execute "set filetype=".s:ft_backup
	endfunction

	function! QFWinNum()
		redir =>bufliststr
		silent! ls
		redir END
		let buflist = map(filter(split(bufliststr, '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
		for bufnum in buflist
			return winbufnr(bufnum)
		endfor
		return -1
	endfunction

	function! SlickWinChange()
		execute ".cc"
		execute "normal zz"
		set nocursorline
		set cursorline
		execute QFWinNum()."wincmd w"
	endfunction

	function! SlickWinClose()
		execute ".cc"
		execute "normal zz"
		set nocursorline
		execute "bdelete ".QFWinNum()
		call setqflist([])
	endfunction

	command! Slickfix call Slickfix()
	noremap <Leader>f * :Slickfix<CR>
	autocmd! BufReadPost quickfix nnoremap <buffer> <Space> :call SlickWinChange()<CR>
" }

" vim-airline options {
if dein#tap('vim-airline')
	set laststatus=2 " Show 2 lines of status
	set noshowmode   " Don't show mode on statusline, let airline do it instead
	let g:airline_detect_modified              = 1
	let g:airline#extensions#tagbar#enabled    = 1
	let g:airline#extensions#syntastic#enabled = 1
	let g:airline#extensions#hunks#enabled     = 1
endif
" }

" Filetype plugins {
	" syntastic settings {
	if dein#tap('syntastic')
		let g:syntastic_mode_map = { 'mode' : 'passive', 'active_filetypes' : [], 'passive_filetypes' : [] }
		noremap <Leader>c :SyntasticCheck<CR>
	endif

	" Python {
		" syntastic settings {
		if dein#tap('syntastic')
			let g:syntastic_python_checkers         = ['pylint']
			let g:syntastic_python_pylint_post_args = '--rcfile='.'"'.$VIMHOME.'\pylint\pylint.rc'.'"'
		endif
		" }
	" }

	" C# {
		" syntastic settings {
		if dein#tap('syntastic')
			let g:syntastic_cs_checkers = ['code_checker']
		endif
		" }
	" }

	" Visual Basic {
		" Tagbar settings {
		if dein#tap('tagbar')
			let g:tagbar_type_vb = {
				\ 'ctagstype' : 'vb',
				\ 'deffile' : $VIMHOME.'\utils\ctags\ctags.cfg',
				\ 'kinds'     : [
					\ 's:subroutines',
					\ 'f:functions',
					\ 'v:variables',
					\ 'c:constants',
					\ 'e:enums',
					\ 'n:names',
					\ 'l:labels',
				\ ]
			\ }
		endif
		" }
	" }

	augroup AStyler
		autocmd!
	augroup END

	" C options {
		autocmd AStyler FileType c :nnoremap <Leader>a :call system('AStyle --mode=c --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" C++ options {
		autocmd AStyler FileType cpp :nnoremap <Leader>a :call system('AStyle --mode=c --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" java options {
		autocmd AStyler FileType java :nnoremap <Leader>a :call system('AStyle --mode=java --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" javascript options {
		autocmd AStyler FileType javascript :nnoremap <Leader>a :call system('AStyle --mode=java --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	if !executable('AStyle')
		augroup AStyler
			autocmd!
		augroup END
	endif

	augroup JSBeautify
		autocmd!
	augroup END

	" javascript options {
		autocmd FileType javascript noremap <buffer>  <Leader>a :call JsBeautify()<cr>
	" }

	" json options {
		autocmd FileType json noremap <buffer> <Leader>a :call JsonBeautify()<cr>
	" }

	" jsx options {
		autocmd FileType jsx noremap <buffer> <Leader>a :call JsxBeautify()<cr>
	" }

	" html options {
		autocmd FileType html noremap <buffer> <Leader>a :call HtmlBeautify()<cr>
	" }

	" css options {
		autocmd FileType css noremap <buffer> <Leader>a :call CSSBeautify()<cr>
	" }

	if !executable('node') || !dein#tap('vim-jsbeautify')
		augroup JSBeautify
			autocmd!
		augroup END
	endif
" }

" indent-guides options {
if dein#tap('vim-indent-guides')
	let g:indent_guides_enable_on_vim_startup = 1
endif
" }

" Tag plugins {
	" Tagbar options {
	if dein#tap('tagbar')
		" Tagbar Toggle
		nnoremap <silent> <F8> :TagbarToggle<CR>
		let g:tagbar_ctags_bin = $VIMHOME.'\utils\ctags\ctags.exe'
		autocmd VimEnter * nested :call tagbar#autoopen(1)
	endif
	" }

	" Gutentags options {
	if dein#tap('vim-gutentags')
		" Include extra defintions for VB6 tags
		let g:gutentags_ctags_extra_args = ["−−options=".shellescape($VIMHOME.'\utils\ctags\ctags.cfg')]
		let g:gutentags_cache_dir = $VIMHOME.'\utils\ctags\cache'
	endif
	" }
" }

" Rainbow options {
if dein#tap('rainbow')
	let g:rainbow_active = 1 " Enable rainbow by default
	let g:rainbow_conf = {
	\	'guifgs': ['deepskyblue3', 'seagreen3', 'darkorchid3', 'firebrick3', 'steelblue3', 'chartreuse3', 'violetred3', 'orangered3'],
	\	'ctermfgs': [ 'brown', 'Darkblue', 'darkgray', 'darkgreen', 'darkcyan', 'darkred', 'darkmagenta', 'brown'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}

	" rainbow_parentheses toggle
	nnoremap <silent> <Leader>t :RainbowToggle<CR>
endif
" }

" fzf options {
if dein#tap('fzf.vim')
	" Default fzf layout
	" - down / up / left / right
	let g:fzf_layout = { 'down': '~40%' }

	" CTRL-A CTRL-Q to select all and build quickfix list
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
		copen
		cc
	endfunction

	function! s:align_lists(lists)
		let maxes = {}
		for list in a:lists
			let i = 0
			while i < len(list)
				let maxes[i] = max([get(maxes, i, 0), len(list[i])])
				let i += 1
			endwhile
		endfor

		for list in a:lists
			call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
		endfor

		return a:lists
	endfunction

	function! s:btags_source(tag_cmds)
		if !filereadable(expand('%'))
			throw 'Save the file first'
		endif

		for cmd in a:tag_cmds
			let lines = split(system(cmd), "\n")
			if !v:shell_error && len(lines)
				break
			endif
		endfor

		if v:shell_error
			throw get(lines, 0, 'Failed to extract tags')
		elseif empty(lines)
			throw 'No tags found'
		endif

		return map(s:align_lists(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
	endfunction

	function! s:btags_sink(line)
		execute split(a:line, "\t")[2]
	endfunction

	function! s:btags(query, ...)
		let args = copy(a:000)
		let escaped = fzf#shellescape(expand('%'))
		let null = s:is_windows ? 'nul' : '/dev/null'
		let sort = has('unix') && !has('win32unix') && executable('sort') ? '| sort -s -k 5' : ''
		let tag_cmds = (len(args) > 1 && type(args[0]) != type({})) ? remove(args, 0) : [
		\ printf('ctags -f - --sort=yes --excmd=number --language-force=%s --options=%s %s 2> %s %s', &filetype, shellescape($VIMHOME.'\utils\ctags\ctags.cfg'), escaped, null, sort),
		\ printf('ctags -f - --sort=yes --excmd=number --options=%s %s 2> %s %s', shellescape($VIMHOME.'\utils\ctags\ctags.cfg'), escaped, null, sort)]

		if type(tag_cmds) != type([])
			let tag_cmds = [tag_cmds]
		endif

		try
			call fzf#run({
			\ 'source':  s:btags_source(tag_cmds),
			\ 'options': '--reverse -m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index --prompt "BTags> "',
			\ 'down'   : '40%',
			\ 'sink'   : function('s:btags_sink')})
		catch
			echohl WarningMsg
			echom v:exception
			echohl None
		endtry
	endfunction

	command! -bang -nargs=* BTags call s:btags(<q-args>, <bang>0)

	" Pretend to be CtrlP
	noremap <c-p> :BTags<CR>

	let g:fzf_action = {
		\ 'ctrl-q': function('s:build_quickfix_list'),
		\ 'ctrl-t': 'tab split',
		\ 'ctrl-x': 'split',
		\ 'ctrl-v': 'vsplit'
	\}

	let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

	if executable("rg")
		" Find files using Ripgrep and FZF
		command! -bang -nargs=* Find
		\ call fzf#vim#grep(
		\   'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
		\   <bang>0 ? fzf#vim#with_preview('up:60%')
		\           : fzf#vim#with_preview('right:50%:hidden', '?'),
		\   <bang>0)

		command! -bang -nargs=* GFind
		\ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>).' -- :/', 0, <bang>0)

	endif
endif
" }

" vim vinegar options {
if dein#tap('vim-vinegar')
	autocmd FileType netrw setl bufhidden=wipe
endif
" }

" deoplete options {
if dein#tap('deoplete.nvim')
	" General options
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#file#enable_buffer_path = 1

	let g:deoplete#enable_smart_case = 1
	let g:deoplete#enable_ignore_case = 1
	let g:deoplete#enable_camel_case = 1

	let g:deoplete#omni#input_patterns = {}
	let g:deoplete#omni#functions = {}
	let g:deoplete#sources = {}
	let g:deoplete#sources._ = ['buffer', 'file']

	" Csharp options
	let g:deoplete#omni#input_patterns.cs = ['\.\w*']
	let g:deoplete#sources.cs = ['omni', 'buffer', 'file']

	" Select on Tab
	inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
endif
" }

" vim-leader-guide options {
if dein#tap('vim-leader-guide')
	let g:lmap = {}
	let g:leaderGuide_vertical = 0
	let g:leaderGuide_position = 'botright'
	let g:leaderGuide_max_size = 30

	call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
	nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
	vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

	if dein#tap('vim-fugitive')
		let g:lmap.g = {'name': 'Git/'}
	endif

	if dein#tap('denite.nvim')
        let g:lmap.u = {'name': 'Denite/'}
        let g:lmap.u.t = {'name': 'Tag/'}
        let g:lmap.u.f = {'name': 'File/'}
	endif

	function! s:add_leader_guide_item(keys, name, cmd)
        let l:local_keys = deepcopy(a:keys)
        let l:key = '[' . join(map(l:local_keys, 'shellescape(v:val)'), '][') . ']'

        execute 'let g:lmap' . l:key . ' = '. '[' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']'
	endfunction

    call add(s:leader_bind_callbacks, function('s:add_leader_guide_item'))
endif
" }

" denite options {
if dein#tap('denite.nvim')
	" Add custom menus
	let s:menus = {}
	call denite#custom#var('menu', 'menus', s:menus)

	function! s:add_denite_item(keys, name, cmd)
		if exists('s:menus.' . join(a:keys[:-2], '.'))
			execute 'call add(s:menus.' . join(a:keys[:-2], '.') . '.command_candidates,'. '[' . shellescape(a:name) . ',' . shellescape(a:cmd) . '])'
        else
            execute 'let s:menus.' . join(a:keys[:-1], '.') . ' = '. '{"command_candidates": [' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']}'
		endif
	endfunction

    call add(s:leader_bind_callbacks, function('s:add_denite_item'))

	" reset 50% winheight on window resize
	augroup deniteresize
		autocmd!
		autocmd VimResized,VimEnter * call denite#custom#option('default',
			\'winheight', winheight(0) / 2)
	augroup end

	call denite#custom#option('default', { 'prompt': 'λ' })

	call denite#custom#map('insert', '<Up>'  , '<denite:move_to_previous_line>'         , 'noremap')
	call denite#custom#map('insert', '<C-P>' , '<denite:move_to_previous_line>'         , 'noremap')
	call denite#custom#map('insert', '<C-N>' , '<denite:move_to_next_line>'             , 'noremap')
	call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>'             , 'noremap')
	call denite#custom#map('insert', '<C-G>' , '<denite:assign_next_txt>'               , 'noremap')
	call denite#custom#map('insert', '<C-T>' , '<denite:assign_previous_line>'          , 'noremap')
	call denite#custom#map('insert', '<C-h>' , '<denite:smart_delete_char_before_caret>', 'noremap')
	call denite#custom#map('insert', '<Esc>' , '<denite:enter_mode:normal>'             , 'noremap')
	call denite#custom#map('normal', '/'     , '<denite:enter_mode:insert>'             , 'noremap')
	call denite#custom#map('normal', '<Esc>' , '<denite:quit>'                          , 'noremap')
	call denite#custom#map('normal', '<Up>'  , '<denite:move_to_previous_line>'         , 'noremap')
	call denite#custom#map('normal', '<Down>', '<denite:move_to_next_line>'             , 'noremap')

	let s:menus.u = {'description': 'Denite'}
	let s:menus.u.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['u', 'u'     ], 'Denite menu'        , 'menu'        , 'menu'        , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'h'     ], 'Denite help'        , 'help'        , 'help'        , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'b'     ], 'Denite buffer'      , 'buffer'      , 'buffer'      , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'g'     ], 'Denite grep'        , 'grep'        , 'grep'        , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'l'     ], 'Denite line'        , 'line'        , 'line'        , 1)

	let s:menus.u.t = {'description': 'Tags'}
	let s:menus.u.t.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['u', 't', 'b'], 'Denite outline'     , 'buffer tag'  , 'buffer tag'  , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 't', 'g'], 'Denite tag'         , 'global tag'  , 'global tag'  , 1)

	let s:menus.u.f = {'description': 'Files'}
	let s:menus.u.f.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['u', 'f', 'f'], 'Denite file'        , 'file'        , 'file'        , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'f', 'm'], 'Denite file_mru'    , 'file_mru'    , 'file_mru'    , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'f', 'r'], 'Denite file_rec'    , 'file_rec'    , 'file_rec'    , 1)
	call s:leader_bind('nnoremap <silent>', ['u', 'f', 'g'], 'Denite file_rec_git', 'file_rec_git', 'file_rec_git', 1)

	if dein#tap('vim-fugitive')
		let s:menus.g = {'description': 'Git'}
		let s:menus.g.command_candidates = []
		call s:leader_bind('nnoremap <silent>', ['g', 'b'], 'Gblame'         , 'Git: Blame'                , 'blame'                , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'B'], 'Gbrowse'        , 'Git: Browse'               , 'browse'               , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'c'], ':Gcommit<Space>', 'Git: Commit'               , 'commit'               , 0)
		call s:leader_bind('nnoremap <silent>', ['g', 'C'], 'Gcheckout'      , 'Git: Checkout'             , 'checkout'             , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'D'], 'Gdiff HEAD'     , 'Git: Diff HEAD'            , 'diff HEAD'            , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'd'], 'Gdiff'          , 'Git: Diff'                 , 'diff'                 , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'm'], ':Gmove<Space>'  , 'Git: Move'                 , 'move'                 , 0)
		call s:leader_bind('nnoremap <silent>', ['g', 'p'], 'Gpull'          , 'Git: Pull'                 , 'pull'                 , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'P'], 'Gpush'          , 'Git: Push'                 , 'push'                 , 1)
		call s:leader_bind('nnoremap <silent>', ['g', 'r'], 'Gread'          , 'Git: Checkout current file', 'checkout-current-file', 1)
		call s:leader_bind('nnoremap <silent>', ['g', 's'], 'Gstatus'        , 'Git: Status'               , 'status'               , 1)
	endif

	if executable('rg')
		call denite#custom#var('file_rec', 'command', ['rg', '--files', '--no-heading', '--glob', '!.git', ''])
		call denite#custom#var('grep', 'command', ['rg'])
		call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
		call denite#custom#var('grep', 'recursive_opts', [])
		call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
		call denite#custom#var('grep', 'separator', ['--'])
		call denite#custom#var('grep', 'final_opts', [])
	endif

	if executable('git')
        call denite#custom#alias('source', 'file_rec_git', 'file_rec')
		call denite#custom#var('file_rec_git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])
	endif
endif
" }

" Omnisharp options {
if dein#tap('omnisharp-vim')
	function! s:omnisharp_mapping() abort
		" Synchronous build (blocks Vim)
		"autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
		" Builds can also run asynchronously with vim-dispatch installed
		nnoremap <buffer><leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
		"The following commands are contextual, based on the current cursor position.
		nnoremap <buffer>gd :OmniSharpGotoDefinition<cr>
		nnoremap <buffer><leader>fi :OmniSharpFindImplementations<cr>
		nnoremap <buffer><leader>ft :OmniSharpFindType<cr>
		nnoremap <buffer><leader>fs :OmniSharpFindSymbol<cr>
		nnoremap <buffer><leader>fu :OmniSharpFindUsages<cr>
		"finds members in the current buffer
		nnoremap <buffer><leader>fm :OmniSharpFindMembers<cr>
		" cursor can be anywhere on the line containing an issue
		nnoremap <buffer><leader>x  :OmniSharpFixIssue<cr>
		nnoremap <buffer><leader>fx :OmniSharpFixUsings<cr>
		nnoremap <buffer><leader>tt :OmniSharpTypeLookup<cr>
		nnoremap <buffer><leader>dc :OmniSharpDocumentation<cr>
		"navigate up by method/property/field
		nnoremap <buffer><C-K> :OmniSharpNavigateUp<cr>
		"navigate down by method/property/field
		nnoremap <buffer><C-J> :OmniSharpNavigateDown<cr>
		" Contextual code actions (requires CtrlP or unite.vim)
		nnoremap <buffer><leader><space> :OmniSharpGetCodeActions<cr>
		" Run code actions with text selected in visual mode to extract method
		vnoremap <buffer><leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

		" rename with dialog
		nnoremap <buffer><leader>nm :OmniSharpRename<cr>
		nnoremap <buffer><F2> :OmniSharpRename<cr>
		" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
		command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

		" Force OmniSharp to reload the solution. Useful when switching branches etc.
		nnoremap <buffer><leader>rl :OmniSharpReloadSolution<cr>
		nnoremap <buffer><leader>cf :OmniSharpCodeFormat<cr>
		" Load the current .cs file to the nearest project
		nnoremap <buffer><leader>tp :OmniSharpAddToProject<cr>

		" Start the omnisharp server for the current solution
		nnoremap <buffer><leader>ss :OmniSharpStartServer<cr>
		nnoremap <buffer><leader>sp :OmniSharpStopServer<cr>

		" Add syntax highlighting for types and interfaces
		nnoremap <buffer><leader>th :OmniSharpHighlightTypes<cr>
	endfunction

	augroup omnisharp_commands
		autocmd!

		"Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
		autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

		"Set omnisharp key mappings
		autocmd FileType cs call s:omnisharp_mapping()

		" automatic syntax check on events (TextChanged requires Vim 7.4)
		" autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
		autocmd BufEnter,BufWritePost *.cs SyntasticCheck

		"show type information automatically when the cursor stops moving
		autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
	augroup END

	if !executable('OmniSharp')
		let g:OmniSharp_server_path = $VIMHOME.'\utils\omnisharp.http-win-x64\OmniSharp.exe'
	endif

	let g:OmniSharp_server_type = 'roslyn'
	let g:OmniSharp_prefer_global_sln = 0
	let g:OmniSharp_timeout = 10
	let g:OmniSharp_selector_ui = 'unite'

endif
" }

" vim: set fdm=indent : normal zi
