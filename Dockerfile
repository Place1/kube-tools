FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data

# kubectl
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.14.0/bin/linux/amd64/kubectl
RUN chmod +x kubectl

# skaffold
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v0.28.0/skaffold-linux-amd64
RUN chmod +x skaffold

# kustomize
RUN curl -Lo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64
RUN chmod +x kustomize

# helm
RUN curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
RUN tar -xzf helm.tar.gz linux-amd64/helm && mv linux-amd64/helm helm
RUN chmod +x helm

FROM docker:stable
RUN apk add bash
RUN apk add git
RUN apk add openssh
COPY --from=builder /data/kubectl /usr/local/bin
COPY --from=builder /data/skaffold /usr/local/bin
COPY --from=builder /data/helm /usr/local/bin
COPY --from=builder /data/kustomize /usr/local/bin


ENTRYPOINT bash
CMD bash
