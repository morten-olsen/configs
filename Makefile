.PHONY: setup update-requirements .venv lint lint-fix setup-local clean

.venv: .venv/touchfile

.venv/touchfile: requirements.txt
	test -d venv || virtualenv .venv
	. .venv/bin/activate; pip install -Ur requirements.txt
	touch .venv/touchfile

update-requirements:
	. .venv/bin/activate; pip freeze > requirements.txt

install: .venv

lint: .venv
	. .venv/bin/activate; \
	ansible-lint playbooks/*.yml

lint-fix: .venv
	. .venv/bin/activate; \
	ansible-lint --fix playbooks/*.yml

setup-local: .venv
	./scripts/setup-local.sh

clean:
	rm -rf .venv
