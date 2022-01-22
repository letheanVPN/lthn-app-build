.PHONY: build
build:
	docker build --squash --rm -t lthn/build .

.PHONY: push
push: build
	docker login
	docker push lthn/build

.PHONY: release-3.1.0
release-3.1.0:
	docker build --rm  -t lthn/build:release-3.1.0 .

