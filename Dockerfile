FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data

# kubectl
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.19.2/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# skaffold
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v1.15.0/skaffold-linux-amd64
RUN chmod +x skaffold

# helm
RUN curl -Lo helm.tar.gz https://get.helm.sh/helm-v3.3.4-linux-amd64.tar.gz
RUN tar -xzf helm.tar.gz linux-amd64/helm && mv linux-amd64/helm helm
RUN chmod +x helm

# pulumi
RUN curl -Lo pulumi.tar.gz https://get.pulumi.com/releases/sdk/pulumi-v2.11.2-linux-x64.tar.gz
RUN tar -xzf pulumi.tar.gz pulumi/
RUN chmod +x pulumi/*

# vault
RUN curl -Lo vault.zip https://releases.hashicorp.com/vault/1.5.4/vault_1.5.4_linux_amd64.zip
RUN unzip vault.zip
RUN chmod +x vault

# kubeval
RUN curl -Lo kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/0.15.0/kubeval-linux-amd64.tar.gz
RUN tar -xzf kubeval.tar.gz
RUN tar -xzf kubeval.tar.gz kubeval

# iam authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x aws-iam-authenticator

# gcloud sdk
RUN curl -Lo google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-313.0.1-linux-x86_64.tar.gz
RUN tar -xzf google-cloud-sdk.tar.gz

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

RUN pip3 install azure-cli==2.8.0

COPY --from=builder /data/kubectl /usr/local/bin
COPY --from=builder /data/skaffold /usr/local/bin
COPY --from=builder /data/helm /usr/local/bin
COPY --from=builder /data/pulumi/* /usr/local/bin/
COPY --from=builder /data/vault /usr/local/bin
COPY --from=builder /data/kubeval /usr/local/bin
COPY --from=builder /data/aws-iam-authenticator /usr/local/bin

# gcloud sdk
COPY --from=builder /data/google-cloud-sdk/ /google-cloud-sdk
RUN /google-cloud-sdk/install.sh --quiet --path-update true

ENV PULUMI_SKIP_UPDATE_CHECK=true

ENTRYPOINT bash
CMD bash
