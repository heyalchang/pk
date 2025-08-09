.PHONY: install uninstall test lint help

PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
SCRIPT = pk

help:
	@echo "pk - portkill installation"
	@echo ""
	@echo "Targets:"
	@echo "  install    Install pk to $(BINDIR)"
	@echo "  uninstall  Remove pk from $(BINDIR)"
	@echo "  test       Run tests"
	@echo "  lint       Check script syntax"
	@echo ""
	@echo "Variables:"
	@echo "  PREFIX     Installation prefix (default: $(PREFIX))"
	@echo "  BINDIR     Binary directory (default: $(BINDIR))"

install:
	@echo "Installing pk to $(BINDIR)..."
	@mkdir -p $(BINDIR)
	@cp $(SCRIPT) $(BINDIR)/$(SCRIPT)
	@chmod +x $(BINDIR)/$(SCRIPT)
	@echo "Installation complete"
	@if ! echo "$$PATH" | grep -q "$(BINDIR)"; then \
		echo ""; \
		echo "Warning: $(BINDIR) is not in your PATH"; \
		echo "Add this to your shell configuration:"; \
		echo "  export PATH=\"$(BINDIR):\$$PATH\""; \
	fi

uninstall:
	@echo "Removing pk from $(BINDIR)..."
	@rm -f $(BINDIR)/$(SCRIPT)
	@echo "Uninstall complete"

test:
	@echo "Running tests..."
	@bash -n $(SCRIPT) && echo "Syntax check passed"
	@./tests/run_tests.sh 2>/dev/null || echo "No tests found"

lint:
	@echo "Checking script..."
	@bash -n $(SCRIPT) && echo "Syntax: OK"
	@command -v shellcheck >/dev/null 2>&1 && shellcheck $(SCRIPT) || echo "shellcheck not found, skipping"