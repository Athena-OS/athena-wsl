FROM athenaos/base:latest

RUN pacman -Syu --noconfirm --needed \
accountsservice dialog gcc inetutils make man-db man-pages most nano nbd net-tools netctl pv rsync sudo timelineproject-hg vi \
eza pocl \
noto-fonts-cjk noto-fonts-emoji ttf-jetbrains-mono ttf-jetbrains-mono-nerd \
asciinema bash-completion bashtop bat bc blesh-git cmatrix cowsay cron downgrade espeakup figlet-fonts file-roller fortune-mod git imagemagick jdk-openjdk jq lib32-glibc lolcat lsd myman nano-syntax-highlighting ncdu neofetch nyancat openbsd-netcat openvpn orca p7zip paru pfetch polkit powershell-bin python-pywhat reflector sl superbfetch-git textart tidy tk tmux toilet-fonts tree ufw unzip vim vnstat wget which xclip xcp xmlstarlet zoxide \
openssl shellinabox \
athena-neofetch-config athena-nvim-config athena-powershell-config athena-system-config athena-tmux-config athena-vim-config athena-win-kex athena-zsh htb-toolkit nist-feed \
armcord-git athena-alacritty-config athena-cyber-hub athena-firefox-config athena-gnome-config athena-kitty-config athena-samurai-theme athena-theme-tweak athena-vscodium-themes athena-welcome bless chatgpt-desktop-bin cyberchef-electron edex-ui-bin gtk-engine-murrine hexedit networkmanager networkmanager-openvpn octopi onionshare reflector torbrowser-launcher \
check imlib2 tigervnc libxrandr fuse libfdk-aac nasm xorg-server xorg-server-devel xorgxrdp xrdp

RUN systemctl enable xrdp.service

# Install the workaround for:
# - https://github.com/neutrinolabs/xrdp/issues/1684
# - GNOME Keyring asks for password at login.
RUN cd /tmp && \
  wget --progress=dot:giga 'https://github.com/matt335672/pam_close_systemd_system_dbus/archive/f8e6a9ac7bdbae7a78f09845da4e634b26082a73.zip' && \
  unzip f8e6a9ac7bdbae7a78f09845da4e634b26082a73.zip && \
  cd /tmp/pam_close_systemd_system_dbus-f8e6a9ac7bdbae7a78f09845da4e634b26082a73 && \
  make install && \
  rm -fr /tmp/pam_close_systemd_system_dbus-f8e6a9ac7bdbae7a78f09845da4e634b26082a73

# Clean Pacman cache
RUN pacman -Scc --noconfirm

# Enable/disable the services.
RUN systemctl enable sshd.service NetworkManager.service && \
  systemctl mask \
  bluetooth.service \
  dev-sda1.device \
  dm-event.service \
  dm-event.socket \
  geoclue.service \
  initrd-udevadm-cleanup-db.service \
  lvm2-lvmpolld.socket \
  lvm2-monitor.service \
  power-profiles-daemon.service \
  systemd-boot-update.service \
  systemd-modules-load.service \
  systemd-network-generator.service \
  systemd-networkd.service \
  systemd-networkd.socket \
  systemd-networkd-wait-online.service \
  systemd-remount-fs.service \
  systemd-udev-settle.service \
  systemd-udev-trigger.service \
  systemd-udevd.service \
  systemd-udevd-control.socket \
  systemd-udevd-kernel.socket \
  udisks2.service \
  upower.service \
  usb-gadget.target \
  usbmuxd.service && \
  systemctl mask --global \
  gvfs-mtp-volume-monitor.service \
  gvfs-udisks2-volume-monitor.service \
  obex.service \
  pipewire.service \
  pipewire.socket \
  pipewire-media-session.service \
  pipewire-pulse.service \
  pipewire-pulse.socket \
  wireplumber.service

# Copy the configuration files and scripts.
COPY rootfs/ /
RUN chmod 755 /usr/local/bin/check-xrdp-rfx.sh

# Workaround for the colord authentication issue.
# See: https://unix.stackexchange.com/a/581353
RUN systemctl enable fix-colord.service

RUN echo -e "\n# Load systemd user\nif ([[ \"\$(systemd-detect-virt)\" == \"wsl\" ]] && [[ \"\$DISPLAY\" == \":0\" ]]); then\n    rm -rf /run/user/1000/wayland-0*\nfi" >> /etc/profile.d/gnome-config.sh
RUN echo "athena-motd" >> /etc/zsh/zprofile
RUN systemd-machine-id-setup
RUN xrdp-keygen xrdp /etc/xrdp/rsakeys.ini

# /etc/skel editing
RUN sed -i 's/\/usr\/bin\/bash/\/usr\/bin\/zsh/g' /usr/share/athena-gnome-config/dconf-shell.ini
RUN sed -i 's/\/usr\/bin\/bash/\/usr\/bin\/zsh/g' /usr/share/applications/*
RUN sed -i 's/Bash/Zsh/g' /usr/share/applications/*
RUN sed -i "s/source ~\/.bash_aliases/source ~\/.bash_aliases\nsource ~\/.bashrc no-repeat-flag/g" /etc/skel/.zshrc
RUN sed -i "s/  neofetch/#  neofetch/g" /etc/skel/.zshrc

# Expose SSH and RDP ports.
EXPOSE 22
EXPOSE 3389

STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
