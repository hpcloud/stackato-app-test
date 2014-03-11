.PHONY: conf update test force

ALL_APPS=$(shell (cd apps; ls -1))

default: help

help:
	bin/help

conf: conf/apps.ini

conf/apps.ini: force
	@bin/make-apps-ini

apps:
	mkdir -p $@

update:
	@bin/update-app-repos

test:
	@bin/test-apps

force:
