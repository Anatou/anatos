{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        # Importing the flakes helps pinning the software ?
        c = {
            url = "path:./shells/c";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        python = {
            url = "path:./shells/python";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        rust = {
            url = "path:./shells/rust";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, ... }@inputs:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        DEVSHELLSDIR="$HOME/anatos/devshells/shells";
    in 
    {
        devshell = pkgs.writeShellScriptBin "devshell"
            ''
                declare -A flakes_list_str=()
                declare -A shells_list=()
                shells_list_display=""

                get_shells_list() {
                    local old_pwd="$(pwd)"
                    declare -A flakes=()
                    for dir in "$HOME"/anatos/devshells/shells/*/; do
                        local flake_name=$(basename "$dir")
                        flakes_list+=("$flake_name")
                        cd "$dir"
                        local flake_shells_raw=$(nix flake show --quiet --no-warn-dirty --no-write-lock-file --no-update-lock-file)
                        local flake_shells_splitted=()
                        IFS=$'\n' read -rd ''\'' -a flake_shells_splitted <<< "$flake_shells_raw"
                        local flake_shells=("''\${flake_shells_splitted[@]:3}")
                        local flake_shells_str=""
                        local flake_shells_list_str=" "
                        for i in $(seq 0 ''\${#flake_shells[@]}); do
                            local splitted
                            IFS=':' read -rd ''\'' -a splitted <<< "''\${flake_shells[$i]:27}"
                            flake_shells_list_str="$flake_shells_list_str¤''\${splitted[0]}¤"
                            flake_shells_str="$flake_shells_str''\${flake_shells[$i]:14}\n"
                        done
                        shells_list[$flake_name]="''\${flake_shells_list_str::-2}"
                        flake_shells_str=''\${flake_shells_str::-2}
                        flakes_list_str[$flake_name]="$flake_shells_str"
                        if [ ''\${#flake_shells[@]} -gt 1 ]; then
                            flake_name="$flake_name (''\${#flake_shells[@]} devshells)"
                        else
                            flake_name="$flake_name (''\${#flake_shells[@]} devshell)"
                        fi
                        flakes["$flake_name"]=''\${flake_shells_str}
                    done

                    shells_list_display=""
                    shells_list_display="$shells_list_display''\${#flakes[@]} FLAKES AVAILABLE:\n"
                    for el in "''\${!flakes[@]}"; do
                        shells_list_display="$shells_list_display\x1B[32m$el\x1B[0m\n"
                        shells_list_display="$shells_list_display''\${flakes["''\${el}"]}"
                    done
                    cd "$old_pwd"
                }
                get_shells_list

                print_small_help() {
                    echo -e "\x1b[1;1musage: $0 [devshell] [option] | list | help\x1b[1;0m"
                    echo -e "Activates a predefined development environment (aka devshell).\nProviding the current shell with a targeted version of the software needed."
                }

                print_list() {
                    echo -e "$shells_list_display"
                }

                print_help() {
                    print_small_help
                    echo ""
                    echo -e "Devshells are in flakes. A flake may offer a default devshell,\nwhich can be activated simply by invoking the flake with no options."
                    echo -e "Example: \n$ devshell python \x1b[1;2;3m<- activates the default python devshell\x1b[1;0m"
                    echo -e "To activate a specific devshell, it must be named after the flake."
                    echo -e "Example: \n$ devshell python no-venv \x1b[1;2;3m<- activates the python devshell with no forced venv\x1b[1;0m"
                    echo ""
                    print_list
                }

                if [[ ! -n "$1" ]]; then
                    echo -e "\x1b[1;31mNo option specified\x1b[1;0m"
                    print_small_help
                    exit 1
                fi

                case "$1" in
                    "help") 
                        print_help
                        exit
                        ;;
                    "list") 
                        echo -e "$shells_list_display"
                        ;;
                    * ) 
                        if [[ ''\${!shells_list[@]} =~ $1 ]]; then
                            if [[ ! -n "$2" ]]; then
                                nix develop "$HOME/anatos/devshells/shells/$1/"
                            else
                                list=$(echo -e "''\${shells_list["$1"]}" | sed -r 's/\x1B\[[0-9;]*[A-Za-z]//g')
                                if [[ $list =~ (^|¤)"$2"(¤|$) ]]; then
                                    echo "found"
                                    nix develop "$HOME/anatos/devshells/shells/$1/#$2"
                                else
                                    echo -e "\x1b[1;31mInvalid devshell\x1b[1;0m"
                                    echo -e "Devshells in the \x1B[32m$1\x1B[0m flake are:"
                                    echo -e "''\${flakes_list_str["$1"]}"
                                fi
                            fi
                        else
                            echo -e "\x1b[1;31mInvalid option\x1b[1;0m"
                            print_small_help
                            echo ""
                            print_list
                            exit 1
                        fi
                        ;;
                esac
            '';
        };
}
