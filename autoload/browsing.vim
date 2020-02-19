" denite options {
function! browsing#ConfigureDenite()
	if dein#tap('denite.nvim')
		" Add custom menus
		" TODO: Denite menus don't work
		let g:denite_menu = {}
		call denite#custom#var('menu', 'menus', g:denite_menu)

		function! s:add_denite_item(keys, name, cmd) abort
			let l:local_keys = deepcopy(a:keys)
			for current_range in range(0, len(l:local_keys) - 2)
				let l:key = join(l:local_keys[:current_range], '.')
				if !exists('g:denite_menu.' . l:key)
					execute 'let g:denite_menu.' . l:key . ' = ' . '{"command_candidates": []}'
				endif
			endfor

			if exists('g:denite_menu.' . join(a:keys[:-2], '.'))
				execute 'call add(g:denite_menu.' . join(a:keys[:-2], '.') . '.command_candidates,'. '[' . shellescape(a:name) . ',' . shellescape(a:cmd) . '])'
			else
				execute 'let g:denite_menu.' . join(a:keys[:-1], '.') . ' = '. '{"command_candidates": [' . shellescape(a:name) . ',' . shellescape(a:cmd) . ']}'
			endif
		endfunction

		call LeaderBindsAddCallback(function('s:add_denite_item'))

		" reset 50% winheight on window resize
		augroup deniteresize
			autocmd!
			autocmd VimResized,VimEnter * call denite#custom#option('default',
				\'winheight', winheight(0) / 2)
		augroup end

		" Options
		let s:denite_options = {
		\ 'prompt'                      : 'λ',
		\ 'start_filter'                : v:true,
		\ 'auto_resize'                 : v:true,
		\ 'smartcase'                   : v:true,
		\ 'source_names'                : 'short',
		\ 'sorter'                      : 'sorter/word',
		\ 'highlight_filter_background' : 'CursorLine',
		\ 'highlight_matched_char'      : 'Type',
		\ }

		call denite#custom#option('default', s:denite_options)

		" Sorters
		call denite#custom#source('file',         'sorters', ['sorter/sublime'])
		call denite#custom#source('file/old',     'sorters', ['sorter/sublime'])
		call denite#custom#source('file/rec/git', 'sorters', ['sorter/sublime'])

		" Matchers
		call denite#custom#source('buffer'      , 'matchers', ['matcher/regexp'])
		call denite#custom#source('file/old'    , 'matchers', ['matcher/regexp'])
		if dein#tap('fruzzy')
			call denite#custom#source('file'        , 'matchers', ['converter/tail_path', 'matcher/fruzzy'])
			call denite#custom#source('file/rec'    , 'matchers', ['converter/tail_path', 'matcher/fruzzy'])
			call denite#custom#source('file/rec/git', 'matchers', ['converter/tail_path', 'matcher/fruzzy'])
		else
			call denite#custom#source('file'        , 'matchers', ['converter/tail_path', 'matcher/fuzzy'])
			call denite#custom#source('file/rec'    , 'matchers', ['converter/tail_path', 'matcher/fuzzy'])
			call denite#custom#source('file/rec/git', 'matchers', ['converter/tail_path', 'matcher/fuzzy'])
		end

		" Converters
		call denite#custom#source('file/old', 'converters', ['converter/relative_word'])
		call denite#custom#source('gitstatus', 'converters', ['converter/relative_word'])

		if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
			call denite#custom#var('outline', 'options', ['−−options='.$VIMHOME.'\utils\ctags\ctags.cfg'])
		endif

		call denite#custom#var('outline', 'file_opt', '-f')

		autocmd FileType denite call s:denite_normal_mappings()
		function! s:denite_normal_mappings() abort
			nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
			nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
			nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
			nnoremap <silent><buffer><expr> /       denite#do_map('open_filter_buffer')
			nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
			nnoremap <silent><buffer><expr> <Up>    'k'
			nnoremap <silent><buffer><expr> <Down>  'j'
			nnoremap <silent><buffer><expr> yy      denite#do_map('do_action', 'yank')
			nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
			nnoremap <silent><buffer><expr> <C-a>   denite#do_map('toggle_select_all')
			nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
			nnoremap <silent><buffer><expr> q       denite#do_map('do_action', 'quickfix')
			nnoremap <silent><buffer><expr> qf      denite#do_map('do_action', 'qfreplace')
		endfunction

		autocmd FileType denite-filter call s:denite_filter_mappings()
		function! s:denite_filter_mappings() abort
			imap     <silent><buffer>       <Esc>  <Plug>(denite_filter_quit)
			inoremap <silent><buffer><expr> <Tab>  denite#do_map('choose_action')
			inoremap <silent><buffer>       <Up>   <Esc><C-w>p:call cursor(line('.')-1,0)<CR>
			inoremap <silent><buffer>       <Down> <Esc><C-w>p:call cursor(line('.')+1,0)<CR>
			inoremap <silent><buffer><expr> <C-t>  denite#do_map('do_action', 'tabopen')
			inoremap <silent><buffer><expr> <C-v>  denite#do_map('do_action', 'vsplit')
			inoremap <silent><buffer><expr> <C-x>  denite#do_map('do_action', 'split')
		endfunction

		if !exists('g:denite_menu.b')
			let g:denite_menu.b = {'description': 'Buffer'}
			let g:denite_menu.b.command_candidates = []
		else
			let g:denite_menu.b.description = 'Buffer'
		endif

		if !exists('g:denite_menu.b.m')
			let g:denite_menu.b.m = {'description': 'Modify'}
			let g:denite_menu.b.m.command_candidates = []
		else
			let g:denite_menu.b.m.description = 'Modify'
		endif

		if dein#tap('denite-ale')
			call LeaderBind('nnoremap <silent>', ['b', 's'], 'Denite ale', 'Syntax Errors', 'syntax_errors', v:true)
		endif

		if !exists('g:denite_menu.d')
			let g:denite_menu.d = {'description': 'Denite'}
			let g:denite_menu.d.command_candidates = []
		else
			let g:denite_menu.d.description = 'Denite'
		endif

		call LeaderBind('nnoremap <silent>', ['d', 'b'], 'Denite buffer'     , 'Buffers', 'buffers', v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'c'], 'Denite colorscheme', 'Colours', 'colours', v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'd'], 'Denite menu'       , 'Menu'   , 'menu'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'g'], 'Denite grep'       , 'Grep'   , 'grep'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'h'], 'Denite help'       , 'Help'   , 'help'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'l'], 'Denite line'       , 'Lines'  , 'lines'  , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'm'], 'Denite mark'       , 'Marks'  , 'marks'  , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'r'], 'Denite -resume'    , 'Resume' , 'resume' , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'y'], 'Denite neoyank'    , 'Yanks'  , 'yanks'  , v:true)

		if !exists('g:denite_menu.f')
			let g:denite_menu.f = {'description': 'Files'}
			let g:denite_menu.f.command_candidates = []
		else
			let g:denite_menu.f.description = 'Files'
		endif
		call LeaderBind('nnoremap <silent>', ['f', 'f'], 'Denite file'                  , 'Files'                , 'file'        , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'm'], 'Denite file/old'              , 'Files (Most Used)'    , 'file/old'    , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'r'], 'Denite file/rec'              , 'Files (Recursive)'    , 'file/rec'    , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'g'], 'DeniteProjectDir file/rec/git', 'Files (Git Recursive)', 'file/rec/git', v:true)

		if !exists('g:denite_menu.t')
			let g:denite_menu.t = {'description': 'Tags'}
			let g:denite_menu.t.command_candidates = []
		else
			let g:denite_menu.t.description = 'Tags'
		endif
		call LeaderBind('nnoremap <silent>', ['t', 'b'], 'Denite outline', 'Tags (Buffer)', 'buffer_tag', v:true)
		call LeaderBind('nnoremap <silent>', ['t', 'g'], 'Denite tag'    , 'Tags (Global)', 'global_tag', v:true)

		" Cycle through Denite buffer like the Quickfix buffer using Unimpaired
		nnoremap <silent> [d :<C-u>Denite -resume -immediately -cursor-pos=-<C-r>=v:count1<CR><CR>
		nnoremap <silent> ]d :<C-u>Denite -resume -immediately -cursor-pos=+<C-r>=v:count1<CR><CR>

		if dein#tap('vim-fugitive')
			if !exists('g:denite_menu.g')
				let g:denite_menu.g = {'description': 'Git'}
				let g:denite_menu.g.command_candidates = []
			else
				let g:denite_menu.g.description = 'Git'
			endif

			" denite-git options {
			if dein#tap('denite-git')
				" FIXME: This denite menu doesn't work
				if !exists('g:denite_menu.g.g')
					let g:denite_menu.g.g = {'description': 'Denite Git'}
					let g:denite_menu.g.g.command_candidates = []
				else
					let g:denite_menu.g.g.description = 'Git'
				endif
				call LeaderBind('nnoremap <silent>', ['g', 'g', 'b'], 'Denite gitbranch', 'Denite Git Branch', 'denite_gitbranch', v:true)
				call LeaderBind('nnoremap <silent>', ['g', 'g', 's'], 'Denite gitstatus', 'Denite Git Status', 'denite_gitstatus', v:true)
			endif
			" }
		endif

		if executable('rg')
			call denite#custom#var('file/rec', 'command', ['rg', '--files', '--mmap', '--threads=12', '--hidden', '--smart-case', '--no-ignore-vcs', '--no-heading', '--glob', '!.git', '--glob', ''])
			call denite#custom#source('file/rec', 'matchers', ['matcher/regexp'])
			call denite#custom#source('file/rec', 'max_candidates', 10000)

			call denite#custom#var('grep', 'command', ['rg'])
			call denite#custom#var('grep', 'default_opts', ['--mmap', '--threads=12', '--hidden', '--smart-case', '--vimgrep', '--no-ignore-vcs', '--no-heading'])
			call denite#custom#var('grep', 'recursive_opts', [])
			call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
			call denite#custom#var('grep', 'separator', ['--'])
			call denite#custom#var('grep', 'final_opts', [])
			call denite#custom#source('grep', 'matchers', ['matcher_fuzzy', 'matcher/regexp'])
		endif

		if executable('git')
			call denite#custom#alias('source', 'file/rec/git', 'file/rec')
			call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])
		endif

		if dein#tap('vim-qfreplace')
			function! DeniteQfreplace(context)
				let qflist = []
				for target in a:context['targets']
					if !has_key(target, 'action__path') | continue | endif
					if !has_key(target, 'action__line') | continue | endif
					if !has_key(target, 'action__text') | continue | endif

					call add(qflist, {'filename': target['action__path'], 'lnum': target['action__line'], 'text': target['word']})
				endfor

				call setqflist(qflist)
				call qfreplace#start('tabnew')
			endfunction

			call denite#custom#action('file', 'qfreplace', function('DeniteQfreplace'))
		endif
	endif
endfunction
" }

" vim-leader-guide options {
function! browsing#ConfigureLeaderGuide()
	if dein#tap('vim-leader-guide')
		if !exists('g:leader_guide_map')
			let g:leader_guide_map = {}
		endif
		let g:leaderGuide_vertical = 0
		let g:leaderGuide_position = 'botright'
		let g:leaderGuide_max_size = 30

		call leaderGuide#register_prefix_descriptions("<Space>", "g:leader_guide_map")
		nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
		vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

		if dein#tap('vim-fugitive')
			if !exists('g:leader_guide_map.g')
				let g:leader_guide_map.g = {'name': 'Git/'}
			else
				let g:leader_guide_map.g.name = 'Git/'
			endif

			" denite-git options {
			if dein#tap('denite.nvim') && dein#tap('denite-git')
				if !exists('g:leader_guide_map.g.g')
					let g:leader_guide_map.g.g = {'name': 'Denite Git/'}
				else
					let g:leader_guide_map.g.g.name = 'Denite Git/'
				endif
			endif
			" }
		endif

		if !exists('g:leader_guide_map.b')
			let g:leader_guide_map.b = {'name': 'Buffer/'}
		else
			let g:leader_guide_map.b.name = 'Buffer/'
		endif

		if !exists('g:leader_guide_map.b.m')
			let g:leader_guide_map.b.m = {'name': 'Modify/'}
		else
			let g:leader_guide_map.b.m.name = 'Modify/'
		endif

		if dein#tap('denite.nvim')
			if !exists('g:leader_guide_map.f')
				let g:leader_guide_map.f = {'name': 'Files/'}
			else
				let g:leader_guide_map.f.name = 'Files/'
			endif
		endif

		if executable('ctags')
			if !exists('g:leader_guide_map.t')
				let g:leader_guide_map.t = {'name': 'Tags/'}
			else
				let g:leader_guide_map.t.name = 'Tags/'
			endif
		endif

		if dein#tap('denite.nvim')
			if !exists('g:leader_guide_map.d')
				let g:leader_guide_map.d = {'name': 'Denite/'}
			else
				let g:leader_guide_map.d.name = 'Denite/'
			endif
		endif

		function! s:add_leader_guide_item(keys, name, cmd) abort
			let l:local_keys = deepcopy(a:keys)

			for current_range in range(0, len(l:local_keys) - 1)
				let l:key = '[' . join(map(l:local_keys[:current_range], 'shellescape(v:val)'), '][') . ']'
				if !exists('g:leader_guide_map' . l:key)
					execute 'let g:leader_guide_map' . l:key . ' = ' . '{}'
				endif
			endfor

			let l:key = '[' . join(map(l:local_keys, 'shellescape(v:val)'), '][') . ']'

			execute 'let g:leader_guide_map' . l:key . ' = '. '[' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']'
		endfunction

		call LeaderBindsAddCallback(function('s:add_leader_guide_item'))
	endif
endfunction
" }

" vaffle.vim options {
function! browsing#ConfigureVaffle()
	if dein#tap('vaffle.vim')
		" Open like vim-vinegar
		nnoremap <silent> - :Vaffle<CR>

		" Disable the mapping in Fugitive
		if dein#tap('vim-fugitive')
			augroup vaffle_commit_enter
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
endfunction
" }

" fruzzy options {
function! browsing#ConfigureFruzzy()
	if dein#tap('fruzzy')
		let g:fruzzy#usenative = 1
		let l:version = fruzzy#version()
		if l:version =~# 'modnotfound'
			call fruzzy#install()
		endif
	endif
endfunction
" }

if has('python3') && executable('python')
	" denite
	call dein#add('https://github.com/Shougo/denite.nvim.git', {'rev': 'a74d60e74d0f70fe53fa7e67bce63dbeda923581'})
	call dein#config('denite.nvim', {'hook_post_source': 'call browsing#ConfigureDenite()'})

	" denite-ale
	call dein#add('https://github.com/iyuuya/denite-ale.git')
	call dein#config('denite-ale', {'depends': ['ale', 'denite.nvim']})

	" denite-git
	call dein#add('https://github.com/neoclide/denite-git.git')
	call dein#config('denite-git', {'depends': 'denite.nvim'})

	" denite-extra
	call dein#add('https://github.com/neoclide/denite-extra.git')
	call dein#config('denite-extra', {'depends': 'denite.nvim'})

	" fruzzy
	call dein#add('https://github.com/raghur/fruzzy.git')
	call dein#config('fruzzy', {'depends': 'denite.nvim', 'hook_post_source': 'call browsing#ConfigureFruzzy()'})

	" neoyank.vim
	call dein#add('https://github.com/Shougo/neoyank.vim.git')
endif

" vim-leader-guide
call dein#add('https://github.com/hecal3/vim-leader-guide.git')
call dein#config('vim-leader-guide', {'hook_source': 'call browsing#ConfigureLeaderGuide()', 'on_event': 'VimEnter'})

" vaffle.vim
call dein#add('https://github.com/cocopon/vaffle.vim.git')
call dein#config('vaffle.vim', {'hook_post_source': 'call browsing#ConfigureVaffle()'})
