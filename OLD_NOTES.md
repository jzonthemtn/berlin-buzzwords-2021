Stuff in here may not be 100% accurate.

# Continuous LTR Model Training using Flink and Twitter

* Twitter trending hashtags: https://github.com/erikbeebe/flink_twitter_topN
* XgBoost training modeled after: https://github.com/o19s/elasticsearch-learning-to-rank/blob/master/demo/xgboost-demo/xgb.py

## Goal

1. User searches for "Family" movies.
2. Gets back a list of "Family" (`genres`) movies.
3. "Christmas" becomes a trending topic on Twitter.
4. User searches for "Family" movies.
5. Gets back a list of "Family" movies but with Christmas movies at the top.

To make this happen, I need a mapping of what is a "Christmas" movie in the judgments file.

## Elasticsearch

Install Elasticsearch manually:

```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.8.0-amd64.deb
sudo dpkg -i elasticsearch-7.8.0-amd64.deb
```

Set the Elasticsearch config in `/etc/elasticsearch/elasticsearch.yml`:

```shell script
cluster.name: elasticsearch
node.name: node-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
```

Configure the service:

```shell script
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
```

Now install the Elasticsearch LTR plugin:

```
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install http://es-learn-to-rank.labs.o19s.com/ltr-1.1.0-es6.4.1.zip
```

Restart Elasticsearch:

```shell script
sudo systemctl restart elasticsearch.service
```

(All versions: http://es-learn-to-rank.labs.o19s.com/)

## Setting up Index

Get the `hello-ltr` repo.

```shell script
git clone https://github.com/o19s/hello-ltr.git
cd hello-ltr
python3 -m pip install -r requirements.txt
```

Now run the code:

```python
from ltr import download
download()

from ltr.client import ElasticClient
client = ElasticClient()

from ltr.index import rebuild_tmdb
rebuild_tmdb(client)

config = {
    "featureset": {
        "features": [
            {
                "name": "release_year",
                "params": [],
                "template": {
                    "function_score": {
                        "field_value_factor": {
                            "field": "release_year",
                            "missing": 2000
                        },
                        "query": { "match_all": {} }
                    }
                }
            }
        ]
    }
}

from ltr import setup
setup(client, config=config, index='tmdb', featureset='release')

from ltr import years_as_ratings
years_as_ratings.synthesize(client,
                            featureSet='release',
                            classicTrainingSetOut='data/classic-training.txt',
                            latestTrainingSetOut='data/latest-training.txt')

from ltr import train
train(client, trainingInFile='data/latest-training.txt',
      index='tmdb', featureSet='release', modelName='latest')
train(client, trainingInFile='data/classic-training.txt',
      index='tmdb', featureSet='release', modelName='classic')

from ltr.release_date_plot import plot
plot(client)
```

### Elasticsearch Commands

```shell script
curl http://localhost:9200/_cat/indices
curl http://localhost:9200/_mappings/
```

To search for a movie.

```shell script
curl -s -X GET "http://localhost:9200/_search" -H "Content-Type: application/json" -d'
{
    "query": {
        "multi_match" : {
            "query" : "rambo",
            "fields" : ["overview", "tagline"]
        }
    }
}
'
````

 Pipe it to `jq` for formatted json instead of using `?pretty` so it can be parsed:

```shell script
curl -s -X GET "http://localhost:9200/_search" -H "Content-Type: application/json" -d'
{
    "query": {
        "multi_match" : {
            "query" : "rambo",
            "fields" : ["overview", "tagline"]
        }
    }
}
' | jq -r '.hits.hits[]._source.title'
````

## Feature Map Notes

Comments are not allowed in the feature map so I'm adding some notes here.

Format of featmap.txt: `<featureid> <featurename> <q or i or int>\n` :
 - Feature id must be from 0 to number of features, in sorted order.
 - i means this feature is binary indicator feature
 - q means this feature is a quantitative value, such as age, time, can be missing
 - int means this feature is integer value (when int is hinted, the decision boundary will be integer)

References:
* https://github.com/dmlc/xgboost/blob/master/demo/binary_classification/README.md
* https://github.com/o19s/elasticsearch-learning-to-rank/blob/c3d0df16d1cc4354cb3eef259389d3ca1b4ef3ca/demo/xgboost-demo/featmap.txt

## Training Input Notes

Example contents of `xgboost.txt`:

```
1 101:1.2 102:0.03
0 1:2.1 10001:300 10002:400
0 0:1.3 1:0.3
1 0:0.01 1:0.3
0 0:0.2 1:0.3
```

Each line represent a single instance, and in the first line ‘1’ is the instance label, ‘101’ and ‘102’ are feature indices, ‘1.2’ and ‘0.03’ are feature values.
In the binary classification case, ‘1’ is used to indicate positive samples, and ‘0’ is used to indicate negative samples.
We also support probability values in [0,1] as label, to indicate the probability of the instance being positive.

(From https://xgboost.readthedocs.io/en/latest/tutorials/input_format.html)

### Query ID Columns

This is most useful for ranking task, where the instances are grouped into query groups. You may embed query group ID for each instance in the LibSVM file by adding a token of form qid:xx in each row:

```
1 qid:1 101:1.2 102:0.03
0 qid:1 1:2.1 10001:300 10002:400
0 qid:2 0:1.3 1:0.3
1 qid:2 0:0.01 1:0.3
0 qid:3 0:0.2 1:0.3
1 qid:3 3:-0.1 10:-0.3
0 qid:3 6:0.2 10:0.15
```

(From https://xgboost.readthedocs.io/en/latest/tutorials/input_format.html
