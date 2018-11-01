if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	" VB Classes
	au! BufRead,BufNewFile *.cls			setf vb

	" Cake Build scripts
	au! BufRead,BufNewFile *.cake			setf cs

	" Csproj
	au! BufRead,BufNewFile *.csproj			setf csproj

	" Sln
	au! BufRead,BufNewFile *.sln			setf sln
augroup END
