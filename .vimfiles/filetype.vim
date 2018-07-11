if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	" VB Classes
	au! BufRead,BufNewFile *.cls			setf vb

	" Cake Build scripts
	au! BufRead,BufNewFile *.cake			setf cs
augroup END
