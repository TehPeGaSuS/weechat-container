# SPDX-FileCopyrightText: 2021-2026 Sébastien Helleu <flashcode@flashtux.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

BUILDER ?= docker
VERSION ?= latest
IMAGE ?= weechat

.PHONY: all debian debian-slim alpine alpine-slim

all: debian

all-images: debian debian-slim alpine alpine-slim

debian:
	./build.py -b "$(BUILDER)" -d "debian" "$(VERSION)"

debian-slim:
	./build.py -b "$(BUILDER)" -d "debian" --slim "$(VERSION)"

alpine:
	./build.py -b "$(BUILDER)" -d "alpine" "$(VERSION)"

alpine-slim:
	./build.py -b "$(BUILDER)" -d "alpine" --slim "$(VERSION)"

test-container:
	"$(BUILDER)" run "$(IMAGE)" weechat --version
	"$(BUILDER)" run "$(IMAGE)" weechat-headless --version

lint: flake8 pylint mypy bandit

flake8:
	flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 . --count --exit-zero --max-complexity=10 --statistics

pylint:
	pylint build.py

mypy:
	mypy --strict build.py

bandit:
	bandit build.py
