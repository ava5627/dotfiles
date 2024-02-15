function fish_right_prompt
    set -l last_duration $CMD_DURATION
    set -l last_pipestatus $pipestatus
    set -l last_status $status

    set -l prompt_status (__fish_print_pipestatus " [" "] " "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
    echo -n "$prompt_status "

    if [ -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 0 ]
        set -l rounded (math -s 0 $CMD_DURATION/1000)
        if [ $rounded -gt 0 ]
            set_color green
            echo -n  ["$rounded"s]
            set_color normal
            echo -n " "
        end
    end

    set_color 888
    date "+%H:%M "
end
