import cherrypy
import json
from transformers import pipeline


# distilbert-base-uncased-finetuned-mnli
#classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")
classifier = pipeline("zero-shot-classification", model="/home/jeff/berlin-buzzwords-2021/nli/models/MNLI/")


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
