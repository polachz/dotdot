
" 1 tab == 4 spaces
set shiftwidth=3
set tabstop=3
   
""au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab"""
autocmd Filetype sh setlocal ts=3 sts=3 sw=3 expandtab"""

