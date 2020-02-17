function __fish_is_arg_n -a n
    test $n -eq (count (string match -v -- '-*' (commandline -poc)))
end

function __volt_get_profile
    volt list -f '{{ .CurrentProfileName }}'
end

function __volt_get_profiles
    volt list -f '{{ range .Profiles }}{{ println .Name }}{{ end }}'
end

function __volt_get_plugs -a profile target
    if contains $profile (__volt_get_profiles)
        switch $target
            case all
                __fish_volt_all_plug
            case this
                __fish_volt_this_plug $profile
            case not
                comm -23 (__volt_all_plugs | psub) (__volt_get_this_plug $profile | psub)
            case '*'
                echo 
        end
    end
end

function __volt_this_plugs -a profile
    volt list -f "{{ range .Profiles }}{{ if eq \"$profile\" .Name }}{{ range .ReposPath }}{{ println . }}{{ end }}{{ end }}{{ end }}" | sed -E 's@^(www\.)?github\.com/@@' | sort -u
end

function __volt_this_plug -a profile
    volt list "{{ range .Profiles }}{{ if eq \"$profile\" .Name }}{{ range .ReposPath }}{{ println . }}{{ end }}{{ end }}{{ end }}" | sed -E 's@^(www\.)?github\.com/@@' | sort -u
end

complete -c volt -x
complete -c volt -n "__fish_use_subcommand" -a "get" -d "Install or upgrade or add repository list as plugins"
complete -c volt -n "__fish_use_subcommand" -a "rm" -d "Uninstall one or more repository from every profile"
complete -c volt -n "__fish_use_subcommand" -a "list" -d "Vim plugin information extractor"
complete -c volt -n "__fish_use_subcommand" -a "enable" -d "Shortcut of: volt profile add -current"
complete -c volt -n "__fish_use_subcommand" -a "disable" -d "Shortcut of: volt profile rm -current"
complete -c volt -n "__fish_use_subcommand" -a "edit" -d "Open the plugconf file for editing"
complete -c volt -n "__fish_use_subcommand" -a "profile" -d "profile"
complete -c volt -n "__fish_use_subcommand" -a "build" -d "Build ~/.vim/pack/volt/ directory"
complete -c volt -n "__fish_use_subcommand" -a "migrate" -d "Perform miscellaneous migration operations"
complete -c volt -n "__fish_use_subcommand" -a "self-upgrade" -d "Upgrade to the latest volt command"
complete -c volt -n "__fish_use_subcommand" -a "version" -d "Show volt command version"

# get
complete -c volt -n "__fish_seen_subcommand_from get" -s l -d "All plugins in current profile as targets"
complete -c volt -n "__fish_seen_subcommand_from get" -s u -a "(__volt_all_plugs)" -d "Upgrade plugins"

# rm
complete -c volt -n "__fish_seen_subcommand_from rm" -s r -d "Remove also repository directories"
complete -c volt -n "__fish_seen_subcommand_from rm" -s p -d "Remove also plugconf files"

# list
complete -c volt -n "__fish_seen_subcommand_from list" -s f -d "It renders by given template which can access the information of lock.json"

# enable
complete -c volt -n "__fish_seen_subcommand_from enable" -a "(__volt_get_plugins (__volt_get_profile) not)"

# disable
complete -c volt -n "__fish_seen_subcommand_from disable" -a "(__volt_get_plugins (__volt_get_profile) this)"

# edit
complete -c volt -n "__fish_seen_subcommand_from edit" -a "(__volt_all_plugs)"
complete -c volt -n "__fish_seen_subcommand_from edit" -s e -l editor -a "vim"

# profile
complete -c volt -n "__fish_seen_subcommand_from profile" -a "set" -d "Set profile"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "show" -d "Show profile info"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "list" -d "List all profiles"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "new" -d "Create new profile"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "destroy" -d "Delete profile"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "rename" -d "Rename profile"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "add" -d "Add repository to profile"
complete -c volt -n "__fish_seen_subcommand_from profile" -a "rm" -d "Remove repository to profile"

# build

# migrate

# self-upgrade
complete -c volt -n "__fish_seen_subcommand_from self-upgrade" -o "check" -d "Only checks the newer version is available"

#version
