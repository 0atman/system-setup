System setup
===

Config files and scripts to setup my Ubuntu system.

Usage
---

To run the basic setup script directly:

``` bash
bash -c "$(wget -q -O - https://raw.githubusercontent.com/0atman/system-setup/master/setup-system.sh)"
```

Available scripts
---

``` bash
./setup-system.sh  # Install software and setup user config file links
./setup-user-config.sh  # Link config files into user home directory
./remove-user-config.sh  # Remove links to config files from user home directory
```

Config files
---

- .vim - my vim setup - including syntax highlighting and other tweaks
- .tmux.conf - My setup for tmux, the "better than screen" terminal multiplexer
- .bash_profile - mostly empty. Just makes sure .bashrc gets run.
- .globalgitconfig - My git configuration.
- .user-preferences.sublime-settings - My User settings for sublime
