# Fine-tuning MNLI Model

Create environment:

```
python3 -m venv venv
source ./venv/bin/activate
```

Install transformers from source and dependencies:

```
python3 -m pip install git+https://github.com/huggingface/transformers
python3 -m pip install wheel datasets torch scipy sklearn
```

Clone transformers for the `run_glue.py` script.

```
git clone https://github.com/huggingface/transformers.git
cd transformers
```

Run the training script.
