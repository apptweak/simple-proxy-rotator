REGISTRY_HOST=ghcr.io
USERNAME=apptweak
PROJECT=simple-proxy-rotator
VERSION := $(shell cat VERSION)
IMAGE_NAME=$(REGISTRY_HOST)/$(USERNAME)/$(PROJECT)
IMAGE=$(IMAGE_NAME):$(VERSION)

build:
	docker build -f Dockerfile --platform "linux/x86_64" --tag "$(IMAGE)" --tag "$(IMAGE_NAME):stable" .
	# read --local --silent --prompt "Docker account's password: " passwd
	# echo "$passwd" | docker login --username apptweakci --password-stdin
	# gh auth token | docker login --username apptweakci --password-stdin ${IMAGE}
	docker push "$(IMAGE)"
	docker push "$(IMAGE_NAME):stable"

