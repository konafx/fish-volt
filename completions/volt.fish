function ___volt_get_profile
    volt list -f '{{ .CurrentProfileName }}'
end

function __volt_get_profiles
    volt list -f '{{ range .Profiles }}{{ println .Name }}{{ end }}'
end

function __fish_volt_get_plugs -a profile target
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

function __volt_all_plugs
    volt list -f "{{ range .Repos }}{{ println .Path }}{{ end }}" | sed -E 's@^(www\.)?github\.com/@@' | sort -u
end

function __volt_this_plug -a profile
    volt list -f "{{ range .Profiles }}{{ if eq \"$profile\" .Name }}{{ range .ReposPath }}{{ println . }}{{ end }}{{ end }}{{ end }}" | sed -E 's@^(www\.)?github\.com/@@' | sort -u
end

complete -f -c volt -n "__fish_use_subcommand" -a "get" -d "Install or upgrade or add localy {repository} list as plugins"
complete -f -c volt -n "__fish_seen_subcommand_from get" -a "(__volt_all_plugs)"
complete -f -c volt -n "__fish_seen_subcommand_from get" -s l -d "use all plugins in current profile as targets"
complete -f -c volt -n "__fish_seen_subcommand_from get" -s u -d "upgrade plugins"

complete -f -c volt -n "__fish_use_subcommand" -a "rm" -d "Uninstall one or more {repository} from every profile"
complete -f -c volt -n "__fish_seen_subcommand_from rm" -a "(__volt_all_plugs)"
complete -f -c volt -n "__fish_seen_subcommand_from rm" -s r -d "remove also repository directories of specified repositories"
complete -f -c volt -n "__fish_seen_subcommand_from rm" -s p -d "remove also plugconf files of specified repositories"

complete -f -c volt -n "__fish_use_subcommand" -a "list" -d "Vim plugin information extractor"
complete -f -c volt -n "__fish_seen_subcommand_from list" -s f -d "it renders by given template which can access the information of lock.json"

complete -f -c volt -n "__fish_use_subcommand" -a "enable" -d "This is shortcut of: volt profile add -current"
complete -f -c volt -n "__fish_use_subcommand" -a "disable" -d "This is shortcut of: volt profile rm -current"

complete -f -c volt -n "__fish_use_subcommand" -a "edit" -d "Open the plugconf file(s) of one or more repository for editing"
complete -f -c volt -n "__fish_seen_subcommand_from edit" -a "(__volt_all_plugs)"

complete -f -c volt -n "__fish_use_subcommand" -a "profile" -d "profile"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "set" -d "Set profile"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "show" -d "Show profile info"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "list" -d "List all profiles"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "new" -d "Create new profile"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "destroy" -d "Delete profile"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "rename" -d "Rename profile {old} to {new}"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "add" -d "Add one or more repositories to profile"
complete -f -c volt -n "__fish_seen_subcommand_from profile" -a "rm" -d "Remove one or more repositories to profile"

complete -f -c volt -n "__fish_use_subcommand" -a "build" -d "Build ~/.vim/pack/volt/ directory"
complete -f -c volt -n "__fish_use_subcommand" -a "migrate" -d "Perform miscellaneous migration operations"
complete -f -c volt -n "__fish_use_subcommand" -a "self-upgrade" -d "Upgrade to the latest volt command"
complete -f -c volt -n "__fish_seen_subcommand_from self-upgrade" -s "check" -d "Only checks the newer version is available"

complete -f -c volt -n "__fish_use_subcommand" -a "version" -d "Show volt command version"
