FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data

# kubectl
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# skaffold
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v0.32.0/skaffold-linux-amd64
RUN chmod +x skaffold

# kustomize
RUN curl -Lo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64
RUN chmod +x kustomize

# helm
RUN curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz
RUN tar -xzf helm.tar.gz linux-amd64/helm && mv linux-amd64/helm helm
RUN chmod +x helm

RUN curl -Lo pulumi.tar.gz https://get.pulumi.com/releases/sdk/pulumi-v0.17.20-linux-x64.tar.gz
RUN tar -xzf pulumi.tar.gz pulumi/
RUN chmod +x pulumi/*

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

RUN helm init --client-only

ENTRYPOINT bash
CMD bash
