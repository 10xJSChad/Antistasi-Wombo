#!/bin/sh
# check if addon name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <addon|all>"
    exit 1
fi

proton="proton"
addonbuilder="/custom/media/1TB_EXT4_SSD/SteamLibrary/steamapps/common/Arma 3 Tools/AddonBuilder/AddonBuilder.exe"
addon="$(pwd)/A3A/addons/$1"
output="$(pwd)/build/@A3U/addons"

if [ "$1" = "all" ]; then
    for addon in "$(pwd)/A3A/addons/"*; do
        if [ -d "$addon" ]; then
            proton run "$addonbuilder" "$addon" "$output" -packonly -prefix=x\\A3A\\addons\\"$(basename "$addon")"
        fi
    done
    exit 0
fi

# check if addon exists
if [ ! -d "$addon" ]; then
    echo "Addon $addon does not exist"
    exit 1
fi

"$proton" run "$addonbuilder" "$addon" "$output" -packonly -prefix=x\\A3A\\addons\\config_fixes
