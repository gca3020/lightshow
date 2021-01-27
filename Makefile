.PHONY:

help:
	@echo "Build:"
	@echo "  make build             - Build"
	@echo "  make build-snapshot    - Build snapshot"
	@echo "  make build-simple      - Build (using go build, without goreleaser)"
	@echo "  make release           - Create a release"
	@echo "  make release-snapshot  - Create a test release"
	@echo "  make clean             - Clean build folder"
	@echo "  make install           - Install"

build: .PHONY
	goreleaser build --rm-dist

build-snapshot:
	goreleaser build --snapshot --rm-dist

build-simple: clean
	mkdir -p dist/linux_amd64
	go build \
		-o dist/linux_amd64/lightshow \
		-ldflags \
		"-X main.version=$(shell git describe) -X main.commit=$(shell git rev-parse --short HEAD) -X main.date=$(shell date +%s)" \
		cmd/lightshow/main.go

release:
	goreleaser release --rm-dist

release-snapshot:
	goreleaser release --snapshot --skip-publish --rm-dist

install:
	sudo rm -f /usr/bin/lightshow
	sudo cp -a dist/linux_amd64/lightshow /usr/bin/lightshow


install-deb:
	sudo apt-get purge lightshow || true
	sudo dpkg -i dist/*.deb

clean: .PHONY
	rm -rf dist