FROM docker:stable as builder
RUN apk add curl
RUN apk add tar
WORKDIR /data
RUN curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN curl -Lo skaffold https://github.com/GoogleContainerTools/skaffold/releases/download/v0.12.0/skaffold-linux-amd64
RUN chmod +x skaffold
RUN curl -Lo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v1.0.6/kustomize_1.0.6_linux_amd64
RUN chmod +x kustomize
RUN curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz
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
