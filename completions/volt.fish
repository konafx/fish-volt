
function __volt_get_profile
    volt list -f '{{ println .CurrentProfileName }}'
end

function __volt_get_profiles
    volt list -f '{{ range .Profiles }}{{ println .Name }}{{ end }}'
end

function __volt_get_plugs -a profile target
    if contains $profile (__volt_get_profiles)
        switch $target
            case all
                __volt_all_plugs
            case this
                __volt_this_plugs $profile
            case not
                comm -23 (__volt_all_plugs | psub) (__volt_this_plugs $profile | psub)
            case '*'
                echo
        end
    end
end

function __volt_trim_github -d "Trim 'github.com' and 'www.github.com'"
    sed -E 's@^(www\.)?github\.com/@@' $argv
end

function __volt_all_plugs
    volt list -f "{{ range .Repos }}{{ println .Path }}{{ end }}" | __volt_trim_github | sort -u
end

function __volt_this_plugs -a profile
    volt list -f "{{ range .Profiles }}{{ if eq \"$profile\" .Name }}{{ range .ReposPath }}{{ println . }}{{ end }}{{ end }}{{ end }}" | __volt_trim_github | sort -u
end

set index_update 3
complete -f -c volt -n "__fish_use_subcommand" -a "get" -d "Install or upgrade or add localy {repository} list as plugins"
complete -f -c volt -n "__fish_seen_subcommand_from get" -s u -d "upgrade plugins"
complete -f -c volt -n "__fish_seen_subcommand_from get; and string match -q -- -u (commandline -co)[$index_update]" -a "(__volt_all_plugs)"
complete -x -c volt -n "__fish_seen_subcommand_from get" -s l -a " -u" -d "use all plugins in current profile as targets"

complete -f -c volt -n "__fish_use_subcommand" -a "rm" -d "Uninstall one or more {repository} from every profile"
complete -x -c volt -n "__fish_seen_subcommand_from rm" -a "(__volt_all_plugs)"
complete -f -c volt -n "__fish_seen_subcommand_from rm" -s r -d "remove also repository directories of specified repositories"
complete -f -c volt -n "__fish_seen_subcommand_from rm" -s p -d "remove also plugconf files of specified repositories"

complete -f -c volt -n "__fish_use_subcommand" -a "list" -d "Vim plugin information extractor"
complete -f -c volt -n "__fish_seen_subcommand_from list" -s f -d "it renders by given template which can access the information of lock.json"

complete -c volt -n "__fish_use_subcommand" -a "enable" -d "This is shortcut of: volt profile add -current"
complete -c volt -n "__fish_use_subcommand" -a "disable" -d "This is shortcut of: volt profile rm -current"
complete -x -c volt -n "__fish_seen_subcommand_from enable" -a "(__volt_get_plugs (__volt_get_profile) not)"
complete -x -c volt -n "__fish_seen_subcommand_from disable" -a "(__volt_get_plugs (__volt_get_profile) this)"

complete -f -c volt -n "__fish_use_subcommand" -a "edit" -d "Open the plugconf file(s) of one or more repository for editing"
complete -x -c volt -n "__fish_seen_subcommand_from edit" -a "(__volt_all_plugs)"

complete -f -c volt -n "__fish_use_subcommand" -a "profile" -d "profile"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "set" -d "Set profile"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "show" -d "Show profile info"
complete -f -c volt -n "__fish_prev_arg_in profile" -a "list" -d "List all profiles"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "new" -d "Create new profile"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "destroy" -d "Delete profile"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "rename" -d "Rename profile {old} to {new}"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "add" -d "Add one or more repositories to profile"
complete -x -c volt -n "__fish_prev_arg_in profile" -a "rm" -d "Remove one or more repositories to profile"

set index_profile 4
set need_profile set show destroy rename add rm
complete -f -c volt -n "__fish_seen_subcommand_from profile; and __fish_prev_arg_in $need_profile" -a "(__volt_get_profiles)"
complete -f -c volt -n "__fish_seen_subcommand_from profile; and __fish_any_arg_in add; and test (count (commandline -poc)) -ge 4" -a "(__volt_get_plugs (commandline -co)[$index_profile] not)"
complete -f -c volt -n "__fish_seen_subcommand_from profile; and __fish_any_arg_in rm; and test (count (commandline -poc)) -ge 4" -a "(__volt_get_plugs (commandline -co)[$index_profile] this)"

complete -f -c volt -n "__fish_use_subcommand" -a "build" -d "Build ~/.vim/pack/volt/ directory"

complete -f -c volt -n "__fish_use_subcommand" -a "migrate" -d "Perform miscellaneous migration operations"
complete -f -c volt -n "__fish_seen_subcommand_from migrate" -o help
complete -f -c volt -n "__fish_seen_subcommand_from migrate" -a "lockjson plugconf/config-func" -d "Migrate option"

complete -f -c volt -n "__fish_use_subcommand" -a "self-upgrade" -d "Upgrade to the latest volt command"
complete -f -c volt -n "__fish_seen_subcommand_from self-upgrade" -o check -d "Only checks the newer version is available"

complete -f -c volt -n "__fish_use_subcommand" -a "version" -d "Show volt command version"
