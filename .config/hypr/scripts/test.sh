#!/usr/bin/bash
#
# x=$1
# # [ -z $x ] && echo "Hello, World!!!" || echo "Bye, World!!!" 
#
# # if [ -z $x ]; then
# #     echo "hello, world!!!"
# # else
# #     echo "bye, world!!!"
# # fi
# #
# echo "$( [ -z $x ] && echo "Fuck" || echo "Nigger")"

IS_MUTED="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -s 'MUTED' && echo 'MUTED')"
echo $IS_MUTED
