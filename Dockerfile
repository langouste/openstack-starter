FROM alpine:3.13

RUN apk add --update git
RUN apk add terraform 
RUN apk add ansible
RUN apk add bash
RUN apk add openssh
RUN apk add py3-pip

# setup.py requierments during openstack installation
RUN apk add gcc
RUN apk add python3-dev
RUN apk add musl-dev
RUN apk add linux-headers

WORKDIR /root

COPY requirements.txt .
RUN pip install -r requirements.txt
RUN rm -rf requirements.txt .cache

COPY .env openrc.sh main.tf .terraform.lock.hcl ansible.cfg site.yml test.sh ./
