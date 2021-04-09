FROM ubuntu:20.04

RUN apt-get update && apt-get -y install python3 curl build-essential

RUN python3 -m pip install git+https://github.com/huggingface/transformers
RUN python3 -m pip install wheel datasets torch scipy sklearn

RUN git clone https://github.com/huggingface/transformers.git /tmp/transformers
COPY train.sh /tmp/transformers/

CMD ["/tmp/transformers/train.sh"]
