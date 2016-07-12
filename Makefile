.PHONY: all build push container clean

IMAGE = janeczku/datadog-rancher-init
VERSION = $(shell cat VERSION)
COMPILE_IMAGE = jaschac/debian-gcc
PAUSE_SRC = pause/pause.c

build:
	docker run -v $$(pwd):/build \
		$(COMPILE_IMAGE) \
		/bin/bash -c "\
			cd /build && \
			mkdir -p bin && \
			gcc -Os -Wall -static -o rootfs/pause $(PAUSE_SRC) && \
			strip rootfs/pause"
	chmod +x rootfs/pause

container:
	docker build -t $(IMAGE):$(VERSION) .
	docker tag $(IMAGE):$(VERSION) $(IMAGE):latest

push:
	docker push $(IMAGE):$(VERSION)

clean:
	rm rootfs/pause