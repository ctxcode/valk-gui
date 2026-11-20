vc ?= valk
RAYLIB_VERSION := 6.0

# The directory with libraylib. Left empty, the system's raylib is used, or the one
# `make raylib` downloads into vendor/raylib.
RAYLIB_LIB ?= $(if $(wildcard vendor/raylib/lib),vendor/raylib/lib,)

OS := $(shell uname -s)
ARCH := $(shell uname -m)
ifeq ($(OS),Darwin)
RAYLIB_PACKAGE := macos
RUN := $(if $(RAYLIB_LIB),DYLD_LIBRARY_PATH=$(RAYLIB_LIB),)
LINK := $(if $(RAYLIB_LIB),-L $(RAYLIB_LIB),)
else
RAYLIB_PACKAGE := $(if $(filter aarch64 arm64,$(ARCH)),linux_arm64,linux_amd64)
RUN :=
LINK := $(if $(RAYLIB_LIB),-L $(RAYLIB_LIB) --link-arg -rpath=$(abspath $(RAYLIB_LIB)),)
endif

EXAMPLE ?= hello
EXAMPLES := $(notdir $(wildcard examples/*))

test:
	@mkdir -p debug
	$(vc) build ./tests --test -o ./debug/tests $(LINK)
	$(RUN) ./debug/tests
# Opens hidden windows and checks what raylib draws; needs a display
test-window:
	@mkdir -p debug
	cd tests/window && vman install
	$(vc) build ./tests/window -o ./debug/window-tests $(LINK)
	$(RUN) ./debug/window-tests
# The tests built for Windows and run under Wine; needs raylib's win64 release in RAYLIB_WIN
RAYLIB_WIN ?= vendor/raylib-win/lib
test-win:
	@mkdir -p debug/win
	$(vc) build ./tests --test --target win-x64 -L $(RAYLIB_WIN) -o ./debug/win/tests.exe
	$(vc) build ./tests/window --target win-x64 -L $(RAYLIB_WIN) -o ./debug/win/window-tests.exe
	cp $(RAYLIB_WIN)/raylib.dll ./debug/win/
	cd debug/win && WINEDEBUG=-all wine ./tests.exe
	cd debug/win && mkdir -p debug && WINEDEBUG=-all wine ./window-tests.exe
raylib-win:
	@mkdir -p vendor
	curl -fsSL -o vendor/raylib-win.zip https://github.com/raysan5/raylib/releases/download/$(RAYLIB_VERSION)/raylib-$(RAYLIB_VERSION)_win64_msvc16.zip
	rm -rf vendor/raylib-win vendor/raylib-$(RAYLIB_VERSION)_win64_msvc16
	cd vendor && unzip -q raylib-win.zip && mv raylib-$(RAYLIB_VERSION)_win64_msvc16 raylib-win && rm raylib-win.zip
lint:
	$(vc) build ./src --lint --deny-warnings
example:
	@mkdir -p debug
	$(vc) build ./examples/$(EXAMPLE) -o ./debug/$(EXAMPLE) $(LINK)
	$(RUN) ./debug/$(EXAMPLE)
# Builds every example without running it
examples:
	@mkdir -p debug
	@for e in $(EXAMPLES); do echo "examples/$$e"; $(vc) build ./examples/$$e -o ./debug/$$e $(LINK) || exit 1; done
# `make todo` builds and runs examples/todo
$(EXAMPLES):
	@$(MAKE) --no-print-directory example EXAMPLE=$@
deps:
	vman install
# raylib's own build of the library, from its release page
raylib:
	@mkdir -p vendor
	curl -fsSL -o vendor/raylib.tar.gz https://github.com/raysan5/raylib/releases/download/$(RAYLIB_VERSION)/raylib-$(RAYLIB_VERSION)_$(RAYLIB_PACKAGE).tar.gz
	rm -rf vendor/raylib vendor/raylib-$(RAYLIB_VERSION)_$(RAYLIB_PACKAGE)
	tar -xzf vendor/raylib.tar.gz -C vendor
	mv vendor/raylib-$(RAYLIB_VERSION)_$(RAYLIB_PACKAGE) vendor/raylib
	rm vendor/raylib.tar.gz
docs:
	$(vc) doc . -o docs/api.md --markdown --no-private

.PHONY: test test-window test-win raylib-win lint example examples deps raylib docs $(EXAMPLES)
