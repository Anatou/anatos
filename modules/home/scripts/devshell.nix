{ pkgs, lib, option, config, system, ... }:
let
script = pkgs.writeShellScriptBin "devshell" ''
    progname=$(basename "$0")
    flake_dir="$HOME/anatos/devshells"
    cache_dir="$HOME/.cache/anatos"
    cache_file="$cache_dir/devshells.json"
    roots_dir="$HOME/.local/state/anatos/devshell-roots"

    print_small_help() {
        echo -e "\x1b[1mUsage:\x1b[0m"
        echo "  devshell {<shell>|fhs|list|warm|clean|help}"
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
        echo "  <shell> must be formatted like <prefix>:<option>. For example: \`devshell python:v315t\`"
        echo "  You can omit the <option> part for the default shell of a prefix. For example: \`devshell python\`"
        echo "  Devshells can be nested"
        echo "  You can list all available devshells with \`devshell list\`"
        echo "  Set DEVSHELL_OFFLINE=1 to force-skip the binary cache for this launch"
        echo ""
        echo "devshell list [--refresh/-r]"
        echo "  Lists all available devshells, read from the local cache (no network needed)"
        echo "  Pass --refresh or -r to recontact the flake and update the cache (needs network)"
        echo ""
        echo "devshell fhs"
        echo "  Activates the FHS devshell (Filesystem Hierarchy Standard)"
        echo "  The FHS devshell is a non-sandboxed FHS compliant environment with many libs"
        echo "  It may be used to run or compile some programs needing a standard file system"
        echo ""
        echo "devshell warm"
        echo "  Builds every devshell, refreshes the local listing cache, and roots each shell"
        echo "  so the garbage collector never removes it. Run this once while online, and"
        echo "  again whenever a shell definition changes."
        echo ""
        echo "devshell clean"
        echo "  Removes the prebuilt shell roots and runs the garbage collector"
        echo ""
        echo "devshell help"
        echo "  Prints this help"
        echo ""
    }

    print_invalid_option_error() {
        echo -e "\x1b[1;31m$progname: Invalid option -- $*\x1b[0m"
    }

    print_no_option_error() {
        echo -e "\x1b[1;31m$progname: No option specified\x1b[0m"
    }

    # Actually contacts the flake to (re)build the local devshell listing.
    # This is the ONLY place in this script allowed to need network on its own.
    refresh_cache() {
        mkdir -p "$cache_dir"
        if nix flake show --json "$flake_dir" > "$cache_file.tmp"; then
            mv "$cache_file.tmp" "$cache_file"
        else
            rm -f "$cache_file.tmp"
            return 1
        fi
    }

    # Loads $shells_json from the local cache. Only touches the network if no
    # cache exists at all yet (first run before any `devshell warm`).
    load_index() {
        if [[ ! -s "$cache_file" ]]; then
            echo -e "\x1b[33mPas de cache local pour les devshells, interrogation du flake (reseau requis)...\x1b[0m" >&2
            if ! refresh_cache; then
                echo -e "\x1b[1;31m$progname: impossible d'evaluer le flake (pas de cache local, pas de reseau, ou flake casse).\x1b[0m" >&2
                echo "Lancez \`devshell warm\` une fois en ligne pour generer le cache local." >&2
                exit 1
            fi
        fi
        shells_json=$(cat "$cache_file")
    }

    print_shells() {
        echo "$shells_json" | jq -r '.devShells["${system}"] | to_entries[] | "\(.key) \(.value.name)"' | awk '
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
        echo "$shells_json" | jq -r '.devShells["${system}"] | keys | map(split(":")[0]) | unique | .[]'
    }

    get_shells() {
        echo "$shells_json" | jq -r '.devShells["${system}"] | to_entries[] | "\(.key)"'
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

    case "$1" in
        "help")
            print_small_help
            print_help
            ;;
        "list")
            if [[ "$2" == "--refresh" || "$2" == "-r" ]]; then
                refresh_cache || echo -e "\x1b[1;31mEchec du rafraichissement, cache existant conservé (le cas echeant).\x1b[0m" >&2
            fi
            load_index
            print_shells
            ;;
        "fhs")
            nix-shell --option substitute false "$HOME"/anatos/devshells/fhs/shell.nix
            ;;
        "warm")
            cd "$flake_dir"
            nix build .#cache-all-shells
            refresh_cache
            shells_json=$(cat "$cache_file")
            mkdir -p "$roots_dir"
            mkdir -p /nix/var/nix/gcroots/per-user/"$USER" 2>/dev/null
            for s in $(get_shells); do
                echo -e "\x1b[1;32m» warming $s\x1b[0m"
                slug=$(echo "$s" | tr ':' '_')
                if nix print-dev-env "$flake_dir#$s" --profile "$roots_dir/$slug" > /dev/null; then
                    ln -sf "$roots_dir/$slug" /nix/var/nix/gcroots/per-user/"$USER"/devshell-"$slug" 2>/dev/null
                else
                    echo -e "\x1b[1;31m  echec pour $s, il restera dependant du reseau\x1b[0m"
                fi
            done
            ;;
        "clean")
            rm -rf "$roots_dir"
            rm -f /nix/var/nix/gcroots/per-user/"$USER"/devshell-* 2>/dev/null
            rm -f "$flake_dir"/result*
            nix-collect-garbage
            ;;
        * )
            extra_flags=""
            if [[ "$DEVSHELL_OFFLINE" == "1" ]]; then
                extra_flags="--option substitute false"
            fi
            load_index
            prefixes=$(get_prefixes)
            shells=$(get_shells)
            if contains "$1" "$prefixes"; then
                nix develop $extra_flags "$flake_dir#$1:default"
            elif contains "$1" "$shells"; then
                nix develop $extra_flags "$flake_dir#$1"
            else
                print_invalid_option_error "$*"
                print_small_help
                exit 1
            fi
            ;;
    esac
    exit 0
    '';
in
{
    options.my.home.scripts.devshell.enable = lib.mkEnableOption "Enable the devshell script";

	config = lib.mkIf config.my.home.scripts.devshell.enable {
		home.packages = [script pkgs.jq];
	};
}