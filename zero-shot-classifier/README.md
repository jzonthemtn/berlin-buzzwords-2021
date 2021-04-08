# Zero-Shot Classifier

Install the dependencies:

`python3 -m pip install -r requirements.txt`

Run the classifer service. This will download the model if it does not exist locally.

`python3 classifier.py`

Send a request:

`curl -X POST http://localhost:8080/classify -d sequence="Who are you voting for in 2020?"``

Result will be a JSON object like:

```
{"sequence": "Who are you voting for in 2020?", "labels": ["politics", "public health", "economics"], "scores": [0.9720696210861206, 0.03248703107237816, 0.006164489313960075]}
```

## Fine-tuning

Take [distilbert-base-uncased](https://huggingface.co/distilbert-base-uncased) and fine-tune it on [MultiNLI](https://cims.nyu.edu/~sbowman/multinli/).

See https://huggingface.co/transformers/v2.7.0/examples.html#mnli.

```
export GLUE_DIR=/path/to/glue

python -m torch.distributed.launch \
    --nproc_per_node 8 run_glue.py \
    --model_type bert \
    --model_name_or_path bert-base-cased \
    --task_name mnli \
    --do_train \
    --do_eval \
    --do_lower_case \
    --data_dir $GLUE_DIR/MNLI/ \
    --max_seq_length 128 \
    --per_gpu_train_batch_size 8 \
    --learning_rate 2e-5 \
    --num_train_epochs 3.0 \
    --output_dir output_dir
```    
