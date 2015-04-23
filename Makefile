.PHONY: install help

print-%: ; @echo $*=$($*)

help:
	@echo "Usage: make <command> [<args>]"
	@echo "Common commands:"
	@echo "	install:	Initialization of the GCD website"
	@echo "	help: 		Display this help"
	
install:
	./tools/scripts/init-django.sh
	./tools/scripts/init-db.sh
	status gcd-django | grep -q start || sudo start gcd-django