#!/usr/bin/env bash
export ROOT="`dirname "$0"`/.."
MACHINE_NAME="$1"; shift

. $ROOT/scripts/with-env.sh

if [ -z "$MACHINE_NAME" ]; then
	echo "Usage: $0 <machine-name>"
	exit 1
fi

echo "Setting up $MACHINE_NAME"
ansible-playbook -i inventory.yml playbooks/setup.yml \
	--connection=local \
	--inventory "$MACHINE_NAME," \
	--limit "$MACHINE_NAME" \
	$@ \
	--ask-become-pass

