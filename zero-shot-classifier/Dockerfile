FROM ubuntu:20.04

# Install package dependencies
RUN apt-get update && apt-get -y install python3 curl build-essential
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

# Install python requirements
RUN apt-get install -y python3-pip
COPY requirements.txt ./
RUN python3 -m pip install --no-cache-dir -r requirements.txt
COPY classifier.py .

EXPOSE 8080

CMD ["python3", "classifier.py"]
