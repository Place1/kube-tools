FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data

# kubectl
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v0.21.2/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# skaffold
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v1.26.1/skaffold-linux-amd64
RUN chmod +x skaffold

# helm
RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.6.1-linux-amd64.tar.gz
RUN tar -xzf helm.tar.gz linux-amd64/helm && mv linux-amd64/helm helm
RUN chmod +x helm

# pulumi
RUN curl -Lo pulumi.tar.gz https://get.pulumi.com/releases/sdk/pulumi-v3.5.1-linux-x64.tar.gz
RUN tar -xzf pulumi.tar.gz pulumi/
RUN chmod +x pulumi/*

# vault
RUN curl -Lo vault.zip https://releases.hashicorp.com/vault/1.7.3/vault_1.7.3_linux_amd64.zip
RUN unzip vault.zip
RUN chmod +x vault

# iam authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x aws-iam-authenticator

FROM docker:stable
RUN apk add bash
RUN apk add git
RUN apk add openssh
RUN apk add nodejs
RUN apk add npm
RUN apk add curl
RUN apk add libc6-compat
RUN apk add jq
RUN apk add py-pip python3
RUN apk add gcc libffi-dev musl-dev openssl-dev python3-dev
RUN apk add make

RUN pip3 install azure-cli
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

COPY --from=builder /data/kubectl /usr/local/bin
COPY --from=builder /data/skaffold /usr/local/bin
COPY --from=builder /data/helm /usr/local/bin
COPY --from=builder /data/pulumi/* /usr/local/bin/
COPY --from=builder /data/vault /usr/local/bin
COPY --from=builder /data/aws-iam-authenticator /usr/local/bin

ENV PULUMI_SKIP_UPDATE_CHECK=true

ENTRYPOINT bash
CMD bash
