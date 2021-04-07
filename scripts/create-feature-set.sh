#!/bin/bash
HOST="${1:-localhost}"

curl -s -X POST http://$HOST:9200/_ltr/_featureset/more_movie_features -H "Content-Type: application/json" -d'
{
  "validation": {
     "params": {
         "keywords": "rambo"
     },
     "index": "tmdb"
   },
   "featureset": {
     "features": [
         {
             "name": "tmdb_body",
             "params": [
                 "keywords"
                 ],
             "template": {
                 "match": {
                     "overview": "{{keywords}}"
                 }
             }
         },
         {
             "name": "tmdb_title",
             "params": [
                 "keywords"
             ],
             "template": {
                 "match": {
                     "title": "{{keywords}}"
                 }
             }
         }
     ]
   }
}
' | jq
