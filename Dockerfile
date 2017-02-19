FROM library/debian:jessie

RUN apt-get update && \
    apt-get install -y curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TERRAFORM_VERSION 0.8.7
RUN curl -Lo /terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip /terraform.zip -d /usr/local/bin && \
    rm -rf /terraform.zip

COPY ./init.d /opt/init.d
COPY ./terraform /opt/terraform

WORKDIR /opt/terraform
ENTRYPOINT ["/opt/init.d/start.sh"]
