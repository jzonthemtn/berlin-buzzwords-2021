FROM nvidia/cuda:11.1-devel-ubi8

RUN yum upgrade -y \
        && yum install -y python38 \
        && yum install -y python38-devel git

RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install --upgrade wheel datasets torch scipy sklearn
RUN python3.8 -m pip install git+https://github.com/huggingface/transformers
RUN python3.8 -m pip freeze
RUN python3.8 --version

RUN git clone https://github.com/huggingface/transformers.git /tmp/transformers
RUN cd /tmp/transformers && git checkout tags/v4.5.1

COPY train.sh /tmp/transformers/

CMD ["/tmp/transformers/train.sh"]
