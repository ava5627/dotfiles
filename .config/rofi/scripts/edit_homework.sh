#! /usr/bin/env bash

hw_dir="$HOME/Insync/Homework"
class_file="$hw_dir/Current Classes.txt"
recent_file="$hw_dir/Recent.txt"

if test -f "$class_file"; then
    course=$((test -f $recent_file && perl -pe 's/^\s*$//g' $recent_file; cat "$class_file"; echo clear) | rofi -matching normal -dmenu -i -p 'Course:')
else
    ls $hw_dir | rofi -matching normal rofi -dmenu -multi-select -kb-accept-alt "space" -i -p 'Course:' > "$class_file"
    course=$(cat "$class_file" | rofi -matching normal -dmenu -i -p 'Course:')
fi

if [[ -z $course ]]; then
    exit
elif [[ $course =~ ^Recent:.* ]]; then
    kitty -e $EDITOR "$hw_dir/${course:8}"
    selected=$course
    course=$(echo $course | perl -pe "s|Recent: (.*)/.*|\1|g")
    echo -e "$selected\n$(perl -pe s/"Recent:.*$course.*\n"//g "$recent_file")" > "$recent_file"
    exit
elif [[ $course == "clear" ]]; then
    test -f "$class_file" && rm "$class_file"
    test -f "$recent_file" && rm "$recent_file"
    exit
fi


folder=$((ls "$hw_dir/$course"; echo new) | rofi -dmenu -i)

if [ -z "$folder" ]; then
    exit
elif [[ "$folder" == "new" ]]; then
    folder=$(rofi -dmenu -p "New Directory Name")
    mkdir "$hw_dir/$course/$folder"
    kitty -e $EDITOR "$hw_dir/$course/$folder" &
else
    kitty -e $EDITOR "$hw_dir/$course/$folder" &
fi

if test -f "$recent_file"; then
    echo -e "Recent: $course/$folder\n$(perl -pe s/"Recent:.*$course.*\n"//g "$recent_file")" > "$recent_file"
else
    echo -e "Recent: $course/$folder" > "$recent_file"
fi
