#!/bin/bash
podman build . -t docker.io/meuna/lsdc2:factorio
podman push docker.io/meuna/lsdc2:factorio