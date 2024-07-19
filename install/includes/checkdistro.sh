distro=""
if [ -z "$1" ]; then
    if [ -f /etc/fedora-release ] || [ -f /etc/nobara-release ] || [ -f /etc/nobara ]; then
        distro="fedora"
    elif [ -f /etc/arch-release ]; then
        distro="arch"
    fi
else
    case "$1" in
        "fedora"|"nobara")
            distro="fedora"
            ;;
        "arch")
            distro="arch"
            ;;
    esac
fi

if [ -z "$distro" ] ;then
    echo "ERROR: Your Linux distribution is not supported."
    exit 1
fi

echo "$distro" > dotfiles/.config/ml4w/settings/distro