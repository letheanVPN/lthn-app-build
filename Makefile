
all: help

clean: ## Docker System Prune
	docker system prune --all

builder: ## Builds lthn/build
	docker build -t lthn/build -f Dockerfile build-src

compile: ## Builds lthn/build:compile
	docker build -t lthn/build:compile -f base.Dockerfile .

sources-linux:
	docker build --build-arg BUILD=linux  -t lthn/build:sources-linux -f build-conf/compile/sources.Dockerfile build-src

sources-win:
	docker build --build-arg BUILD=win  -t lthn/build:sources-win -f build-conf/compile/sources.Dockerfile build-src

sources-osx:
	docker build --build-arg BUILD=osx  -t lthn/build:sources-osx -f build-conf/compile/sources.Dockerfile build-src

depends-x86_64-apple-darwin11: ## Macos
	docker build --build-arg BUILD=x86_64-apple-darwin11  -t lthn/build:depends-x86_64-apple-darwin11 -f build-conf/compile/depends.Dockerfile build-src

depends-x86_64-unknown-freebsd: ## x86_64 Freebsd
	docker build --build-arg BUILD=x86_64-unknown-freebsd -t lthn/build:depends-x86_64-unknown-freebsd -f build-conf/compile/depends.Dockerfile build-src

depends-x86_64-unknown-linux-gnu: ## x86_64 Linux
	docker build --build-arg BUILD=x86_64-unknown-linux-gnu -t lthn/build:depends-x86_64-unknown-linux-gnu -f build-conf/compile/depends.Dockerfile build-src

depends-i686-pc-linux-gnu: ## i686 Linux
	docker build --build-arg BUILD=i686-pc-linux-gnu -t lthn/build:depends-i686-pc-linux-gnu -f build-conf/compile/depends.Dockerfile build-src

depends-x86_64-w64-mingw32: ## Windows 64
	docker build --build-arg BUILD=x86_64-w64-mingw32 -t lthn/build:depends-x86_64-w64-mingw32 -f build-conf/compile/depends.Dockerfile build-src

depends-i686-w64-mingw32: ## Windows 32
	docker build --build-arg BUILD=i686-w64-mingw32 -t lthn/build:depends-i686-w64-mingw32 -f build-conf/compile/depends.Dockerfile build-src

depends-arm-linux-gnueabihf: ## ARM 32
	docker build --build-arg BUILD=arm-linux-gnueabihf -t lthn/build:depends-arm-linux-gnueabihf -f build-conf/compile/depends.Dockerfile build-src

depends-aarch64-linux-gnu: ## ARM 64
	docker build --build-arg BUILD=aarch64-linux-gnu -t lthn/build:depends-aarch64-linux-gnu -f build-conf/compile/depends.Dockerfile build-src

depends-riscv64-linux-gnu: ## riscv64
	docker build --build-arg=BUILD=riscv64-linux-gnu -t lthn/build:depends-riscv64-linux-gnu -f build-conf/compile/depends.Dockerfile build-src

wallet-linux-base:
	docker build -t lthn/build:wallet-linux-base -f build-conf/wallet/linux/base.Dockerfile .

wallet-lib-linux-utils:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-linux-utils -f=build-conf/wallet/linux/utils.Dockerfile .

wallet-lib-linux-boost:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-linux-boost -f=build-conf/wallet/linux/boost.Dockerfile .

wallet-lib-linux-fontconfig:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-linux-fontconfig -f=build-conf/wallet/linux/fontconfig.Dockerfile .

wallet-lib-linux-cmake:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-linux-cmake -f=build-conf/wallet/linux/cmake.Dockerfile .

wallet-lib-linux-libx:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-linux-libx -f=build-conf/wallet/linux/libx.Dockerfile .

wallet-windows-base:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-windows-base -f=build-conf/wallet/windows/base.Dockerfile .

wallet-lib-windows-cmake:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-windows-cmake -f=build-conf/wallet/windows/cmake.Dockerfile .

wallet-lib-windows-libx:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-windows-libx -f=build-conf/wallet/windows/libx.Dockerfile .

wallet-lib-windows-qt:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-lib-windows-qt -f=build-conf/wallet/windows/qt.Dockerfile .


wallet-linux:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-linux -f=build-conf/wallet/linux.Dockerfile .

wallet-windows:
	docker build --build-arg THREADS=20 -t=lthn/build:wallet-windows -f=build-conf/wallet/windows.Dockerfile .

wallet-android:
	docker build -t lthn/build:wallet-android -f build-conf/wallet/android.Dockerfile .


help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m make %-30s\033[0m %s\n", $$1, $$2}'