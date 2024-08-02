# ----------------------------------------------------- 
# Installation of required packages
# ----------------------------------------------------- 

# Required packages for the installer on Fedora
installer_packages=(
    "wget"
    "unzip"
    "rsync"
    "figlet"
    "git"
    "dnf-plugins-core"
    "python3-dnf-plugins-extras-common"
    "dnf-plugins-extras-tracer"
    "pamixer"
    "python3-dnf-plugins-tracer"
    "python3-dnf-plugin-kickstart"
    "gammastep"
    "brightnessctl"
    "bluez"
    "blueman"
    "cups"
    "tumbler"
    "tumpler-extras"
    "file-roller"
    "flatpak"
)

echo ":: Installing on Fedora/Nobara"
_installPackages "${installer_packages[@]}";

# Install gum
if [[ $(_isInstalled "gum") == 1 ]]; then

echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo yum install --assumeyes gum

else
    echo "gum is already installed.";
fi

# Install NordVPN
if [[ $(_isInstalled "nordvpn") == 1 ]]; then

sudo dnf config-manager --add-repo https://repo.nordvpn.com/yum/nordvpn/centos/x86_64 -y &> /dev/null; then
sudo rpm --import https://repo.nordvpn.com/gpg/nordvpn_public.asc &> /dev/null; then

sudo dnf install nordvpn -y

else
    echo "NordVPN is already installed.";
fi

# Install microsoft edge
if [[$(_isInstalled "microsoft-edge") == 1 ]]; then

sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge -y &> /dev/null; then
sudo dnf config-manager --add-repo https://packages.microsoft.com/fedora/40/prod -y &> /dev/null; then
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &> /dev/null; then

sudo dnf install microsoft-edge -y

else
    echo "Microsoft Edge is already installed"
fi

# Install Duo packages
if [[ $(_isInstalled "duo_unix") == 1 ]]; then

sudo dnf config-manager --add-repo https://pkg.duosecurity.com/Fedora/38/x86_64 -y &> /dev/null; then
sudo rpm --import https://duo.com/DUO-GPG-PUBLIC-KEY.asc &> /dev/null; then

sudo dnf install duo_unix -y

else
    echo "Duo is already installed"
fi

# Add COPR Repos
add_copr_repos() {
    local repos=("$@")
    for repo in "${repos[@]}"; do
        print_message "${GREEN}" "Adding COPR repository $repo..."
        if ! sudo dnf copr enable -y "$repo" &> /dev/null; then
            print_message "${RED}" "Failed to install $repo"
            exit 1
        fi
    done
}

# Adding COPR packages, such as hyprland
add_copr_repos "solopasha/hyprland" "atim/veloren" "atim/airshipper" "atim/xpadneo" "alebastr/sway-extras" "atim/starship" "ryanabx/cosmic-epoch" "phracek/PyCharm" "atim/gping" "atim/bottom" "atim/heroic-games-launcher" "atim/resources" "atim/sniffglue" "atim/rustscan" "atim/gitui" "atim/NetworkManager-wireguard" "atim/breeze"

# Install Flatpak
install_flatpak() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        print_message "${GREEN}" "Installing $package..."
        if ! flatpak install -y "$package" &> /dev/null; then
            print_message "${RED}" "Failed to install $package"
        fi
    done
}

# Flatpaks
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
install_flatpak "md.obsidian.Obsidian" "nl.brixit.wiremapper" "io.github.getnf.embellish" "com.netxms.NetXMSClient" "org.signal.Signal" "io.github.shiftey.Desktop" "org.sqlitebrowser.sqlitebrowser" "com.getpostman.Postman" "com.visualstudio.code" "com.microsoft.Edge" "com.bitwarden.desktop" "org.nmap.Zenmap" "com.github.Anuken.Mindustry" "com.atlauncher.ATLauncher" "com.heroicgameslauncher.hgl" "net.davidotek.pupgui2" "com.tutanota.Tutanota" "com.github.dail8859.NotepadNext"

# GitHub latest release
install_latest_release() {
    local REPO=$1
    local ASSET_PATTERN=$2

    print_message "${GREEN}" "Fetching the latest release data from GitHub for $REPO..."
    local LATEST_RELEASE
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/"$REPO"/releases/latest)

    # Extract the download URL for the desired asset
    local DOWNLOAD_URL
    DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | jq -r ".assets[] | select(.name | endswith(\"$ASSET_PATTERN\")) | .browser_download_url")

    # Check if the download URL was found
    if [[ -z "$DOWNLOAD_URL" ]]; then
        print_message "${RED}" "Error: No asset found with the pattern matching '$ASSET_PATTERN'."
        return 1
    fi

    # Download the file to /tmp directory
    local FILE_PATH="/tmp/latest-$ASSET_PATTERN"
    print_message "${GREEN}" "Downloading the latest release - $REPO"
    wget -q "$DOWNLOAD_URL" -O "$FILE_PATH"

    # Install the package if INSTALL is true and the file is an RPM
    if [[ "$ASSET_PATTERN" == *.rpm ]]; then
        if sudo dnf install "$FILE_PATH" -y &> /dev/null; then
            print_message "${GREEN}" "Installation complete."
        else
            print_message "${RED}" "Installation failed."
            return 1
        fi
    else
        print_message "${YELLOW}" "Downloaded to $FILE_PATH"
    fi
}

# Github Content
install_latest_release "Alex313031/thorium" "AVX2.rpm"
install_latest_release "SpacingBat3/WebCord" "x86_64.rpm"
install_latest_release "TheAssassin/AppImageLauncher" "x86_64.rpm"
install_latest_release "jeffvli/sonixd" "x86_64.AppImage"
mkdir -p ~/.config/easyeffects/output
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"
install_latest_release "ryanoasis/nerd-fonts" "JetBrainsMono.zip"
mkdir -p /home/cmilani/.local/share/fonts/JetBrainsMono/
unzip -o "/tmp/latest-JetBrainsMono.zip" -d /home/cmilani/.local/share/fonts/JetBrainsMono/ &> /dev/null
fc-cache -fv &> /dev/null
install_latest_release "ful1e5/Bibata_Cursor" "Bibata-Modern-Classic.tar.xz"
sudo mkdir -p /usr/share/icons/Bibata-Modern-Classic/
sudo tar -xf "/tmp/latest-Bibata-Modern-Classic.tar.xz" -C /usr/share/icons/
sudo sed -i "s/Inherits=.*/Inherits=Bibata-Modern-Classic/" "/usr/share/icons/default/index.theme"
install_latest_release "EliverLara/Nordic" "Nordic-darker-v40.tar.xz"
mkdir -p /home/cmilani/.local/share/themes/Nordic-darker/
tar -xf "/tmp/latest-Nordic-darker-v40.tar.xz" -C /home/cmilani/.local/share/themes/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/.bashrc -P /home/cmilani/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/kitty.conf -P /home/cmilani/.config/kitty/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/.zshrc -P /home/cmilani/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/starship.toml -P /home/cmilani/.config/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/10-yubikey_lock.rules -P /etc/udev/rules.d/
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/.my-custom-zsh.tar.gz -P /home/cmilani/
tar -xf "/home/cmilani/.my-custom-zsh.tar.gz" --warning=no-unknown-keyword
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
wget https://raw.githubusercontent.com/cameronm77/Fedora/main/aliases.zsh -P /home/cmilani/.oh-my-zsh/custom/
curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sudo sh -s -- --git cantino/mcfly


# Appimages
mkdir -p /home/cmilani/Applications
wget https://github.com/imatefx/nordvpn-gui/releases/download/v1.0.0/nordvpn-gui_1.0.0_amd64.AppImage -P /home/cmilani/Applications/
mv "/tmp/latest-x86_64.AppImage" /home/cmilani/Applications/Sonixd.AppImage




