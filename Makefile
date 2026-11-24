vc ?= valk

EXAMPLE ?= hello
EXAMPLES := $(notdir $(wildcard examples/*))

test:
	@mkdir -p debug
	$(vc) build ./tests --test -o ./debug/tests
	./debug/tests

# Opens a hidden window and checks rendered pixels (works with SDL_VIDEODRIVER=dummy too)
test-window:
	@mkdir -p debug
	$(vc) build ./tests/window -o ./debug/window-tests
	./debug/window-tests

# The tests built as standalone Windows executables and run under Wine (no SDL3.dll needed)
test-win:
	@mkdir -p debug/win
	$(vc) build ./tests --test --target win-x64 --no-system-libs -o ./debug/win/tests.exe
	$(vc) build ./tests/window --target win-x64 --no-system-libs -o ./debug/win/window-tests.exe
	rm -f ./debug/win/SDL3.dll
	cd debug/win && WINEDEBUG=-all wine ./tests.exe
	cd debug/win && mkdir -p debug && WINEDEBUG=-all wine ./window-tests.exe

lint:
	$(vc) build ./src --lint --deny-warnings

example:
	@mkdir -p debug
	$(vc) build ./examples/$(EXAMPLE) -o ./debug/$(EXAMPLE)
	./debug/$(EXAMPLE)

# Builds every example without running it
examples:
	@mkdir -p debug
	@for e in $(EXAMPLES); do echo "examples/$$e"; $(vc) build ./examples/$$e -o ./debug/$$e || exit 1; done

# `make todo` builds and runs examples/todo
$(EXAMPLES):
	@$(MAKE) --no-print-directory example EXAMPLE=$@

deps:
	vman install

docs:
	$(vc) doc . -o docs/api.md --markdown --no-private

.PHONY: test test-window test-win lint example examples deps docs $(EXAMPLES)
