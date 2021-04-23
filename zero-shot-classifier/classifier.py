import cherrypy
import json
import os
from transformers import pipeline


MODEL = os.getenv('NLI_MODEL')
print("Using model " + str(MODEL))

classifier = pipeline("zero-shot-classification", model=MODEL)

class Classifier(object):

    @cherrypy.expose
    @cherrypy.tools.json_in()
    @cherrypy.tools.json_out()
    def classify(self):

        sequence = cherrypy.request.json['sequence']
        candidate_labels = cherrypy.request.json['labels']

        return classifier(sequence, candidate_labels, multi_class=True)

    @cherrypy.expose
    def status(self):
      return "alive"

if __name__ == '__main__':
    cherrypy.config.update({'server.socket_host': '0.0.0.0', 'server.socket_port': 8080})
    cherrypy.quickstart(Classifier())
