if !executable('git')
	finish
endif

" vim-fugitive options {
function! git#ConfigureFugitive()
	if dein#tap('vim-fugitive')
		" Enter the commit message as Insert mode
		augroup commit_enter
			autocmd BufEnter COMMIT_EDITMSG startinsert
		augroup END

		augroup fugitive_key_timeout
			autocmd!
			autocmd BufEnter * if &filetype ==# 'fugitive' | set timeoutlen=2000 | endif
			autocmd BufLeave * if &filetype ==# 'fugitive' | set timeoutlen=100 | endif
		augroup END

		command! Gupdate silent execute 'Git add -u'
		call LeaderBind('nnoremap <silent>', ['g', 'b'], 'Gblame'          , 'Blame'                , 'blame'                , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'B'], 'Gbrowse'         , 'Browse'               , 'browse'               , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'c'], 'Gcommit'         , 'Commit'               , 'commit'               , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'D'], 'Gdiffsplit! HEAD', 'Diff HEAD'            , 'diff HEAD'            , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'd'], 'Gdiffsplit!'     , 'Diff'                 , 'diff'                 , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'm'], ':Gmove<Space>'   , 'Move'                 , 'move'                 , v:false)
		call LeaderBind('nnoremap <silent>', ['g', 'p'], 'Gpull'           , 'Pull'                 , 'pull'                 , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'P'], 'Gpush'           , 'Push'                 , 'push'                 , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'r'], 'Gread'           , 'Checkout current file', 'checkout-current-file', v:true)
		call LeaderBind('nnoremap <silent>', ['g', 's'], 'Gstatus'         , 'Status'               , 'status'               , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'w'], 'Gwrite'          , 'Write'                , 'write'                , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'u'], 'Gupdate'         , 'Update'               , 'update'               , v:true)
	endif
endfunction
" }

" gitv options {
function! git#ConfigureGitv()
	if dein#tap('gitv')
		call LeaderBind('nnoremap <silent>', ['g', 'v'], 'Gitv'         , 'Version (Commits)'    , 'version_commits'      , v:true)
		call LeaderBind('nnoremap <silent>', ['g', 'V'], 'Gitv!'        , 'Version (Files)'      , 'version_files'        , v:true)
	endif
endfunction
" }

" vim-gitgutter options {
function! git#ConfigureGitGutter()
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
endfunction
" }

" vim-fugitive
call dein#add('https://github.com/tpope/vim-fugitive.git')
call dein#config('vim-fugitive', {'hook_post_source': 'call git#ConfigureFugitive()'})

" gitv
call dein#add('https://github.com/gregsexton/gitv.git')
call dein#config('gitv', {'hook_post_source': 'call git#ConfigureGitv()', 'depends': 'vim-fugitive'})

" vim-gitgutter
call dein#add('https://github.com/airblade/vim-gitgutter.git')
call dein#config('vim-gitgutter', {'hook_post_source': 'call git#ConfigureGitGutter()'})
