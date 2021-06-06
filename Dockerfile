FROM debian:stable-slim
ARG app_user=steam


ADD openttd-start /usr/local/bin
ADD openttd-install /usr/local/bin
RUN apt-get update && \
    apt-get install -y gosu curl bash tar xz-utils unzip && \
    curl -o /usr/bin/yq -L https://github.com/mikefarah/yq/releases/download/v4.9.3/yq_linux_amd64 && \
    groupadd -g 1000 $app_user && \
    useradd -m -d /home/$app_user -g 1000 -u 1000 $app_user && \
    chmod +x /usr/local/bin/openttd-* /usr/bin/yq && \
    mkdir -p /data/autosave /data/newgrf /data/scenario && \
    chown -R 1000:1000 /data

USER $app_user
WORKDIR /home/$app_user
ENV HOME=/home/$app_user
ENV USER=$app_user
RUN /usr/local/bin/openttd-install && \
    mkdir -p $HOME/.local/share/openttd/newgrf && \
    ln -s /data/newgrf $HOME/.local/share/openttd/newgrf/data-newgrf && \
    ln -s /data/save $HOME/.local/share/openttd/save && \
    ln -s /data/scenario $HOME/.local/share/openttd/scenario

EXPOSE 3979/tcp
EXPOSE 3979/udp

ENTRYPOINT [ "/usr/local/bin/openttd-start"]
