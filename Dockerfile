FROM archlinux:base-devel

# Install requirements
RUN pacman --noconfirm -Syu sudo openssh git vim nano

# Set up ssh
RUN sudo ssh-keygen -A

# Run ssh on startup
ENTRYPOINT ["/bin/sh","-c","sudo /usr/sbin/sshd;/bin/sh"]

# Give all wheel users passwordless root access
RUN sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers

# Create users
ARG USERS_KEYS
COPY users /usr/bin/generate-users
RUN /usr/bin/generate-users "$USERS_KEYS"

# Install AUR packages
ARG AUR_PACKAGES="minecraft-server forge-server"
COPY install-aur /usr/bin/install-aur
RUN /usr/bin/install-aur "$USERS_KEYS" $AUR_PACKAGES
