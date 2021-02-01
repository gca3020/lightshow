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
	cp -a dist/linux_amd64/lightshow ${HOME}/.local/bin/lightshow
	mkdir -p ${HOME}/.config/systemd/user/
	cp -a init/lightshow.service ${HOME}/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user enable lightshow
	systemctl --user start lightshow

uninstall:
	systemctl --user disable lightshow
	systemctl --user stop lightshow
	rm -rf ${HOME}/.config/systemd/user/lightshow.service
	systemctl --user daemon-reload
	rm -f ${HOME}/.local/bin/lightshow

clean: .PHONY
	rm -rf dist