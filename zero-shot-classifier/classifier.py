import cherrypy
import json
from transformers import pipeline


classifier = pipeline("zero-shot-classification")

class Classifier(object):

    @cherrypy.expose
    @cherrypy.tools.json_out()
    def classify(self, sequence):

        candidate_labels = ["politics", "public health", "economics"]

        return classifier(sequence, candidate_labels, multi_class=True)

if __name__ == '__main__':
    cherrypy.config.update({'server.socket_host': '0.0.0.0', 'server.socket_port': 8080})
    cherrypy.quickstart(Classifier())
