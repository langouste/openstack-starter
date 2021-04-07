FROM alpine:3.13

RUN apk add --update git terraform ansible bash openssh py3-pip

# setup.py requierments during openstack installation
RUN apk add gcc python3-dev musl-dev linux-headers

WORKDIR /root

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN rm -rf requirements.txt .cache
