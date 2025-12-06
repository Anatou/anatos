{
    description = "A flake containing many development shells";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    outputs = { self, nixpkgs }:
        let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};

        mkPythonDevShell = { version, buildInputs ? [], packages ? [], environment ? {}, use-venv ? true}: let
            libs = with pkgs; [
                stdenv.cc.cc
                openssl
                xorg.libXcomposite
                xorg.libXtst
                xorg.libXrandr
                xorg.libXext
                xorg.libX11
                xorg.libXfixes
                libGL
                libz
                libva
                pipewire
                xorg.libxcb
                xorg.libXdamage
                xorg.libxshmfence
                xorg.libXxf86vm
                libelf
                
                # Required
                glib
                gtk2
                bzip2
                
                libsForQt5.qt5.qtwayland

                # Without these it silently fails
                xorg.libXinerama
                xorg.libXcursor
                xorg.libXrender
                xorg.libXScrnSaver
                xorg.libXi
                xorg.libSM
                xorg.libICE
                gnome2.GConf
                nspr
                nss
                cups
                libcap
                SDL2
                libusb1
                dbus-glib
                ffmpeg
                # Only libraries are needed from those two
                libudev0-shim
                
                # Verified games requirements
                xorg.libXt
                xorg.libXmu
                libogg
                libvorbis
                SDL
                SDL2_image
                glew110
                libidn
                tbb
                
                # Other things from runtime
                flac
                freeglut
                libjpeg
                libpng
                libpng12
                libsamplerate
                libmikmod
                libtheora
                libtiff
                pixman
                speex
                SDL_image
                SDL_ttf
                SDL_mixer
                SDL2_ttf
                SDL2_mixer
                libappindicator-gtk2
                libdbusmenu-gtk2
                libindicator-gtk2
                libcaca
                libcanberra
                libgcrypt
                libvpx
                librsvg
                xorg.libXft
                libvdpau
                pango
                cairo
                atk
                gdk-pixbuf
                fontconfig
                freetype
                dbus
                alsa-lib
                expat
                # Needed for electron
                libdrm
                mesa
                libxkbcommon
            ];
        in
        pkgs.mkShell {
            name = "python${version}";

            buildInputs = buildInputs;
            packages = packages;

            env = {
                SH = "zsh";
                DEVSHELL = "python${version}";
                LD_LIBRARY_PATH= "${pkgs.lib.makeLibraryPath libs}";
            } // environment;
            shellHook = let 
                venv-setup = if use-venv then
                ''
                if [ ! -d ./.venv ]; then 
                    echo "There is no python virtual environment in this directory, would you like to create one ?"
                    echo "You can start a python devshell with no virtual environment with the python-no-venv option"
                    read -p "(y/n) > " choice
                    case "$choice" in
                        y|Y ) python -m venv .venv;;
                        n|N ) echo "Exiting devshell"; exit;;
                        * ) echo "Invalid choice, exiting"; exit;;
                    esac
                fi
                ''
                else "";
            in
            ''
            ${venv-setup}
            source .venv/bin/activate
            exec $SH
            deactivate
            '';
        };

        mkFHSDevShell = { devshellTitle, packages ? []}: pkgs.buildFHSEnv {
            name = "${devshellTitle}";
            targetPkgs = pkgs: (packages);
            runScript = pkgs.writeTextFile {
                name = "startFHS";
                executable = true;
                text = ''
                    zsh
                '';

            };
        };

        {
        devShells.${system} = {
            imports = [ ./zsh-devshells.nix ];

            #c = mkZshDevShell {
            #    devshellTitle = "c";
            #    packages = with pkgs; [
            #        libgcc
            #        cmake
            #        clang-tools
            #        gdb
            #        valgrind-light
            #    ];
            #};
            #java = mkZshDevShell {
            #    devshellTitle = "java";
            #    packages = with pkgs; [
            #        jdk
            #        maven
            #        gradle
            #    ];
            #};

            testFHS = mkFHSDevShell {
                devshellTitle = "fhs-shell";
                packages = with pkgs; [
                    python313
                    glibc
                    gcc
                    libgcc
                    gnumake
                    cmake
                    zlib
                    extra-cmake-modules
                ];
            };
        };
    };
}
