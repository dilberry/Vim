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

		" Initialise plugin system
		call dein#end()
		call dein#save_state()
	endif
" }

" Encoding {
	set encoding=utf-8
" }

" Key Remapping {
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

" denite options {
if dein#tap('denite.nvim')
	function! s:maybe_add_denite_item(name, cmd)
		if exists('s:menus')
			call add(s:menus.user_commands.command_candidates, [a:name, a:cmd])
		endif
	endfunction

	function! s:maybe_add_leader_guide_item(key, name, cmd)
		if exists('g:lmap')
			execute 'let g:lmap' . a:key . ' = '. '[' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']'
		endif
	endfunction

	function! s:leader_bind(map, key, key2, key3, value, denite_name, guide_name, is_cmd)
		" Args:
		"     map: mapping mode (nmap, inoremap, etc.)
		"     key, key2, key3: up to three keys in the sequences
		"     value: command to be executed (<CR> automatically gets added if is_cmd)
		"     denite_name: name in the denite menu
		"     guide_name: short name for leader guide menu
		"     is_cmd: 1 if command is a complete command, else 0 if user input is needed
		" leader_bind('nnoremap', 'g', 'b', '', 'Gblame', 'Git: Blame', 'blame', 1, 1)
		" leader_bind('nnoremap', 'g', 'g', 'n', 'GitGutterNextHunk', 'Git: Next Hunk', 'next-hunk', 1, 0)
		if a:is_cmd
			" If a:value is a complete command e.g. :Gblame<CR>
			let l:value = ':' . a:value . '<CR>'
			" The underscore denotes the leader key (space).
			let l:denite_name = a:denite_name . ' (_' . a:key . a:key2 . a:key3 . ')'
			let l:denite_cmd = a:value
			let l:guide_name = a:guide_name
		else
			" If a:value is not a complete command e.g. :Gmove<Space> that needs the
			" user to finish the command, we'll append (nop) to indicate that
			" selecting the menu item either in denite or leader-guide does nothing,
			" because incomplete commands are not supported.
			" a:value in this case should contain a leading ':' and trailing '<Space>'.
			" TODO: figure out a way to use incomplete commands.
			let l:value = a:value
			let l:denite_name = a:denite_name . ' (_' . a:key . a:key2 . ') (nop)'
			let l:denite_cmd = ''
			let l:guide_name = a:guide_name . ' (nop)'
		endif

		execute a:map . ' <leader>' . a:key . a:key2 . a:key3 . ' ' . l:value
		call s:maybe_add_denite_item(l:denite_name, l:denite_cmd)

		if strlen(a:key3)
			let l:key = '[' . shellescape(a:key) . ']' . '[' . shellescape(a:key2) . ']' . '[' . shellescape(a:key3) . ']'
		else
			if strlen(a:key2)
				let l:key = '[' . shellescape(a:key) . ']' . '[' . shellescape(a:key2) . ']'
			else
				let l:key = '[' . shellescape(a:key) . ']'
			endif
		endif
		call s:maybe_add_leader_guide_item(l:key, l:guide_name, l:denite_cmd)
	endfunction

	function! s:denite_add_user_command(item, cmd)
		call add(s:menus.user_commands.command_candidates, [a:item, a:cmd])
	endfunction

	let g:lmap = {}
	let g:leaderGuide_vertical = 0
	let g:leaderGuide_position = 'botright'
	let g:leaderGuide_max_size = 30

	call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
	nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
	vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

	" Add custom menus
	let s:menus = {}
	let s:menus.user_commands = {'description': 'User commands'}
	let s:menus.user_commands.command_candidates = [
		\ ['command', 'Denite command'],
		\ ['help', 'Denite help']
		\ ]
	let s:menus.file = {'description': 'File search (buffer, file, file_rec, file_mru'}
	let s:menus.line = {'description': 'Line search (change, grep, line, tag'}
	let s:menus.others = {'description': 'Others (command, command_history, help)'}
	let s:menus.file.command_candidates = [
		\ ['buffer', 'Denite buffer'],
		\ ['file: Files in the current directory', 'Denite file'],
		\ ['file_rec: Files, recursive list under the current directory', 'Denite file_rec'],
		\ ['file_mru: Most recently used files', 'Denite file_mru']
		\ ]
	let s:menus.line.command_candidates = [
		\ ['change', 'Denite change'],
		\ ['grep :grep', 'Denite grep'],
		\ ['line', 'Denite line'],
		\ ['tag', 'Denite tag']
		\ ]
	let s:menus.others.command_candidates = [
		\ ['command', 'Denite command'],
		\ ['command_history', 'Denite command_history'],
		\ ['help', 'Denite help']
		\ ]

	call denite#custom#var('menu', 'menus', s:menus)

	nnoremap [denite] <Nop>
	nmap <Leader>u [denite]
	nnoremap <silent> [denite]b :Denite buffer<CR>
	nnoremap <silent> [denite]c :Denite changes<CR>
	nnoremap <silent> [denite]f :Denite file<CR>
	nnoremap <silent> [denite]g :Denite grep<CR>
	nnoremap <silent> [denite]h :Denite help<CR>
	nnoremap <silent> [denite]h :Denite help<CR>
	nnoremap <silent> [denite]l :Denite line<CR>
	nnoremap <silent> [denite]t :Denite tag<CR>
	nnoremap <silent> [denite]m :Denite file_mru<CR>
	nnoremap <silent> [denite]u :Denite menu<CR>

	nmap <Leader>g [git]
	let g:lmap.g = {'name': 'Git/'}
	call s:leader_bind('nnoremap', 'g', 'b', '', 'Gblame'         , 'Git: Blame'                , 'blame'                , 1)
	call s:leader_bind('nnoremap', 'g', 'B', '', 'Gbrowse'        , 'Git: Status'               , 'status'               , 1)
	call s:leader_bind('nnoremap', 'g', 'c', '', ':Gcommit<Space>', 'Git: Commit'               , 'commit'               , 0)
	call s:leader_bind('nnoremap', 'g', 'C', '', 'Gcheckout'      , 'Git: Checkout'             , 'checkout'             , 1)
	call s:leader_bind('nnoremap', 'g', 'D', '', 'Gdiff HEAD'     , 'Git: Diff HEAD'            , 'diff HEAD'            , 1)
	call s:leader_bind('nnoremap', 'g', 'd', '', 'Gdiff'          , 'Git: Diff'                 , 'diff'                 , 1)
	call s:leader_bind('nnoremap', 'g', 'm', '', ':Gmove<Space>'  , 'Git: Move'                 , 'move'                 , 0)
	call s:leader_bind('nnoremap', 'g', 'p', '', 'Gpull'          , 'Git: Pull'                 , 'pull'                 , 1)
	call s:leader_bind('nnoremap', 'g', 'P', '', 'Gpush'          , 'Git: Push'                 , 'push'                 , 1)
	call s:leader_bind('nnoremap', 'g', 'r', '', 'Gread'          , 'Git: Checkout current file', 'checkout-current-file', 1)
	call s:leader_bind('nnoremap', 'g', 's', '', 'Gstatus'        , 'Git: Status'               , 'status'               , 1)

	" reset 50% winheight on window resize
	augroup deniteresize
		autocmd!
		autocmd VimResized,VimEnter * call denite#custom#option('default',
			\'winheight', winheight(0) / 2)
	augroup end

	call denite#custom#option('default', { 'prompt': 'λ' })

	call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git', ''])

	call denite#custom#map('insert', '<Up>'  , '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('insert', '<C-P>' , '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('insert', '<C-N>' , '<denite:move_to_next_line>'    , 'noremap')
	call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>'    , 'noremap')
	call denite#custom#map('insert', '<C-G>' , '<denite:assign_next_txt>'      , 'noremap')
	call denite#custom#map('insert', '<C-T>' , '<denite:assign_previous_line>' , 'noremap')
	call denite#custom#map('normal', '/'     , '<denite:enter_mode:insert>'    , 'noremap')
	call denite#custom#map('normal', '<Esc>' , '<denite:quit>'                 , 'noremap')
	call denite#custom#map('normal', '<Up>'  , '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('normal', '<Down>', '<denite:move_to_next_line>'    , 'noremap')
	call denite#custom#map('insert', '<Esc>' , '<denite:enter_mode:normal>'    , 'noremap')
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

	let g:OmniSharp_server_path = $VIMHOME.'\utils\omnisharp.http-win-x64\OmniSharp.exe'

	let g:OmniSharp_server_type = 'roslyn'
	let g:OmniSharp_prefer_global_sln = 0
	let g:OmniSharp_timeout = 10
	let g:OmniSharp_selector_ui = 'unite'

	" Contextual code actions (requires CtrlP or unite.vim)
	nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
	" Run code actions with text selected in visual mode to extract method
	vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

	" rename with dialog
	nnoremap <leader>nm :OmniSharpRename<cr>
	nnoremap <F2> :OmniSharpRename<cr>
	" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
	command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

	" Force OmniSharp to reload the solution. Useful when switching branches etc.
	nnoremap <leader>rl :OmniSharpReloadSolution<cr>
	nnoremap <leader>cf :OmniSharpCodeFormat<cr>
	" Load the current .cs file to the nearest project
	nnoremap <leader>tp :OmniSharpAddToProject<cr>

	" Start the omnisharp server for the current solution
	nnoremap <leader>ss :OmniSharpStartServer<cr>
	nnoremap <leader>sp :OmniSharpStopServer<cr>

	" Add syntax highlighting for types and interfaces
	nnoremap <leader>th :OmniSharpHighlightTypes<cr>
endif
" }

" vim: set fdm=indent : normal zi
