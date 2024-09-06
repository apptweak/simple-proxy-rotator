REGISTRY_HOST=ghcr.io
USERNAME=apptweak
PROJECT=simple-proxy-rotator
VERSION := $(shell cat VERSION)
IMAGE=$(REGISTRY_HOST)/$(USERNAME)/$(PROJECT):$(VERSION)

build:
	docker build --platform "linux/x86_64" --tag "$(IMAGE)" -f Dockerfile .
	# read --local --silent --prompt "Docker account's password: " passwd
	# echo "$passwd" | docker login --username apptweakci --password-stdin
	# gh auth token | docker login --username apptweakci --password-stdin ${IMAGE}
	docker push "$(IMAGE)"

