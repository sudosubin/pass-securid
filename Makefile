PREFIX ?= /usr/local
MAN_DIR ?= $(PREFIX)/man
PASS_EXTENSION_DIR ?= $(PREFIX)/lib/password-store/extensions
BASH_COMPLETION_DIR ?= /etc/bash_completion.d

all:
	@echo "pass-securid is a bash script and does not need to be built."
	@echo "Try running \"make install\" instead."

install:
	install -d "$(MAN_DIR)/man1/"
	install -m 0644 src/pass-securid.1 "$(MAN_DIR)/man1/pass-securid.1"
	install -d "$(PASS_EXTENSION_DIR)/"
	install -m 0755 src/securid.bash "$(PASS_EXTENSION_DIR)/securid.bash"
	install -d "$(BASH_COMPLETION_DIR)/"
	install -m 0644 src/pass-securid.completion.bash "$(BASH_COMPLETION_DIR)/pass-securid"
	@echo "pass-securid is installed succesfully"

uninstall:
	rm -fv \
		"$(MAN_DIR)/pass-securid.1" \
		"$(PASS_EXTENSION_DIR)/securid.bash" \
		"$(BASH_COMPLETION_DIR)/pass-securid"

.PHONY: all install uninstall
