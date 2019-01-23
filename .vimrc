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

		if !executable('rg')
			" Add ripgrep binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\rg\'
		endif

		if !executable('vswhere')
			" Add vswhere binary path to PATH
			let $PATH .= ';'.$VIMHOME.'\utils\vswhere\'
		endif

		if executable('vswhere')
			if !executable('msbuild')
				" Add msbuild binary path to PATH
				" Trim newlines off the end
				let s:msbuild_root = system('vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath')[:-2]
				let s:msbuild = s:msbuild_root.'\MSBuild\15.0\Bin\MSBuild.exe'
				if executable(s:msbuild)
					let $PATH .= ';'.s:msbuild_root.'\MSBuild\15.0\Bin'
				endif
			endif

			if !executable('devenv')
				" Finds the devenv binary
				" Trim newlines off the end
				let s:devenv_root = system('vswhere -latest -property installationPath')[:-2]
				let s:devenv = s:devenv_root.'\Common7\IDE\devenv.exe'
				if executable(s:devenv)
					let $PATH .= ';'.s:devenv_root.'\Common7\IDE'
				endif
			endif
		endif
	endif
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
			" ale
			call dein#add('https://github.com/w0rp/ale.git')

			" vim-airline
			call dein#add('https://github.com/vim-airline/vim-airline.git')

			" vim-airline-themes
			call dein#add('https://github.com/vim-airline/vim-airline-themes.git')

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
			call dein#add('https://github.com/tpope/vim-fugitive.git')

			" gitv
			call dein#add('https://github.com/gregsexton/gitv.git')

			" vim-gitgutter
			call dein#add('https://github.com/airblade/vim-gitgutter.git')
		" }

		" Editing {
			" Align
			call dein#add('https://github.com/lboulard/Align.git')

			" vim-sleuth
			call dein#add('https://github.com/tpope/vim-sleuth.git')

			" vim-surround
			call dein#add('https://github.com/tpope/vim-surround.git')

			" vim-repeat
			call dein#add('https://github.com/tpope/vim-repeat.git')

			" vim-unimpaired
			call dein#add('https://github.com/tpope/vim-unimpaired.git')

			" vim-qfreplace
			call dein#add('https://github.com/thinca/vim-qfreplace.git')
		" }

		" Browsing {
			" denite
			call dein#add('https://github.com/Shougo/denite.nvim.git')

			" denite-ale
			call dein#add('https://github.com/iyuuya/denite-ale.git')

			" denite-git
			call dein#add('https://github.com/neoclide/denite-git.git')

			" denite-extra
			call dein#add('https://github.com/neoclide/denite-extra.git')

			" fruzzy
			call dein#add('https://github.com/raghur/fruzzy.git')

			" neoyank.vim
			call dein#add('https://github.com/Shougo/neoyank.vim.git')

			" vim-leader-guide
			call dein#add('https://github.com/hecal3/vim-leader-guide.git')

			" vaffle.vim
			call dein#add('https://github.com/cocopon/vaffle.vim.git')
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

			" omnisharp-vim
			call dein#add('https://github.com/dilberry/omnisharp-vim.git', { 'merged': 0, 'on_ft': ['cs', 'csproj', 'sln'] })

			" deoplete-jedi
			" Requires jedi package in python install
			call dein#add('https://github.com/zchee/deoplete-jedi.git', { 'depends': ['deoplete.nvim'], 'on_ft': ['python', 'python3', 'djangohtml']})

			" neco-vim
			call dein#add('https://github.com/Shougo/neco-vim.git', { 'depends': ['deoplete.nvim'], 'on_source': ['deoplete.nvim'], 'on_ft': 'vim'})

			" neco-syntax
			call dein#add('https://github.com/Shougo/neco-syntax.git', { 'depends': ['deoplete.nvim'], 'on_source': ['deoplete.nvim'], 'on_ft': 'vim'})

			" deoplete-ternjs
			call dein#add('https://github.com/carlitux/deoplete-ternjs.git', { 'depends': ['deoplete.nvim'], 'on_ft': ['javascript', 'javascript.jsx', 'vue']})

			" jspc.vim
			call dein#add('https://github.com/othree/jspc.vim.git', { 'on_ft': ['javascript', 'javascript.jsx', 'vue']})
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

			" vim-polyglot
			call dein#add('https://github.com/sheerun/vim-polyglot.git')

			" vim-jsbeautify
			call dein#add('https://github.com/maksimr/vim-jsbeautify.git', { 'on_ft': ['javascript', 'json', 'jsx', 'html', 'css', 'xml']})
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

" Leader mapping functions {
	let s:leader_bind_callbacks = []
	let s:leader_binds = []

	function! s:leader_bind(map, keys, value, long_name, short_name, is_cmd) abort
		let l:args = {}
		let l:args.map        = a:map
		let l:args.keys       = a:keys
		let l:args.value      = a:value
		let l:args.long_name  = a:long_name
		let l:args.short_name = a:short_name
		let l:args.is_cmd     = a:is_cmd
		call add(s:leader_binds, l:args)
	endfunction

	function! s:leader_bind_process(map, keys, value, long_name, short_name, is_cmd) abort
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

	function! s:leader_binds_process() abort
		for args in s:leader_binds
			call s:leader_bind_process(args.map, args.keys, args.value, args.long_name, args.short_name, args.is_cmd)
		endfor

		let s:leader_binds = []
	endfunction
" }

" Cleanup {
	function! s:strip_save()
		" Preparation: save last search, and cursor position.
		let state = {}
		let state._s=@/
		let state.l = line(".")
		let state.c = col(".")

		return state
	endfunction

	function! s:strip_restore(state)
		" clean up: restore previous search history, and cursor position
		let @/=a:state._s
		call cursor(a:state.l, a:state.c)
	endfunction

	function! s:strip_trailing_whitespace()
		let state = s:strip_save()
		%s/\s\+$//e
		call s:strip_restore(state)
	endfunction
	command! FixEndingsWhiteSpace call s:strip_trailing_whitespace()

	function! s:strip_trailing_windows()
		let state = s:strip_save()
		%s/<C-V><cr>//ge
		call s:strip_restore(state)
	endfunction
	command! FixEndingsWindows call s:strip_trailing_windows()
" }

" Key Remapping {
	" Set Leader to Space
	let mapleader = ' '
	let maplocalleader = ' '

	" Remove the Windows ^M - when the encodings gets messed up
	call s:leader_bind('nnoremap', ['b', 'm', 'E'], 'FixEndingsWindows', 'Fix Line Endings (Windows)', 'fix_line_endings_windows', v:true)

	" Remove Trailing whitespace
	call s:leader_bind('nnoremap', ['b', 'm', 'e'], 'FixEndingsWhiteSpace', 'Fix Line Endings (White Space)', 'fix_line_endings_white_space', v:true)

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
	set ruler                      " Show the cursor position all the time, not applicable in airline
	set showcmd                    " Display incomplete commands
	set nowrap                     " Set lines to no wrap
	set viminfo+=!                 " Set viminfo to store and restore global variables
	set history=700                " Sets how many lines of history VIM has to remember
	set modeline                   " Use modelines
	set number                     " Display line numbers
	set autochdir                  " Auto change working directory to the current file
	set hidden                     " Allow changing buffer without saving
	set autoread                   " Auto-reload files, if there's no conflict
	set shortmess+=IA              " No intro message, no swap-file message
	set updatetime=500             " This setting controls how long to wait (in ms) before fetching type / symbol information.
	set cmdheight=2                " Remove 'Press Enter to continue' message when type information is longer than one line.
	set nrformats-=octal           " Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it confusing.
	set nofoldenable               " Disable folding
	set timeoutlen=200             " Navigation character timeout
	set ttimeoutlen=100            " Other character timeout
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
			function! s:gvim_resize()
				" simalt appears to happen after VimEnter
				" Variables set, during startup, from winheight() will be
				" wrong
				set lines=999
				set columns=9999
				" Fake Alt+Space+x
				simalt ~x
			endfunction
			set guioptions-=t
			autocmd GUIEnter * call s:gvim_resize()  " Maximise on GUI entry
			set guifont=PragmataPro:h10:cANSI:qDRAFT " Select GUI font
		endif
		autocmd GUIEnter * set vb t_vb=              " Disable audible bell
	endif
" }

" vim-airline options {
if dein#tap('vim-airline')
	set laststatus=2 " Show 2 lines of status
	set noshowmode   " Don't show mode on statusline, let airline do it instead
	let g:airline_detect_modified           = 1
	let g:airline#extensions#tagbar#enabled = 1
	let g:airline#extensions#ale#enabled    = 1
	let g:airline#extensions#branch#enabled = 1
	let g:airline#extensions#branch#format  = 1

	function! CustomBranchName(name) abort
		let b:airline_branch_ahead = v:false
		try
			let l:git_rev = fugitive#repo().git_chomp('rev-list', '--left-right', '--count', 'origin/'.a:name.'...'.a:name)
			" In the form of Behind Ahead
			let l:git_revs = split(l:git_rev, '\D')
			let l:rev_stats = ''

			" Check behind and ahead
			if l:git_revs[0] != '0' && l:git_revs[1] != '0'
				let l:rev_stats = 'Behind ' . l:git_revs[0] . ' , ' . 'Ahead ' . l:git_revs[1]
				let b:airline_branch_ahead = v:true
			" Check behind
			elseif l:git_revs[0] != '0'
				let l:rev_stats = 'Behind ' . l:git_revs[0]
			" Check ahead
			elseif l:git_revs[1] != '0'
				let l:rev_stats = 'Ahead ' . l:git_revs[1]
				let b:airline_branch_ahead = v:true
			endif

			if l:rev_stats == ''
				return '[' . a:name . ']'
			else
				return '[' . a:name . ': '. l:rev_stats . ']'
			endif
		catch
			return '[' . a:name . ']'
		endtry
	endfunction

	function! BranchColour() abort
		if exists('b:custom_branch') && !empty(b:custom_branch)
			return b:custom_branch
		else
			let l:head = airline#extensions#branch#head()
			let b:custom_branch = CustomBranchName(l:head)
		endif

		if b:airline_branch_ahead
			call airline#parts#define_accent('branch', 'stale')
		else
			call airline#parts#define_accent('branch', 'none')
		endif

		let g:airline_section_b = airline#section#create(['branch'])

		return b:custom_branch
	endfunction

	function! AirlineThemePatch(palette)
		" [ guifg, guibg, ctermfg, ctermbg, opts ].
		" See "help attr-list" for valid values for the "opt" value.
		" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
		let a:palette.accents.stale = [ '#ff0000', '' , 'red', '', '' ]
	endfunction

	exec 'augroup airline_init-'. bufnr("%")
		autocmd!
		autocmd User AirlineAfterInit call s:airline_init()
		autocmd ShellCmdPost,CmdwinLeave * unlet! b:custom_branch
		autocmd BufLeave <buffer> silent! unlet! b:custom_branch
	augroup END

	function! s:airline_init()
		let b:custom_branch = ''
		let b:airline_branch_ahead = v:false
		call airline#parts#define_empty(['branch'])
		call airline#parts#define_function('branch', 'BranchColour')
		let g:airline_section_b = airline#section#create(['branch'])
		" TODO: Use the following to check when outside a Git repo
		" TODO: call airline#parts#define_condition('foo', 'getcwd() =~ work_dir')

		let g:airline_theme_patch_func = 'AirlineThemePatch'
	endfunction
endif
" }

" vim-airline-themes options {
if dein#tap('vim-airline-themes')
	let g:airline_theme = 'wombat'
endif
" }

" Filetype plugins {
	" ale settings {
	if dein#tap('ale')
		call s:leader_bind('nnoremap', ['b', 'l'], 'ALEToggle', 'Linting Toggle', 'linting_toggle', v:true)
		nmap <silent> [s <Plug>(ale_previous)
		nmap <silent> ]s <Plug>(ale_next)
	endif
	" }

	" vim-polyglot {
	if dein#tap('vim-polyglot')
		let g:polyglot_disabled = ['graphql']
	endif
	" }

	" Python {
	" }

	" C# {
		" Omnisharp options {
		if dein#tap('omnisharp-vim')
			" FIXME: Running GDiff causes Omnisharp to ask for solution files
			function! s:omnisharp_menu_check() abort
				if dein#tap('denite.nvim')
					" FIXME: This denite menu doesn't work
					if !exists('s:menus.o')
						let s:menus.o = {'description': 'Omnisharp'}
						let s:menus.o.command_candidates = []
						let s:menus.o.f = {'description': 'Find'}
						let s:menus.o.f.command_candidates = []
						let s:menus.o.g = {'description': 'Goto'}
						let s:menus.o.g.command_candidates = []
						let s:menus.o.m = {'description': 'Modify'}
						let s:menus.o.m.command_candidates = []
						let s:menus.o.l = {'description': 'Lookup'}
						let s:menus.o.l.command_candidates = []
						let s:menus.o.s = {'description': 'Solution'}
						let s:menus.o.s.command_candidates = []
					endif
				endif

				if dein#tap('vim-leader-guide')
					if !exists('g:lmap.o')
						let g:lmap.o = {'name': 'Omnisharp/'}
						let g:lmap.o.f = {'name': 'Find/'}
						let g:lmap.o.g = {'name': 'Goto/'}
						let g:lmap.o.m = {'name': 'Modify/'}
						let g:lmap.o.l = {'name': 'Lookup/'}
						let g:lmap.o.s = {'name': 'Solution/'}
					endif
				endif
			endfunction

			function! s:msbuild_options() abort
				" Error format for make
				setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

				" Msbuild setting for make
				let &l:makeprg='msbuild /nologo /v:q /property:GenerateFullPaths=true /clp:ErrorsOnly '.shellescape(OmniSharp#FindSolution())
			endfunction

			function! s:devenv_call() abort
				" Call Visual Studio with current solution
				let l:devenv_cmd = '!start /b cmd /c '.'"'.shellescape(s:devenv).' '.shellescape(OmniSharp#FindSolution()).'"'
				silent execute l:devenv_cmd
			endfunction

			function! s:omnisharp_options() abort
				"Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
				setlocal omnifunc=OmniSharp#Complete

				call s:msbuild_options()
				command! -buffer -nargs=* MSBuild call s:msbuild_options() | make <args>
				command! -buffer -nargs=* DevEnv call s:devenv_call()
				call s:omnisharp_menu_check()

				"The following commands are contextual, based on the current cursor position.
				call s:leader_bind('nnoremap <buffer>', ['o', 'g', 'd'], 'OmniSharpGotoDefinition'     , 'Goto Definition'     , 'goto_definition'     , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'f', 'i'], 'OmniSharpFindImplementations', 'Find Implementations', 'find_implementations', v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'f', 't'], 'OmniSharpFindType'           , 'Find Type'           , 'find_type'           , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'f', 's'], 'OmniSharpFindSymbol'         , 'Find Symbol'         , 'find_symbol'         , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'f', 'u'], 'OmniSharpFindUsages'         , 'Find Usages'         , 'find_usages'         , v:true)
				"finds members in the current buffer
				call s:leader_bind('nnoremap <buffer>', ['o', 'f', 'm'], 'OmniSharpFindMembers'        , 'Find Members'        , 'find_members'        , v:true)

				" cursor can be anywhere on the line containing an issue
				call s:leader_bind('nnoremap <buffer>', ['o', 'm', 'i'], 'OmniSharpFixIssue'           , 'Fix Issue'           , 'fix_issue'           , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'm', 'u'], 'OmniSharpFixUsings'          , 'Fix Usings'          , 'fix_usings'          , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'm', 'f'], 'OmniSharpCodeFormat'         , 'Format Code'         , 'format_code'         , v:true)

				" rename with dialog
				call s:leader_bind('nnoremap <buffer>', ['o', 'm', 'r'], 'OmniSharpRename'             , 'Rename'              , 'rename'              , v:true)
				nnoremap <buffer><F2> :OmniSharpRename<cr>
				" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
				command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

				call s:leader_bind('nnoremap <buffer>', ['o', 'l', 't'], 'OmniSharpTypeLookup'         , 'Lookup Type'         , 'lookup_type'         , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 'l', 'd'], 'OmniSharpDocumentation'      , 'Lookup Documentation', 'lookup_documentation', v:true)
				" Contextual code actions (requires CtrlP or unite.vim)
				call s:leader_bind('nnoremap <buffer>', ['o', 'l', 'a'], 'OmniSharpGetCodeActions'     , 'Get Code Actions'    , 'get_code_actions'    , v:true)
				call s:leader_bind('vnoremap <buffer>', ['o', 'l', 'a'], 'call OmniSharp#GetCodeActions(''visual'')', 'Get Code Actions', 'get_code_actions', v:true)

				" Builds can also run asynchronously with vim-dispatch installed
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 'b'], 'MSBuild'                     , 'Build'               , 'build'               , v:true)
				" Open the current solution in Visual Studio
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 'v'], 'DevEnv'                      , 'Open Visual Studio'  , 'open_visual_studio'  , v:true)
				" Force OmniSharp to reload the solution. Useful when switching branches etc.
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 'r'], 'OmniSharpRestartServer'      , 'Restart Server'      , 'restart_server'      , v:true)

				" Start the omnisharp server for the current solution
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 's'], 'OmniSharpStartServer'        , 'Start Server'        , 'start_server'        , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 'p'], 'OmniSharpStopServer'         , 'Stop Server'         , 'stop_server'         , v:true)
				call s:leader_bind('nnoremap <buffer>', ['o', 's', 'h'], 'OmniSharpHighlightTypes'     , 'Highlight Types'     , 'highlight_types'     , v:true)

				call s:leader_binds_process()
			endfunction

			function! s:omnisharp_count_code_actions() abort
				if OmniSharp#IsServerRunning()
					if OmniSharp#CountCodeActions({-> execute('sign unplace 99')})
						let l = getpos('.')[1]
						let f = expand('%:p')
						execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
					endif
				endif
			endfunction

			augroup omnisharp_commands
				autocmd!

				"Set omnisharp key mappings
				autocmd FileType cs call s:omnisharp_options()
				autocmd FileType csproj call s:omnisharp_options()
				autocmd FileType sln call s:omnisharp_options()

				"show type information automatically when the cursor stops moving
				autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
				autocmd CursorHold *.cs call s:omnisharp_count_code_actions()
			augroup END

			if !executable('OmniSharp')
				let g:OmniSharp_server_path = $VIMHOME.'\utils\omnisharp.http-win-x64\OmniSharp.exe'
			endif

			sign define OmniSharpCodeActions text=💡
			let g:OmniSharp_server_type = 'roslyn'
			let g:OmniSharp_prefer_global_sln = 0
			let g:OmniSharp_timeout = 10
			let g:OmniSharp_selector_ui = ''

		endif
		" }
	" }

	" TypeScript {
		" Tagbar settings {
		if dein#tap('tagbar')
			if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
				let g:tagbar_type_typescript = {
					\ 'ctagstype' : 'typescript',
					\ 'deffile' : $VIMHOME.'\utils\ctags\ctags.cfg',
					\ 'kinds'     : [
						\ 'c:classes',
						\ 'c:modules',
						\ 'n:modules',
						\ 'f:functions',
						\ 'v:variables',
						\ 'v:varlambdas',
						\ 'm:members',
						\ 'i:interfaces',
						\ 't:types',
						\ 'e:enums',
						\ 'I:imports',
					\ ]
				\ }
			endif
		endif
		" }
	" }

	" Visual Basic {
		" Tagbar settings {
		if dein#tap('tagbar')
			if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
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
		endif
		" }
	" }

	augroup OmniFuncs
		autocmd!
	augroup END

	augroup AStyler
		autocmd!
	augroup END

	function! g:AstylerCall(astyle_mode) abort
		call system('AStyle --mode=' . a:astyle_mode . ' --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')
	endfunction

	function! s:formatter_menu_check() abort
		if dein#tap('denite.nvim')
			if !exists('s:menus.m')
				let s:menus.m = {'description': 'Modify'}
				let s:menus.m.command_candidates = []
			endif
		endif

		if dein#tap('vim-leader-guide')
			if !exists('g:lmap.m')
				let g:lmap.m = {'name': 'Modify/'}
			endif
		endif
	endfunction

	function! s:formatter_mappings(format_cmd) abort
		call s:formatter_menu_check()

		call s:leader_bind('nnoremap <buffer>', ['m' , 'a'], a:format_cmd, 'Auto format', 'auto_format', v:true)

		call s:leader_binds_process()
	endfunction

	" C options {
		autocmd AStyler FileType c call s:formatter_mappings('call g:AstylerCall(' . string('c') . ')')
	" }

	" C++ options {
		autocmd AStyler FileType cpp call s:formatter_mappings('call g:AstylerCall(' . string('c') . ')')
	" }

	" java options {
		autocmd AStyler FileType java call s:formatter_mappings('call g:AstylerCall(' . string('java') . ')')
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
		autocmd JSBeautify FileType javascript call s:formatter_mappings('call JsBeautify()')
		if dein#tap('jspc.vim')
			autocmd OmniFuncs FileType javascript setlocal omnifunc=jspc#omni
		endif
	" }

	" json options {
		autocmd JSBeautify FileType json call s:formatter_mappings('call JsBeautify()')
	" }

	" jsx options {
		autocmd JSBeautify FileType jsx call s:formatter_mappings('call JsxBeautify()')
	" }

	" html options {
		autocmd JSBeautify FileType html call s:formatter_mappings('call HtmlBeautify()')
		if dein#tap('vim-polyglot')
			autocmd OmniFuncs FileType html setlocal omnifunc=htmlcomplete#CompleteTags
		endif
	" }

	" xml options {
		autocmd JSBeautify FileType xml call s:formatter_mappings('call HtmlBeautify()')
	" }

	" css options {
		autocmd JSBeautify FileType css call s:formatter_mappings('call CSSBeautify()')
		autocmd OmniFuncs FileType css setlocal omnifunc=csscomplete#CompleteCSS
	" }

	if !executable('node') || !dein#tap('vim-jsbeautify')
		augroup JSBeautify
			autocmd!
		augroup END
	endif
" }

" Align options {
if dein#tap('Align')
	" Prevent mappings
	let g:loaded_AlignMaps = 'v43'
	let g:loaded_AlignMapsPlugin = 'v43'
	let g:loaded_cecutil = 'v17'
endif
" }

" indent-guides options {
if dein#tap('vim-indent-guides')
	let g:indent_guides_enable_on_vim_startup = 1
	let g:indent_guides_default_mapping = 0 " Disable leader mapping

	" indent-guides toggle
	call s:leader_bind('nnoremap', ['b', 'g'], 'IndentGuidesToggle', 'Indent Guides Toggle', 'indent_guides_toggle', v:true)
endif
" }

" Tag plugins {
	" Tagbar options {
	if dein#tap('tagbar')
		" Tagbar Toggle
		call s:leader_bind('nnoremap', ['b', 't'], 'TagbarToggle', 'Tagbar Toggle', 'tagbar_toggle', v:true)
		let g:tagbar_ctags_bin = $VIMHOME.'\utils\ctags\ctags.exe'
		autocmd VimEnter * nested :call tagbar#autoopen(1)
	endif
	" }

	" Gutentags options {
	if dein#tap('vim-gutentags')
		if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
			" Include extra defintions for VB6 and TypeScript
			" etags format gives better paths on Windows
			let g:gutentags_ctags_extra_args = ['−−options='.shellescape($VIMHOME.'\utils\ctags\ctags.cfg')]
		endif
		let g:gutentags_cache_dir = $VIMHOME.'\utils\ctags\cache'
		" Let Gutentags separate tags based on Visual Studio and VB6 solutions
		let g:gutentags_project_root = ['.vs', 'node_modules', '*.sln', '*.vbp']
		let g:gutentags_ctags_exclude = ['*.min.js', '*.min.css', '*.assets.json', '*.swagger.json', 'build', 'vendor', '.git', 'node_modules']
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
	call s:leader_bind('nnoremap', ['b', 'r'], 'RainbowToggle', 'Rainbow Toggle', 'rainbow_toggle', v:true)
endif
" }

" vaffle.vim options {
if dein#tap('vaffle.vim')
	" Open like vim-vinegar
	nnoremap <silent> - :Vaffle<CR>

	" Disable the mapping in Fugitive
	if dein#tap('vim-fugitive')
		augroup commit_enter
			autocmd!
			autocmd BufEnter COMMIT_EDITMSG nmap <buffer> - <Nop>
		augroup END
	endif

	let g:vaffle_show_hidden_files = 1 " Show hidden files
	function! s:vaffle_options() abort
		" Go up directory like vim-vinegar
		nmap <buffer> -     <Plug>(vaffle-open-parent)
		" Actually quit, unlike vim-vinegar
		nmap <buffer> <Esc> <Plug>(vaffle-quit)
		" Show cursorline in vaffle
		setlocal cursorline
	endfunction

	augroup vimrc_vaffle
		autocmd!
		autocmd FileType vaffle call s:vaffle_options()
	augroup END
endif
" }

" vim-fugitive options {
if dein#tap('vim-fugitive')
	" Enter the commit message as Insert mode
	augroup commit_enter
		autocmd BufEnter COMMIT_EDITMSG startinsert
	augroup END

	call s:leader_bind('nnoremap <silent>', ['g', 'b'], 'Gblame'       , 'Blame'                , 'blame'                , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'B'], 'Gbrowse'      , 'Browse'               , 'browse'               , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'c'], 'Gcommit'      , 'Commit'               , 'commit'               , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'D'], 'Gdiff HEAD'   , 'Diff HEAD'            , 'diff HEAD'            , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'd'], 'Gdiff'        , 'Diff'                 , 'diff'                 , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'm'], ':Gmove<Space>', 'Move'                 , 'move'                 , v:false)
	call s:leader_bind('nnoremap <silent>', ['g', 'p'], 'Gpull'        , 'Pull'                 , 'pull'                 , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'P'], 'Gpush'        , 'Push'                 , 'push'                 , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'r'], 'Gread'        , 'Checkout current file', 'checkout-current-file', v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 's'], 'Gstatus'      , 'Status'               , 'status'               , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'w'], 'Gwrite'       , 'Write'                , 'write'                , v:true)
endif
" }

" gitv options {
if dein#tap('gitv')
	call s:leader_bind('nnoremap <silent>', ['g', 'v'], 'Gitv'         , 'Version (Commits)'    , 'version_commits'      , v:true)
	call s:leader_bind('nnoremap <silent>', ['g', 'V'], 'Gitv!'        , 'Version (Files)'      , 'version_files'        , v:true)
endif
" }

" vim-gitgutter options {
if dein#tap('vim-gitgutter')
	" Disable leader mappings
	let g:gitgutter_map_keys = 0
	nmap [c <Plug>GitGutterPrevHunk
	nmap ]c <Plug>GitGutterNextHunk
	let g:gitgutter_async = 1
	let g:gitgutter_sign_added = '✚'
	let g:gitgutter_sign_modified = '✹'
	let g:gitgutter_sign_removed = '✖'
	let g:gitgutter_sign_removed_first_line = '➜'
	let g:gitgutter_sign_modified_removed = '✗'
endif
" }

" deoplete options {
if dein#tap('deoplete.nvim')
	" General options
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#file#enable_buffer_path = 1
	let g:deoplete#auto_completion_start_length = 2
	let g:deoplete#manual_completion_start_length = 1
	let g:deoplete#sources#syntax#min_keyword_length = 3
	let g:deoplete#auto_complete_delay = 0

	let g:deoplete#enable_smart_case = 1
	let g:deoplete#enable_ignore_case = 1
	let g:deoplete#enable_camel_case = 1

	if !exists('g:deoplete#omni#input_patterns')
		let g:deoplete#omni#input_patterns = {}
	endif

	if !exists('g:deoplete#sources')
		let g:deoplete#sources = {}
	endif

	if !exists('g:deoplete#omni#functions')
		let g:deoplete#omni#functions = {}
	endif

	if !exists('g:deoplete#ignore_sources')
		let g:deoplete#ignore_sources = {}
	endif

	let g:deoplete#sources._ = ['omni', 'buffer', 'file']
	let g:deoplete#ignore_sources._ = ['around']
	call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
	call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])
	call deoplete#custom#source('buffer', 'rank', 100)

	" C# options
	let g:deoplete#sources.cs = ['omni']
	let g:deoplete#omni#input_patterns.cs = ['.*[^=\);]']

	" Javascript options
	let g:deoplete#sources.javascript = ['tern', 'omni']

	" Python options
	let g:deoplete#sources.python = ['jedi']

	" Vim options
	let g:deoplete#sources.vim = ['vim']

	" Cycle on Tab
	inoremap <silent><expr><tab> pumvisible()? "\<c-n>" : "\<tab>"

	" Cycle backwards on Tab
	inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
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

		" denite-git options {
		if dein#tap('denite.nvim') && dein#tap('denite-git')
			let g:lmap.g.g = {'name': 'Denite Git/'}
		endif
		" }
	endif

	let g:lmap.b = {'name': 'Buffer/'}
	let g:lmap.b.m = {'name': 'Modify/'}
	let g:lmap.f = {'name': 'Files/'}
	let g:lmap.t = {'name': 'Tags/'}

	if dein#tap('denite.nvim')
		let g:lmap.d = {'name': 'Denite/'}
	endif

	function! s:add_leader_guide_item(keys, name, cmd) abort
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

	function! s:add_denite_item(keys, name, cmd) abort
		if exists('s:menus.' . join(a:keys[:-2], '.'))
			execute 'call add(s:menus.' . join(a:keys[:-2], '.') . '.command_candidates,'. '[' . shellescape(a:name) . ',' . shellescape(a:cmd) . '])'
		else
			execute 'let s:menus.' . join(a:keys[:-1], '.') . ' = '. '{"command_candidates": [' . shellescape(a:name) . ',' . shellescape(a:cmd) . ']}'
		endif
	endfunction

	call add(s:leader_bind_callbacks, function('s:add_denite_item'))

	" reset 50% winheight on window resize
	augroup deniteresize
		autocmd!
		autocmd VimResized,VimEnter * call denite#custom#option('default',
			\'winheight', winheight(0) / 2)
	augroup end

	call denite#custom#option('default', 'prompt', 'λ')
	call denite#custom#option('default', 'auto_resize', v:true)
	call denite#custom#option('default', 'smartcase', v:true)
	call denite#custom#option('default', 'highlight_mode_insert', 'Pmenu')
	call denite#custom#option('default', 'highlight_mode_normal', 'Cursorline')

	call denite#custom#source('buffer', 'sorters', ['sorter_mru'])

	" Matchers
	call denite#custom#source('buffer'      , 'matchers', ['matcher_regexp'                 ])
	call denite#custom#source('file_mru'    , 'matchers', ['matcher_regexp'                 ])
	call denite#custom#source('file'        , 'matchers', ['matcher/fruzzy', 'matcher_fuzzy'])
	call denite#custom#source('file_rec_git', 'matchers', ['matcher/fruzzy'                 ])

	if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
		" TODO: The outline source can't handle etags format with options files
		call denite#custom#var('outline', 'options', ['−−options='.$VIMHOME.'\utils\ctags\ctags.cfg'])
	endif

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
	call denite#custom#map('normal', 'yy'    , '<denite:do_action:yank>'                , 'noremap')
	call denite#custom#map('normal', '<C-a>' , '<denite:multiple_mappings:denite:toggle_select_all>', 'noremap')
	call denite#custom#map('normal', 'q'     , '<denite:do_action:quickfix>'            , 'noremap')

	let s:menus.b = {'description': 'Buffer'}
	let s:menus.b.command_candidates = []
	let s:menus.b.m = {'description': 'Modify'}
	let s:menus.b.m.command_candidates = []
	if dein#tap('denite-ale')
		call s:leader_bind('nnoremap <silent>', ['b', 's'], 'Denite ale', 'Syntax Errors', 'syntax_errors', v:true)
	endif

	let s:menus.d = {'description': 'Denite'}
	let s:menus.d.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['d', 'b'], 'Denite buffer'     , 'Buffers', 'buffers', v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'c'], 'Denite colorscheme', 'Colours', 'colours', v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'd'], 'Denite menu'       , 'Menu'   , 'menu'   , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'g'], 'Denite grep'       , 'Grep'   , 'grep'   , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'h'], 'Denite help'       , 'Help'   , 'help'   , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'l'], 'Denite line'       , 'Lines'  , 'lines'  , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'm'], 'Denite mark'       , 'Marks'  , 'marks'  , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'r'], 'Denite -resume'    , 'Resume' , 'resume' , v:true)
	call s:leader_bind('nnoremap <silent>', ['d', 'y'], 'Denite neoyank'    , 'Yanks'  , 'yanks'  , v:true)

	let s:menus.f = {'description': 'Files'}
	let s:menus.f.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['f', 'f'], 'Denite file'                  , 'Files'                , 'file'        , v:true)
	call s:leader_bind('nnoremap <silent>', ['f', 'm'], 'Denite file_mru'              , 'Files (Most Used)'    , 'file_mru'    , v:true)
	call s:leader_bind('nnoremap <silent>', ['f', 'r'], 'Denite file_rec'              , 'Files (Recursive)'    , 'file_rec'    , v:true)
	call s:leader_bind('nnoremap <silent>', ['f', 'g'], 'DeniteProjectDir file_rec_git', 'Files (Git Recursive)', 'file_rec_git', v:true)

	let s:menus.t = {'description': 'Tags'}
	let s:menus.t.command_candidates = []
	call s:leader_bind('nnoremap <silent>', ['t', 'b'], 'Denite outline', 'Tags (Buffer)', 'buffer_tag', v:true)
	call s:leader_bind('nnoremap <silent>', ['t', 'g'], 'Denite tag'    , 'Tags (Global)', 'global_tag', v:true)

	" Cycle through Denite buffer like the Quickfix buffer using Unimpaired
	nnoremap <silent> [d :<C-u>Denite -resume -immediately -force-quit -cursor-pos=-<C-r>=v:count1<CR><CR>
	nnoremap <silent> ]d :<C-u>Denite -resume -immediately -force-quit -cursor-pos=+<C-r>=v:count1<CR><CR>

	if dein#tap('vim-fugitive')
		let s:menus.g = {'description': 'Git'}
		let s:menus.g.command_candidates = []

		" denite-git options {
		if dein#tap('denite-git')
			" FIXME: This denite menu doesn't work
			let s:menus.g.g = {'description': 'Denite Git'}
			let s:menus.g.g.command_candidates = []
			call s:leader_bind('nnoremap <silent>', ['g', 'g', 'b'], 'Denite gitbranch', 'Denite Git Branch', 'denite_gitbranch', v:true)
			call s:leader_bind('nnoremap <silent>', ['g', 'g', 's'], 'Denite gitstatus', 'Denite Git Status', 'denite_gitstatus', v:true)
		endif
		" }
	endif

	if executable('rg')
		call denite#custom#var('file_rec', 'command', ['rg', '--files', '--no-heading', '--glob', '!.git', ''])
		call denite#custom#var('grep', 'command', ['rg', '--smart-case'])
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

" Process leader bindings {
	call s:leader_binds_process()
" }

" vim: set fdm=indent : normal zi
