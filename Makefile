PROJECT = simple-proxy-rotator
ID = apptweak/${PROJECT}
ECR_REPO = ghcr.io
TAG_VERSION := v$(shell cat VERSION)

all: build push

build:
	docker build --platform linux/x86_64 --tag ${ECR_REPO}/${ID}:${TAG_VERSION} .

push:
	read --local --silent --prompt "Docker account's password: " gh_pat
	echo "${gh_pat}"
	# echo "${gh_pat}" | docker login "${ECR_REPO}" --username apptweakci --password-stdin
	# docker push ${ECR_REPO}/${ID}:${TAG_VERSION}

run:
	docker run \
		--volume $(pwd):/app \
		--workdir /app \
		--interactive \
		--tty \
		${ID}:latest \
		bash
