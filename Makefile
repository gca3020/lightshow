.PHONY:

all: build

help:
	@echo "Build:"
	@echo "  make build             - Build"
	@echo "  make clean             - Clean build folder"
	@echo "  make install           - Install"
	@echo "  make uninstall         - Uninstall"

build: clean
	mkdir -p dist/linux_amd64
	go build \
		-o dist/linux_amd64/lightshow \
		main.go

install:
	rm -f /usr/local/bin/lightshow
	cp -a dist/linux_amd64/lightshow /usr/local/bin/lightshow
	mkdir -p /usr/local/lib/systemd/system
	cp -a init/lightshow.service /usr/local/lib/systemd/system/
	systemctl daemon-reload
	systemctl enable lightshow
	systemctl start lightshow

uninstall:
	systemctl disable lightshow
	systemctl stop lightshow
	rm -rf /usr/local/lib/systemd/system/lightshow.service
	systemctl daemon-reload
	rm -f /usr/local/bin/lightshow

clean: .PHONY
	rm -rf dist