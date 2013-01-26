" vim: set sw=2 ts=2 et :

""""""""""""""""""
" Functions
""""""""""""""""""

" Designed to work in conjuntion with the template.pm skeleton file
" Automatically replaces the package line with the appropriate name
fun! SetPerlPackageFromFile()
    " This expansion only has absolute path if the directory exists.
    " So package only gets set if the full path (not including filename)
    " exists
    let fname=expand('%:p')

    " Match anything with /lib/ or starting with lib/ or perl_lib/
    let index=matchend(fname, "[\</]lib/")
    if index == -1
        let index=matchend(fname, "[\</]perl_lib/")
    endif

    if index > -1
        let len=strlen(fname) - 3 - index
    else
        let firstchar = strpart(fname, 0, 1)
        if firstchar != "/"
            let len=strlen(fname) - 3
            let index=0
        endif
    endif

    if exists("len")
        let pname=strpart(fname, index, len)
        let parts=split(pname, '/')

        " Perl packages must start with a capital letter
        " So get rid of all parts that don't have an uppercase first letter
        let firstchar = strpart(get(parts, 0), 0, 1)
        while firstchar !=# toupper(firstchar) && len(parts) > 0
            let woo = remove(parts, 0)
            let firstchar = strpart(get(parts, 0), 0, 1)
        endwhile

        if len(parts) > 0
            let package=join(parts, '::')
            exec '1,$g/::package::/s/::package::/' . package
        endif
    endif
    return
endfun