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
lint:
	$(vc) build ./src --lint
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

.PHONY: test test-window lint example examples deps raylib docs $(EXAMPLES)
