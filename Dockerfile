FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data

# kubectl
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# skaffold
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v0.38.0/skaffold-linux-amd64
RUN chmod +x skaffold

# kustomize
RUN curl -Lo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v3.1.0/kustomize_3.1.0_linux_amd64
RUN chmod +x kustomize

# helm
RUN curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.14.3-linux-amd64.tar.gz
RUN tar -xzf helm.tar.gz linux-amd64/helm && mv linux-amd64/helm helm
RUN chmod +x helm

# pulumi
RUN curl -Lo pulumi.tar.gz https://get.pulumi.com/releases/sdk/pulumi-v1.0.0-linux-x64.tar.gz
RUN tar -xzf pulumi.tar.gz pulumi/
RUN chmod +x pulumi/*

# vault
RUN curl -Lo vault.zip https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
RUN unzip vault.zip
RUN chmod +x vault

#kubeval
RUN curl -Lo kubeval.tar.gz https://github.com/instrumenta/kubeval/releases/download/0.14.0/kubeval-linux-amd64.tar.gz
RUN tar -xzf kubeval.tar.gz
RUN tar -xzf kubeval.tar.gz kubeval


FROM docker:stable
RUN apk add bash
RUN apk add git
RUN apk add openssh
RUN apk add nodejs
RUN apk add npm
RUN apk add curl
RUN apk add libc6-compat
RUN apk add jq

COPY --from=builder /data/kubectl /usr/local/bin
COPY --from=builder /data/skaffold /usr/local/bin
COPY --from=builder /data/helm /usr/local/bin
COPY --from=builder /data/kustomize /usr/local/bin
COPY --from=builder /data/pulumi/* /usr/local/bin/
COPY --from=builder /data/vault /usr/local/bin
COPY --from=builder /data/kubeval /usr/local/bin

RUN helm init --client-only
RUN helm repo update

ENTRYPOINT bash
CMD bash
