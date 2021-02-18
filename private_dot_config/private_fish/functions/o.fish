function o -d "Open files"
    if test (count $argv) -eq 1
        set suffix (string split -r -m1 . $argv[1])[2]

        if not test $suffix
            open $argv
        else if test $suffix = "md"
            ec $argv
        else
            echo "Unkown suffix: $suffix"
            open $argv
        end
    else
        #TODO: implements a for loop
        open $argv
    end
end
