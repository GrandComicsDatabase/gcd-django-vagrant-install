.PHONY: install help load-data

print-%: ; @echo $*=$($*)

help:
	@echo "Usage: make <command> [<args>]"
	@echo ""
	@echo "Common commands:"
	@echo "	help: 		Display this help"
	@echo "	install:	Install and initialize the GCD website"
	@echo "	load-data:	Load your MySQL dump with MYSQL as argument to identify the name of the file. For instance: make load-data MYSQL=2015-04-15.sql"
	@echo "	index-data:	Index all data in Elasticsearch. Warning, indexing data takes time."

install:
	./tools/scripts/init-django.sh
	./tools/scripts/init-db.sh
	status gcd-django | grep -q start || sudo start gcd-django

load-data:
	mysql -u root -pgcd gcd < ${MYSQL}

index-data:
	./tools/scripts/index.sh