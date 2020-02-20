if &compatible
	set nocompatible
endif

" Platform detection {
	let g:is_windows = has('win16') || has('win32') || has('win64')
	let g:is_cygwin  = has('win32unix')
	let g:is_mac     = !g:is_windows && !g:is_cygwin
						\ && (has('mac') || has('macunix') || has('gui_macvim') ||
						\    (!executable('xdg-open') && system('uname') =~? '^darwin'))
" }

" Windows defaults {
	if g:is_windows
		source $VIMRUNTIME/mswin.vim
	endif
" }

" Path correction {
	" This is to make the Vim installation portable
	" Set the VIMHOME path variable to where this vimrc is sourced
	let $VIMHOME = expand('<sfile>:p:h')

	if g:is_windows
		let g:python_host_prog = 'C:/Python27/python.exe'
		let g:python3_host_prog = 'C:/Python37/python.exe'

		if !executable('xmllint')
			" Add xmllint binary path to PATH
			let $PATH .= ';'.expand('~/utils/xmllint/bin/')
		endif

		if !executable('AStyle')
			" Add AStyle binary path to PATH
			let $PATH .= ';'.expand('~/utils/AStyle/bin/')
		endif

		if !executable('ctags')
			" Add ctags binary path to PATH
			let $PATH .= ';'.expand('~/utils/ctags/')
		endif

		if !executable('rg')
			" Add ripgrep binary path to PATH
			let $PATH .= ';'.expand('~/utils/rg/')
		endif

		if !executable('vswhere')
			" Add vswhere binary path to PATH
			let $PATH .= ';'.expand('~/utils/vswhere/')
		endif

		if executable('vswhere')
			if !executable('msbuild')
				" Add msbuild binary path to PATH
				" Trim newlines off the end
				let s:msbuild_root = system('vswhere -latest -products * -requires Microsoft.Component.MSBuild -property installationPath')[:-2]

				let s:msbuild_2017 = s:msbuild_root.'/MSBuild/15.0/Bin/MSBuild.exe'
				if executable(s:msbuild_2017)
					let $PATH .= ';'.s:msbuild_root.'/MSBuild/15.0/Bin'
				endif

				let s:msbuild_2019 = s:msbuild_root.'/MSBuild/Current/Bin/MSBuild.exe'
				if executable(s:msbuild_2019)
					let $PATH .= ';'.s:msbuild_root.'/MSBuild/Current/Bin'
				endif
			endif

			if !executable('devenv')
				" Finds the devenv binary
				" Trim newlines off the end
				let s:devenv_root = system('vswhere -latest -property installationPath')[:-2]
				let g:devenv = s:devenv_root.'/Common7/IDE/devenv.exe'
				if executable(g:devenv)
					let $PATH .= ';'.s:devenv_root.'/Common7/IDE'
				endif
			endif
		endif
	endif
" }

" Leader mapping functions {
	let g:leader_bind_callbacks = []
	let g:leader_binds = []
	let g:leader_binds_processed = {}
	let g:leader_binds_processed.base = []

	function! LeaderBind(map, keys, value, long_name, short_name, is_cmd) abort
		let l:args = {}
		let l:args.map        = a:map
		let l:args.keys       = a:keys
		let l:args.value      = a:value
		let l:args.long_name  = a:long_name
		let l:args.short_name = a:short_name
		let l:args.is_cmd     = a:is_cmd
		call add(g:leader_binds, l:args)
		call s:leader_bind_process(l:args.map, l:args.keys, l:args.value, l:args.long_name, l:args.short_name, l:args.is_cmd)
	endfunction

	function! s:leader_bind_process(map, keys, value, long_name, short_name, is_cmd) abort
		let l:key_combo = join(a:keys, '')
		let l:value = ''
		let l:long_name = ''
		let l:cmd_value = ''
		let l:short_name = ''
		if index(g:leader_binds_processed.base, l:key_combo) == -1
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

			execute a:map . ' <leader>' . l:key_combo . ' ' . l:value

			call add(g:leader_binds_processed.base, l:key_combo)
		endif

		for Callback in g:leader_bind_callbacks
			let l:callback_name = string(Callback)
			if !has_key(g:leader_binds_processed, l:callback_name)
				g:leader_binds_processed[l:callback_name] = []
			endif
		endfor

		for Callback in g:leader_bind_callbacks
			let l:callback_name = string(Callback)
			if index(g:leader_binds_processed[l:callback_name], l:key_combo) == -1
				call add(g:leader_binds_processed[l:callback_name], l:key_combo)
				call Callback(a:keys, l:long_name, l:cmd_value)
			endif
		endfor
	endfunction

	function! LeaderBindsAddCallback(Callback) abort
		if index(g:leader_bind_callbacks, a:Callback) == -1
			call add(g:leader_bind_callbacks, a:Callback)
		endif
		let l:callback_name = string(a:Callback)
		if !has_key(g:leader_binds_processed, l:callback_name)
			let g:leader_binds_processed[l:callback_name] = []
		endif
		for args in g:leader_binds
			let l:key_combo = join(args.keys, '')
			if index(g:leader_binds_processed[l:callback_name], l:key_combo) >= 0
				continue
			endif

			call add(g:leader_binds_processed[l:callback_name], l:key_combo)
			if args.is_cmd
				" If a:value is a complete command e.g. :Gblame<CR>
				let l:value = ':' . args.value . '<CR>'
				" The underscore denotes the leader key (space).
				let l:long_name = args.long_name . ' (_' . l:key_combo . ')'
				let l:cmd_value = args.value
				let l:short_name = args.short_name
			else
				let l:value = args.value
				let l:long_name = args.long_name . ' (_' . l:key_combo . ') (nop)'
				let l:cmd_value = ''
				let l:short_name = args.short_name . ' (nop)'
			endif
			call a:Callback(args.keys, l:long_name, l:cmd_value)
		endfor
	endfunction
" }

" Key Remapping {
	" Set Leader to Space
	let mapleader = ' '
	let maplocalleader = ' '

	" Remove the Windows ^M - when the encodings gets messed up
	call LeaderBind('nnoremap', ['b', 'm', 'E'], 'FixEndingsWindows', 'Fix Line Endings (Windows)', 'fix_line_endings_windows', v:true)

	" Remove Trailing whitespace
	call LeaderBind('nnoremap', ['b', 'm', 'e'], 'FixEndingsWhiteSpace', 'Fix Line Endings (White Space)', 'fix_line_endings_white_space', v:true)

	" Buffer cycle
	nnoremap <silent><Tab> :bnext<CR>
	nnoremap <silent><S-Tab> :bprevious<CR>

	" Increment/Decrement remapping
	noremap <C-kPlus> <C-A>
	noremap <C-kMinus> <C-X>

	" Swap Normal and Visual mode semicolon and colon
	nnoremap ; :
	nnoremap : ;
	vnoremap ; :
	vnoremap : ;

	" Retain selection after visual indentation
	" Taken from https://vim.fandom.com/wiki/Shifting_blocks_visually
	vnoremap <Tab> >gv
	vnoremap <S-Tab> <gv

	" Yank to EOL, making Y behave more like the other capitals (C and D).
	" Taken from http://vimbits.com/bits/11
	noremap Y y$
" }

" Plug {
	let g:dein_plugins_dir = fnamemodify($VIMHOME.'/plugins', ':p:h')
	let g:dein_dir = fnamemodify(g:dein_plugins_dir.'/repos/github.com/Shougo/dein.vim', ':p:h')
	exec 'set runtimepath^='.g:dein_dir

	" Specify a directory for plugins
	try
		silent! let s:dein_state = dein#load_state(g:dein_plugins_dir)
		if s:dein_state
			call dein#begin(g:dein_plugins_dir)

			" dein
			call dein#add(g:dein_dir)

			if filereadable(expand('$VIMHOME/autoload/browsing.vim'))
				source $VIMHOME/autoload/browsing.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/editing.vim'))
				source $VIMHOME/autoload/editing.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/files.vim'))
				source $VIMHOME/autoload/files.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/git.vim'))
				source $VIMHOME/autoload/git.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/linting.vim'))
				source $VIMHOME/autoload/linting.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/omni.vim'))
				source $VIMHOME/autoload/omni.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/snippet.vim'))
				source $VIMHOME/autoload/snippet.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/tag.vim'))
				source $VIMHOME/autoload/tag.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/ui.vim'))
				source $VIMHOME/autoload/ui.vim
			endif

			if filereadable(expand('$VIMHOME/autoload/private.vim'))
				source $VIMHOME/autoload/private.vim
			endif

			" Initialise plugin system
			call dein#end()
			call dein#save_state()

		endif

		augroup DeinConfig
			autocmd!
			autocmd VimEnter * call dein#call_hook('source')
			autocmd VimEnter * call dein#call_hook('post_source')
		augroup end

		if filereadable(expand('$VIMHOME/autoload/mapping.vim'))
			source $VIMHOME/autoload/mapping.vim
		endif
	catch
	endtry
" }

" Encoding {
	set encoding=utf-8
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
		%s/$//ge
		call s:strip_restore(state)
	endfunction
	command! FixEndingsWindows call s:strip_trailing_windows()
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
	set cmdheight=1                " Remove 'Press Enter to continue' message when type information is longer than one line.
	set nrformats-=octal           " Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it confusing.
	set nofoldenable               " Disable folding
	set timeoutlen=100             " Navigation character timeout
	set ttimeoutlen=50             " Other character timeout
	if has('nvim')
		autocmd FocusGained * :checktime
		" A cleaner diff using built-in xdiff
		" Taken from https://vimways.org/2018/the-power-of-diff/
		set diffopt+=algorithm:patience
	endif
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

	if !has('nvim') && has('gui_running') " gVim
		if filereadable(expand('$VIMHOME/ginit.vim'))
			source $VIMHOME/ginit.vim
		endif
	endif
" }

" Fold options {
	set foldmethod=syntax " Fold on Syntax definition
" }

" Quickfix options {
	augroup DragQuickfixWindowDown
		autocmd!
		autocmd FileType qf wincmd J
	augroup end
" }

" vim: set fdm=indent : normal zi
