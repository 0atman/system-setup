set -e

# Add a new apt config setting
# to make it always install package dependencies
# without prompting "are you sure?"
function apt_always_yes() {
    if [ -d /etc/apt/apt.conf.d ] && [ ! -e /etc/apt/apt.conf.d/97always-yes ]; then
        echo "~ Creating /etc/apt/apt.conf.d/97always-yes"
        echo 'APT::Get::Assume-Yes "true";' | sudo tee /etc/apt/apt.conf.d/97always-yes
        echo 'APT::Get::force-yes "true";' | sudo tee -a /etc/apt/apt.conf.d/97always-yes
    fi
}

# Update apt only if the list is more than an hour old
function update_apt() {
    now=$(date +%s)
    an_hour_ago=$(expr ${now} - 3600)
    apt_last_updated=$(stat -c '%Y' /var/lib/apt/lists)

    if [ ${an_hour_ago} -gt ${apt_last_updated} ]; then
        echo "~ Updating apt"
        sudo apt update
    fi
}

# Download and install Google Chrome, as best we know how
function install_chrome() {
    echo "~ Installing Google Chrome's dependencies"
    update_apt
    sudo apt install libxss1 libappindicator1 libindicator7
    echo "~ Downloading google chrome .deb package"
    sudo wget -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    echo "~ Installing downloaded package"
    sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
}

# Download and install sublime as best we know how
function install_sublime_3() {
    echo "~ Downloading sublime 3 deb package"
    sudo wget -P /tmp http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3065_amd64.deb
    echo "~ Installing downloaded package"
    sudo dpkg -i /tmp/sublime-text_build-3065_amd64.deb
}

# Install apt packages in the list
# Prompting each time 
function install_apt_packages() {
    install_packages="git python-dev vim byobu ack-grep bzr zsh curl i3"
    apt_update
    for package in ${install_packages}; do
        while true; do
            read -p "Install "${package}"? [Y/n] " install
            case $install in
                [Nn]* ) break;;
                * ) sudo apt install ${package}; break;;
            esac
        done
    done
}

# Install oh my zsh
function install_oh_my_zsh() {
    wget --no-check-certificate http://install.ohmyz.sh -O - | sh && true # this script always returns non-zero
    chsh -s /usr/bin/zsh
}

# Generate a new SSH key, to be copied into Github (at the very least)
function setup_ssh_key() {
    if [ ! -f ${HOME}/.ssh/id_rsa.pub ]; then
        ssh-keygen
    fi

    if [ -f ${HOME}/.ssh/id_rsa.pub ]; then
        echo -e "Here is your public key:\n"
        cat ${HOME}/.ssh/id_rsa.pub
        echo -e "\nPlease copy it into:"
        echo -e "- Github (https://github.com/settings/ssh)"
        echo -e "- Launchpad (e.g.: https://launchpad.net/~0atman/+editsshkeys)"
    fi
}

# Run our setup-config script to setup the user's shell config
function setup_user_config() {
    if [ -f setup-user-config ]; then
        ./setup-user-config.sh
    else
        if [ ! -d ${HOME}/system-setup ]; then
            while true; do
                read -p "Clone the system setup repository into ~/system-setup ? [Y/n] " clone_it
                case $clone_it in
                    [Nn]* ) break;;
                    * ) git clone git@github.com:0atman/system-setup.git ${HOME}/system-setup \
                        || git clone https://github.com/0atman/system-setup.git ${HOME}/system-setup;
                        ${HOME}/system-setup/setup-user-config.sh;
                        break;;
                esac
            done
        fi
    fi
}

run_functions="apt_always_yes install_chrome install_sublime_3 install_apt_packages setup_ssh_key setup_user_config install_oh_my_zsh "

for function_name in ${run_functions}; do
    while true; do
        read -p "Run "${function_name}"? [Y/n] " run_it
        case $run_it in
            [Nn]* ) break;;
            * ) eval ${function_name}; break;;
        esac
    done
done
