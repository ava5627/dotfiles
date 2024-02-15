function lb --description "ls if argument is a directory, bat otherwise"
    for arg in $argv
        if [ -e "$arg" ]
            set args $args $arg
        else
            set opts $opts $arg
        end
    end
    if [ -z "$args" ] || [ -d "$args" ]
        ls $argv
    else
      bat $args
    end
end
