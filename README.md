# codex-docker

[![version)](https://img.shields.io/docker/v/crashvb/codex/latest)](https://hub.docker.com/repository/docker/crashvb/codex)
[![image size](https://img.shields.io/docker/image-size/crashvb/codex/latest)](https://hub.docker.com/repository/docker/crashvb/codex)
[![linting](https://img.shields.io/badge/linting-hadolint-yellow)](https://github.com/hadolint/hadolint)
[![license](https://img.shields.io/github/license/crashvb/codex-docker.svg)](https://github.com/crashvb/codex-docker/blob/master/LICENSE.md)

## Overview

This docker image contains [codex](https://chatgpt.com/codex), [mcp-searxng](https://github.com/ihor-sokoliuk/mcp-searxng).

## Entrypoint Scripts

### codex

The embedded entrypoint script is located at `/etc/entrypoint.d/codex` and performs the following actions:

1. Configures the universal development environment on first run.
2. Registers a local STDIO MCP server named `searxng` with Codex when `SEARXNG_URL` is nonempty and that server is not already configured.

## Standard Configuration

### SearXNG

`SEARXNG_URL` must be defined in the container to select a SearXNG instance; JSON search must be enabled. Set it to an empty value to skip automatic registration. This does not disable an already configured server.

The registered server runs the installed `mcp-searxng` executable directly; it does not download packages at session startup. Its tools include `searxng_web_search` and `web_url_read`. This adds MCP tools alongside Codex's built-in web search.

Verify registration with `codex mcp get searxng`, or use `/mcp` inside Codex. To change the URL of an existing registration, run:

```bash
codex mcp add searxng --env SEARXNG_URL=https://searxng.server27.info -- mcp-searxng
```

### Container Layout

```
/
└─ development/
```

### Exposed Ports

None.

### Volumes

None.

## Development

[Source Control](https://github.com/crashvb/codex-docker)

