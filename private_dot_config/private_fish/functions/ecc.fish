# Defined via `source`
function ecc --wraps='emacsclient -nc' --description 'alias ecc emacsclient -nc'
    if not emacsclient -e 0 &>/dev/null
        emacs --daemon
    end
    emacsclient -nc $argv
end
