# Makefile for IDUH Org-Mode Static Site Generator

# Variables
EMACS = emacs
LIB = iduh-org-mode-ssg.el
PUBLIC_DIR = public
POSTS_DIR = tests/posts
SKELETON_DIR = skeleton
PORT = 8000

# Default target
.PHONY: all
all: build

# Build the site
.PHONY: build
build:
	@echo "🚀 Building site..."
	@$(EMACS) --batch -l $(LIB) --eval '(iduh-org-ssg-build-site :skeleton "$(SKELETON_DIR)" :output "$(PUBLIC_DIR)" :posts "$(POSTS_DIR)")'
	@echo "✅ Build complete! Files are in the '$(PUBLIC_DIR)' directory."

# Clean the output directory
.PHONY: clean
clean:
	@echo "🧹 Cleaning output directory..."
	@rm -rf $(PUBLIC_DIR)
	@mkdir -p $(PUBLIC_DIR)
	@echo "✨ Cleaned."

# Serve the site locally
.PHONY: serve
serve: build
	@echo "🌐 Starting local server at http://localhost:$(PORT)..."
	@python3 -m http.server $(PORT) --directory $(PUBLIC_DIR)

# Show help
.PHONY: help
help:
	@echo "IDUH Org-Mode SSG - Command Palette"
	@echo "-----------------------------------"
	@echo "Available commands:"
	@echo "  make build  - Generate the static site (default)"
	@echo "  make clean  - Remove all generated files in /public"
	@echo "  make serve  - Build and start a local web server for preview"
	@echo "  make help   - Show this help message"

