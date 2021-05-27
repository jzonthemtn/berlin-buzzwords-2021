import kfserving
from typing import List, Dict
import base64
import io
import os
from transformers import pipeline


MODEL = os.getenv('NLI_MODEL')
print("Using model " + str(MODEL))
classifier = pipeline("zero-shot-classification", model=MODEL)

class KFServing_ZSC(kfserving.KFModel):
    def __init__(self, name: str):
        super().__init__(name)
        self.name = name
        self.ready = False

    def load(self):
        self.ready = True

    def predict(self, request: Dict) -> Dict:

        inputs = request["instances"]
        sequence = inputs[0]["sequence"]
        candidate_labels = inputs[0]["labels"]

        return classifier(sequence, candidate_labels, multi_class=True)



if __name__ == "__main__":
    model = KFServing_ZSC("zero-shot-classifier")
    model.load()
    kfserving.KFServer(workers=1).start([model])
