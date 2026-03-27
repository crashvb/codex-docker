FROM crashvb/base:24.04-202508010159@sha256:f7b3a015c749980c2427241686134908e4f82e2c0b72688dac37cb59e4e05169 AS parent

FROM ghcr.io/openai/codex-universal:amd64-4b213374574fd025282d7c7118704e6afdaf1864@sha256:990da0a76eaf6e6bcb01b288911b8253eb4558196e8408ef3b776e0dac2f3f58
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:990da0a76eaf6e6bcb01b288911b8253eb4558196e8408ef3b776e0dac2f3f58" \
	org.opencontainers.image.base.name="ghcr.io/openai/codex-universal" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing EJBCA." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/codex-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/codex" \
	org.opencontainers.image.url="https://github.com/crashvb/codex-docker"

# Install packages, download files ...
ENV \
	DEV_ROOT=/workspace \
	LANG=C.UTF-8 \
	LC_ALL=C.UTF-8
COPY --from=parent /sbin/apt-add-repo /sbin/docker-* /sbin/entrypoint /sbin/healthcheck /sbin/
COPY --from=parent /usr/local/lib/entrypoint.sh /usr/local/lib/
# hadolint ignore=DL3013
RUN apt-add-repo "crashvb-server27nw-jammy" https://ppa.launchpadcontent.net/crashvb/server27nw/ubuntu/ main E8D9DE631E0F371CE47339DE636C33BFCD7D1C4F && \
	apt-get update && \
	docker-apt \
		aggregate \
		ansible-core \
		ca-certificates-server27nw \
		gh \
		iproute2 \
		ipset \
		iptables \
		less \
		npm \
		python-is-python3 \
		python3-pip \
		shellcheck \
		shfmt \
		tree \
		xmlstarlet \
		vim \
		yq && \
	npm install --global @openai/codex typescript && \
	PIPX_BIN_DIR=/usr/local/bin pipx install vja && \
	install --directory --group=root --mode=0755 --owner=root "${DEV_ROOT}"

# Configure: bash profile
RUN sed --in-place --expression="/^HISTSIZE/s/1000/9999/" --expression="/^HISTFILESIZE/s/2000/99999/" /root/.bashrc && \
	printf "set -o vi\n" >> /root/.bashrc && \
	printf "PS1='\${debian_chroot:+(\$debian_chroot)}\\\\t \[\\\\033[0;31m\]\u\[\\\\033[00m\]@\[\\\\033[7m\]\h\[\\\\033[00m\] [\w]\\\\n\$ '\n" >> /root/.bashrc && \
	touch ~/.hushlogin

# Configure: profile
RUN printf '%s\n' '#!/bin/sh' 'export VJA_CONFIGDIR=/root/.codex/vja' > /etc/profile.d/vja.sh && \
	chmod 0755 /etc/profile.d/vja.sh

# Configure: entrypoint
# hadolint ignore=SC2174
RUN mkdir --mode=0755 --parents /etc/entrypoint.d/ /etc/healthcheck.d/
COPY entrypoint.codex /etc/entrypoint.d/codex

HEALTHCHECK CMD /sbin/healthcheck

ENTRYPOINT ["/sbin/entrypoint"]
CMD ["/bin/bash"]
