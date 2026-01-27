FROM crashvb/base:24.04-202508010159@sha256:f7b3a015c749980c2427241686134908e4f82e2c0b72688dac37cb59e4e05169
ARG org_opencontainers_image_created=undefined
ARG org_opencontainers_image_revision=undefined
ARG python_version=3.12.3
LABEL \
	org.opencontainers.image.authors="Richard Davis <crashvb@gmail.com>" \
	org.opencontainers.image.base.digest="sha256:f7b3a015c749980c2427241686134908e4f82e2c0b72688dac37cb59e4e05169" \
	org.opencontainers.image.base.name="crashvb/base:24.04-202508010159" \
	org.opencontainers.image.created="${org_opencontainers_image_created}" \
	org.opencontainers.image.description="Image containing codex." \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.source="https://github.com/crashvb/codex-docker" \
	org.opencontainers.image.revision="${org_opencontainers_image_revision}" \
	org.opencontainers.image.title="crashvb/codex" \
	org.opencontainers.image.url="https://github.com/crashvb/codex-docker"

# Install packages, download files ...
ENV \
	DEV_ROOT=/development \
	LANG=C.UTF-8 \
	LC_ALL=C.UTF-8
# hadolint ignore=DL3013
RUN docker-apt git-core jq npm xmlstarlet && \
	npm install --global @openai/codex && \
	install --directory --group=root --mode=0755 --owner=root "${DEV_ROOT}"
	
# Configure: codex

# Configure: entrypoint
COPY entrypoint.codex /etc/entrypoint.d/codex
