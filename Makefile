.PHONY: install help load-data

print-%: ; @echo $*=$($*)

help:
	@echo "Usage: make <command> [<args>]"
	@echo "Common commands:"
	@echo "	install:	Initialization of the GCD website"
	@echo "	help: 		Display this help"
	@echo "	load-data:	Load MySQL dump with MYSQL as argument to locate the. For instance: make load-data MYSQL=2015-04-15.sql"

install:
	./tools/scripts/init-django.sh
	./tools/scripts/init-db.sh
	status gcd-django | grep -q start || sudo start gcd-django

load-data:
	mysql -u root -pgcd gcd < ${MYSQL}