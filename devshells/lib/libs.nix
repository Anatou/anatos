{pkgs, ...}:
# Some environments expect dynamic libraries to be present in the system
# This is a non-exhaustive list of binaries needed for dynamic linking
# To add them to a shell, LD_LIBRARY_PATH must be set with "${pkgs.lib.makeLibraryPath libs}"; 
with pkgs; [
    stdenv.cc.cc
    # openssl
    libxcomposite
    libxtst
    libxrandr
    libxext
    libx11
    libxfixes
    libGL
    libz
    libva
    pipewire
    libxcb
    libxdamage
    libxshmfence
    libxxf86vm
    libelf
    fontconfig
    
    # Required
    glib
    gtk2
    gtk3
    python313Packages.tkinter
    bzip2
    libgbm
    udev
    zlib

    libsForQt5.qt5.qtwayland
    wayland
    wayland-protocols
    libxkbcommon

    # Without these it silently fails
    libxinerama
    libxcursor
    libxrender
    libxscrnsaver
    libxi
    libsm
    libice
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
    libxt
    libxmu
    libogg
    libvorbis
    SDL
    SDL2_image
    glew_1_10
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
    libxft
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
]