FROM abstruse_builder

COPY init.sh /home/abstruse/init.sh

# install gvm
RUN curl -sL -o /tmp/gvm https://github.com/andrewkroh/gvm/releases/download/v0.1.0/gvm-linux-amd64 \
    && sudo ln -s /tmp/gvm /usr/bin/gvm && sudo chmod 755 /usr/bin/gvm

# install docker
RUN curl -o /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz \
    && mkdir /tmp/docker && tar xzf /tmp/docker.tgz -C /tmp \
    && sudo ln -s /tmp/docker/docker /usr/bin/docker && sudo chmod 755 /usr/bin/docker && rm -rf /tmp/docker.tgz

ENV GOMAXPROCS 1