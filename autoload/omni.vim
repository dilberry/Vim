" deoplete options {
function! omni#ConfigurePreDeoplete()
	if dein#tap('deoplete.nvim')
		" General options
		let g:deoplete#enable_at_startup = 1
		let g:deoplete#file#enable_buffer_path = 1
		let g:deoplete#auto_completion_start_length = 2
		let g:deoplete#manual_completion_start_length = 1
		let g:deoplete#sources#syntax#min_keyword_length = 3
		let g:deoplete#auto_complete_delay = 5
		let g:deoplete#auto_refresh_delay = 30
		let g:deoplete#refresh_always = v:true

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

		" C# options
		let g:deoplete#sources.cs = ['omni']
		let g:deoplete#omni#input_patterns.cs = ['.*[^=\);]']

		" Javascript options
		let g:deoplete#sources.javascript = ['tern', 'omni']

		" Python options
		let g:deoplete#sources.python = ['jedi']

		" Vim options
		let g:deoplete#sources.vim = ['vim']
	endif
endfunction

function! omni#ConfigureDeoplete()
	if dein#tap('deoplete.nvim')
		call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
		call deoplete#custom#source('_', 'matchers', ['matcher_head'])
		call deoplete#custom#source('omni', 'matchers', ['matcher_head'])
		call deoplete#custom#source('buffer', 'rank', 100)
		call deoplete#custom#source('buffer', 'disabled_syntaxes', ['Comment', 'String'])

		" Cycle on Tab
		inoremap <silent><expr><tab> pumvisible()? "\<c-n>" : "\<tab>"

		" Cycle backwards on Tab
		inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

		if dein#tap('denite.nvim')
			autocmd FileType denite-filter call s:denite_filter_deoplete_settings()
			function! s:denite_filter_deoplete_settings() abort
				call deoplete#custom#buffer_option('auto_complete', v:false)
			endfunction
		endif
	endif
endfunction
" }

" Omnisharp options {
function! omni#ConfigureOmnisharp()
	if dein#tap('omnisharp-vim')
		" FIXME: Running GDiff causes Omnisharp to ask for solution files
		function! s:omnisharp_menu_check() abort
			if dein#tap('denite.nvim')
				" FIXME: This denite menu doesn't work
				if !exists('g:denite_menu.o')
					let g:denite_menu.o = {'description': 'Omnisharp'}
					let g:denite_menu.o.command_candidates = []
					let g:denite_menu.o.f = {'description': 'Find'}
					let g:denite_menu.o.f.command_candidates = []
					let g:denite_menu.o.g = {'description': 'Goto'}
					let g:denite_menu.o.g.command_candidates = []
					let g:denite_menu.o.m = {'description': 'Modify'}
					let g:denite_menu.o.m.command_candidates = []
					let g:denite_menu.o.l = {'description': 'Lookup'}
					let g:denite_menu.o.l.command_candidates = []
					let g:denite_menu.o.s = {'description': 'Solution'}
					let g:denite_menu.o.s.command_candidates = []
				endif
			endif

			if dein#tap('vim-leader-guide')
				if !exists('g:leader_guide_map.o')
					let g:leader_guide_map.o = {'name': 'Omnisharp/'}
					let g:leader_guide_map.o.f = {'name': 'Find/'}
					let g:leader_guide_map.o.g = {'name': 'Goto/'}
					let g:leader_guide_map.o.m = {'name': 'Modify/'}
					let g:leader_guide_map.o.l = {'name': 'Lookup/'}
					let g:leader_guide_map.o.s = {'name': 'Solution/'}
				endif
			endif
		endfunction

		function! s:msbuild_options() abort
			" Error format for make
			setlocal errorformat=\ %#%f(%l\\\,%c):\ %m

			" Msbuild setting for make
			let &l:makeprg='msbuild /nologo /v:q /property:GenerateFullPaths=true /clp:ErrorsOnly '.shellescape(OmniSharp#FindSolutionOrDir())
		endfunction

		function! s:devenv_call() abort
			" Call Visual Studio with current solution
			let l:devenv_cmd = '!start /b cmd /c '.'"'.shellescape(s:devenv).' '.shellescape(OmniSharp#FindSolutionOrDir()).'"'
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
			call LeaderBind('nnoremap <buffer>', ['o', 'g', 'd'], 'OmniSharpGotoDefinition'     , 'Goto Definition'     , 'goto_definition'     , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'f', 'i'], 'OmniSharpFindImplementations', 'Find Implementations', 'find_implementations', v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'f', 't'], 'OmniSharpFindType'           , 'Find Type'           , 'find_type'           , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'f', 's'], 'OmniSharpFindSymbol'         , 'Find Symbol'         , 'find_symbol'         , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'f', 'u'], 'OmniSharpFindUsages'         , 'Find Usages'         , 'find_usages'         , v:true)
			"finds members in the current buffer
			call LeaderBind('nnoremap <buffer>', ['o', 'f', 'm'], 'OmniSharpFindMembers'        , 'Find Members'        , 'find_members'        , v:true)

			" cursor can be anywhere on the line containing an issue
			call LeaderBind('nnoremap <buffer>', ['o', 'm', 'i'], 'OmniSharpFixIssue'           , 'Fix Issue'           , 'fix_issue'           , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'm', 'u'], 'OmniSharpFixUsings'          , 'Fix Usings'          , 'fix_usings'          , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'm', 'f'], 'OmniSharpCodeFormat'         , 'Format Code'         , 'format_code'         , v:true)

			" rename with dialog
			call LeaderBind('nnoremap <buffer>', ['o', 'm', 'r'], 'OmniSharpRename'             , 'Rename'              , 'rename'              , v:true)
			nnoremap <buffer><F2> :OmniSharpRename<cr>
			" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
			command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

			call LeaderBind('nnoremap <buffer>', ['o', 'l', 't'], 'OmniSharpTypeLookup'         , 'Lookup Type'         , 'lookup_type'         , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 'l', 'd'], 'OmniSharpDocumentation'      , 'Lookup Documentation', 'lookup_documentation', v:true)
			" Contextual code actions (requires CtrlP or unite.vim)
			call LeaderBind('nnoremap <buffer>', ['o', 'l', 'a'], 'OmniSharpGetCodeActions'     , 'Get Code Actions'    , 'get_code_actions'    , v:true)
			call LeaderBind('vnoremap <buffer>', ['o', 'l', 'a'], 'call OmniSharp#GetCodeActions(''visual'')', 'Get Code Actions', 'get_code_actions', v:true)

			" Builds can also run asynchronously with vim-dispatch installed
			call LeaderBind('nnoremap <buffer>', ['o', 's', 'b'], 'MSBuild'                     , 'Build'               , 'build'               , v:true)
			" Open the current solution in Visual Studio
			call LeaderBind('nnoremap <buffer>', ['o', 's', 'v'], 'DevEnv'                      , 'Open Visual Studio'  , 'open_visual_studio'  , v:true)
			" Force OmniSharp to reload the solution. Useful when switching branches etc.
			call LeaderBind('nnoremap <buffer>', ['o', 's', 'r'], 'OmniSharpRestartServer'      , 'Restart Server'      , 'restart_server'      , v:true)

			" Start the omnisharp server for the current solution
			call LeaderBind('nnoremap <buffer>', ['o', 's', 's'], 'OmniSharpStartServer'        , 'Start Server'        , 'start_server'        , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 's', 'p'], 'OmniSharpStopServer'         , 'Stop Server'         , 'stop_server'         , v:true)
			call LeaderBind('nnoremap <buffer>', ['o', 's', 'h'], 'OmniSharpHighlightTypes'     , 'Highlight Types'     , 'highlight_types'     , v:true)

			" Search for files from the Solution Directory
			call LeaderBind('nnoremap <silent>', ['f', 'p'], 'call SolutionFileList()', 'Files (Solution Recursive)', 'file/rec/git', v:true)

			call LeaderBindsProcess()
		endfunction

		function! SolutionFileList()
			call denite#start([{'name': 'file/rec/git', 'args': [fnamemodify(OmniSharp#FindSolutionOrDir(1, 0), ':h')]}])
		endfunction

		function! s:omnisharp_count_code_actions() abort
			if OmniSharp#FindSolutionOrDir(1, 0)
				if OmniSharp#IsServerRunning()
					if OmniSharp#CountCodeActions({-> execute('sign unplace 99')})
						let l = getpos('.')[1]
						let f = expand('%:p')
						execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
					endif
				endif
			endif
		endfunction

		augroup omnisharp_commands
			autocmd!

			"Set omnisharp key mappings
			autocmd FileType cs call s:omnisharp_options()
			autocmd FileType csproj call s:omnisharp_options()
			autocmd FileType sln call s:omnisharp_options()

			"Show type information automatically when the cursor stops moving
			autocmd CursorHold *.cs call s:omnisharp_count_code_actions()
		augroup END

		if !executable('OmniSharp')
			let g:OmniSharp_server_path = expand('~\utils\omnisharp.http-win-x64\OmniSharp.exe')
		endif

		sign define OmniSharpCodeActions text=💡
		let g:OmniSharp_server_type = 'roslyn'
		let g:OmniSharp_prefer_global_sln = 0
		let g:OmniSharp_highlight_groups = {
			\ 'csUserIdentifier': [ 'constant name', 'enum member name', 'field name', 'identifier', 'local name', 'parameter name', 'property name', 'static symbol'],
			\ 'csUserInterface': ['interface name'],
			\ 'csUserMethod': ['extension method name', 'method name'],
			\ 'csUserType': ['class name', 'enum name', 'namespace name', 'struct name']
		\}
		let g:OmniSharp_highlight_types = 2
		let g:OmniSharp_timeout = 5
		let g:OmniSharp_selector_ui = ''
	endif
endfunction
" }

" jspc options {
function! omni#ConfigureJspc()
	if dein#tap('jspc.vim')
		autocmd OmniFuncs FileType javascript setlocal omnifunc=jspc#omni
	endif
endfunction
" }

" deoplete
" This needs python3 neovim package to be installed
if has('python3') && executable('python')
	call dein#add('https://github.com/Shougo/deoplete.nvim.git')
	call dein#config('deoplete.nvim', {'hook_add': 'call omni#ConfigurePreDeoplete()', 'hook_source': 'call omni#ConfigureDeoplete()', 'on_event': 'InsertCharPre'})
	if !has('nvim')
		call dein#add('https://github.com/roxma/nvim-yarp.git')
		call dein#add('https://github.com/roxma/vim-hug-neovim-rpc.git')
	endif

	" deoplete-jedi
	" Requires jedi package in python install
	call dein#add('https://github.com/zchee/deoplete-jedi.git')
	call dein#config('deoplete-jedi', {'depends': 'deoplete.nvim', 'on_ft': ['python', 'python3', 'djangohtml']})

	" neco-vim
	call dein#add('https://github.com/Shougo/neco-vim.git')
	call dein#config('neco-vim', {'depends': 'deoplete.nvim', 'on_ft': 'vim'})

	" neco-syntax
	call dein#add('https://github.com/Shougo/neco-syntax.git')
	call dein#config('neco-syntax', {'depends': 'deoplete.nvim', 'on_ft': 'vim'})

	if executable('node')
		" deoplete-ternjs
		call dein#add('https://github.com/carlitux/deoplete-ternjs.git')
		call dein#config('deoplete-ternjs', {'depends': 'deoplete.nvim', 'on_ft': ['javascript', 'javascript.jsx', 'vue']})
	endif
endif

" omnisharp-vim
call dein#add('https://github.com/OmniSharp/omnisharp-vim.git')
call dein#config('omnisharp-vim', {'hook_post_source': 'call omni#ConfigureOmnisharp()', 'merged': 0, 'on_ft': ['cs', 'csproj', 'sln']})

" jspc.vim
call dein#add('https://github.com/othree/jspc.vim.git')
call dein#config('jspc.vim', {'hook_post_source': 'call omni#ConfigureJspc()', 'on_ft': ['javascript', 'javascript.jsx', 'vue']})
