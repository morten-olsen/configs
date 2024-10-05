if [ ! -d "$ROOT/.venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $ROOT/.venv
    source $ROOT/.venv/bin/activate
    pip install -r $ROOT/requirements.txt
	touch .venv/touchfile
else
    source $ROOT/.venv/bin/activate
fi
