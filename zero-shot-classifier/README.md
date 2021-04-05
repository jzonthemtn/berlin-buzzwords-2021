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
