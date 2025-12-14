{ pkgs, system, ... }:
pkgs.writeShellScriptBin "devshell" ''
    progname=$(basename "$0")
    
    print_small_help() {
        echo -e "\x1b[1mUsage:\x1b[0m"
        echo "  devshell {<shell>|fhs|list|help}"
        echo "  devshell packages {warm|clean|help}"
        echo ""
    }

    print_help() {
        echo "Activates a predefined development environment (aka devshell)"
        echo "Providing the current shell with a targeted version of the software needed"
        echo ""
        echo -e "\x1b[1m-= Shell options =-\x1b[0m"
        echo ""
        echo "devshell <shell>"
        echo "  Activates the specified devshell"
        echo "  <shell> must be formatted like <prefix>:<option>. For example: \`devshell python:v314t\`"
        echo "  You can omit the <option> part for the default shell of a prefix. For example: \`devshell python\`"
        echo "  Devshells can be nested"
        echo "  You can list all available devshells with \`devshell list\`"
        echo ""
        echo "devshell list"
        echo "  Lists all available devshells sorted by prefix"
        echo "  Devshells are presented by prefix and option formatted as"
        echo "  »<prefix>"
        echo "   ├─ <option1>"
        echo "   └─ ..."
        echo ""
        echo "devshell fhs"
        echo "  Activates the FHS devshell (Filesystem Hierarchy Standard)"
        echo "  The FHS devshell is a non-sandboxed FHS compliant environment with many libs"
        echo "  It may be used to run or compile some programs needing a standard file système"
        echo ""
        echo "devshell help"
        echo "  Prints this help"
        echo ""
    }

    print_packages_help() {
        echo -e "\x1b[1m-= Packages options =-\x1b[0m"
        echo ""
        echo "devshell packages warm"
        echo "  Install all the packages needed by the devshells"
        echo "  Installed packages are protected of future nix store garbage collection"
        echo ""
        echo "devshell packages clean"
        echo "  Remove all protection on the packages needed by the devshells"
        echo "  They will be deleted by any future nix store garbage collection"
        echo "  Packages are not immediatly deleted"
        echo ""
        echo "devshell packages clean"
        echo "  Prints help about pacakges"
        echo ""

    }

    print_invalid_option_error() {
        echo -e "\x1b[1;31m$progname: Invalid option -- $*\x1b[0m"
    }

    print_no_option_error() {
        echo -e "\x1b[1;31m$progname: No option specified\x1b[0m"
    }

    print_shells() {
        nix flake show --json "$HOME"/anatos/devshells | jq -r '.devShells["${system}"] | to_entries[] | "\(.key) \(.value.name)"' | awk '
        {
            n = split($1, a, ":")
            prefix = a[1]
            suffix = a[2]
            data[prefix][suffix] = $2
            prefixes[prefix] = 1
        }
        # After processing all lines
        END {
            nPrefixes = asorti(prefixes, sortedPrefixes)
            for (j=1; j<=nPrefixes; j++) {
                p = sortedPrefixes[j]
                print "\x1b[1;33m»\x1b[1;32m" p "\x1b[0m"
                n = asorti(data[p], keys)
                for (i=1; i<=n; i++) {
                    s = keys[i]
                    symbol = (i==n ? " └─" : " ├─")
                    print symbol " \x1b[1;34m" s "\x1b[0m: " data[p][s]
                }
            }
        }'
    }

    get_prefixes() {
        nix flake show --json "$HOME"/anatos/devshells | jq -r '.devShells["${system}"] | keys | map(split(":")[0]) | unique | .[]'
    }

    get_shells() {
        nix flake show --json "$HOME"/anatos/devshells | jq -r '.devShells["${system}"] | to_entries[] | "\(.key)"'
    }

    contains() {
        local item=$1; shift
        IFS=$' \t\n'
        for x in $@; do
            [ "$x" = "$item" ] && return 0
        done
        return 1
    }

    if [[ ! -n "$1" ]]; then
        print_no_option_error
        print_small_help
        exit 1
    fi

    prefixes=$(get_prefixes)
    shells=$(get_shells)
    case "$1" in
        "help") 
            print_small_help
            print_help
            print_packages_help
            ;;
        "list") 
            print_shells
            ;;
        "fhs") 
            nix-shell "$HOME"/anatos/devshells/fhs
            ;;
        "packages")
            if [[ ! -n "$2" ]]; then
                echo -e "\x1b[1;31m$progname packages: No option specified\x1b[1;0m"
                print_small_help
                exit 1
            fi
            case "$2" in
                "help") 
                    print_packages_help 
                    ;;
                "warm") 
                    nix profile remove devshells
                    nix profile install "$HOME"/anatos/devshells#installScript
                    install-all-devshell-packages
                    echo -e "Warmed all devshell programs, they will persist through `nix-store --gc`"
                    ;;
                "clean") 
                    rm -rf "$HOME"/.nix-profile-devshells/*
                    echo -e "Cleaned all devshell programs, run `nix-store --gc` to permanently remove them"
                    ;;
                * )
                    print_invalid_option_error "$*"
                    print_small_help
                    exit 1
                    ;;
            esac
            ;;
        "fhs") 
            nix-shell ~/anatos/devshells/fhs/shell.nix
            ;;
        * )
            if contains "$1" "$prefixes"; then
                nix develop "$HOME"/anatos/devshells#"$1":default
            elif contains "$1" "$shells"; then
                nix develop "$HOME"/anatos/devshells#"$1"
            else
                print_invalid_option_error "$*"
                print_small_help
                exit 1
            fi
            ;;
    esac
    exit 0
    ''