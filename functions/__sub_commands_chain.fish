#
# Sample commands:
# > proverb -jp dog walk hit stick
# 
# Call "stick" completion:
# `complete -c proverb -n "__subcommands_chain dog walk hit" -a "stick"`
#

function __subcommands_chain -d "Test subcommand chained"
    set -l tokens (commandline -poc)
    set -e tokens[1]
    set -l cmds (string match -v -- '-*' $tokens)

    set len_cmds (count $cmds)
    test $len_cmds -ne (count $argv)
    and return 1

    for i in (seq $len_cmds)
        string match -v -q $cmds[$i] $argv[$i]
        and return 1
    end

    return 0
end
