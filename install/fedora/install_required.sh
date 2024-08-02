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
    "starship"
    "brightnessctl"
    "bluez"
    "blueman"
    "cups"
    "tumbler"
    "tumpler-extras"
    "file-roller"
    
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
