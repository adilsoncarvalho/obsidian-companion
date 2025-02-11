# Directories containing Go applications and libraries
CMD_DIR := cmd
INTERNAL_DIR := internal
PKG_DIR := pkg

# Find all subdirectories in CMD_DIR containing a main.go file
APPS := $(shell find $(CMD_DIR) -mindepth 1 -maxdepth 1 -type d -exec test -f {}/main.go \; -print | xargs -n 1 basename)
# Output directory for binaries
BIN_DIR := bin

# Find all Go test files in cmd, internal, and pkg directories
TEST_DIRS := $(CMD_DIR) $(INTERNAL_DIR) $(PKG_DIR)
TEST_FILES := $(shell find $(TEST_DIRS) -type f -name "*_test.go")

# Default target: build all apps
all: $(APPS)

# Rule to build each app
$(APPS):
	@echo "Building $@..."
	@mkdir -p $(BIN_DIR)
	@go build -o $(BIN_DIR)/$@ $(CMD_DIR)/$@/main.go

# Run tests
test:
	@if [ -n "$(TEST_FILES)" ]; then \
		echo "Running tests..."; \
		go test ./$(CMD_DIR)/... ./$(INTERNAL_DIR)/... ./$(PKG_DIR)/... -v; \
	else \
		echo "No test files found."; \
	fi

# Lint Go code using golangci-lint or fallback to go vet
lint:
	@echo "Linting code..."
	@if command -v golangci-lint > /dev/null; then \
		golangci-lint run ./...; \
	else \
		echo "golangci-lint not found, using go vet instead"; \
		go vet ./$(CMD_DIR)/... ./$(INTERNAL_DIR)/... ./$(PKG_DIR)/...; \
	fi

# Format Go code
fmt:
	@echo "Formatting code..."
	@go fmt ./$(CMD_DIR)/... ./$(INTERNAL_DIR)/... ./$(PKG_DIR)/...

# Clean up compiled binaries
clean:
	@rm -rf $(BIN_DIR)

.PHONY: all clean test lint fmt $(APPS)
