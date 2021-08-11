######## BUILDER ########

# Set the base image
FROM steamcmd/steamcmd:ubuntu-18 as builder

# Set environment variables
ENV USER root
ENV HOME /root/installer

# Set working directory
WORKDIR $HOME

# Install prerequisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl tar unzip wget

# Donload and unpack installer
RUN curl http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
    --output steamcmd.tar.gz --silent
RUN tar -xvzf steamcmd.tar.gz && rm steamcmd.tar.gz

######## INSTALL ########

# Set the base image
FROM alpine:3

# Set environment variables
ENV USER root
ENV HOME /root

# Set working directory
WORKDIR $HOME

# Install prerequisites
RUN apk update \
    && apk add --no-cache bash \
    && rm -rf /var/cache/apk/*

# Copy steamcmd files from builder
COPY --from=builder /root/installer/steamcmd.sh /usr/lib/games/steam/
COPY --from=builder /root/installer/linux32/steamcmd /usr/lib/games/steam/
COPY --from=builder /usr/games/steamcmd /usr/bin/steamcmd

# Copy required files from builder
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /lib/i386-linux-gnu /lib/
COPY --from=builder /root/installer/linux32/libstdc++.so.6 /lib/

# copy Rust Startup Script
COPY ./vanilla.sh /home/steam

# Update SteamCMD and verify latest version Add-Update Rust
RUN steamcmd +login anonymous +force_install_dir ./rust_server/ +app_update 258550 +quit

# Install Oxide
#RUN wget https://github.com/OxideMod/Snapshots/raw/master/Oxide-Rust_Linux.zip
#RUN unzip Oxide-Rust_Linux.zip
#RUN chmd u+x CSharpCompiler

# Set default command
#ENTRYPOINT ["steamcmd"]
#CMD ["+help", "+quit"]
ENTRYPOINT [ "/home/steam/vanilla.sh" ]