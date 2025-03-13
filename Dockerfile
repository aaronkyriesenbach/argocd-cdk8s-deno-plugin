FROM denoland/deno:2.2.3

LABEL org.opencontainers.image.source=https://github.com/aaronkyriesenbach/argocd-cdk8s-deno-plugin
LABEL org.opencontainers.image.description="ArgoCD plugin providing fast CDK8s TypeScript synthesis and Helm support"
LABEL org.opencontainers.image.licenses=GPL-3.0-only

ARG HELM_VERSION="v3.17.1"
ARG HELM_FILE_NAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_URL="https://get.helm.sh/${HELM_FILE_NAME}"
ARG YQ_VERSION="v4.45.1"

RUN addgroup argocd --gid 999
RUN adduser --system --uid 999 --gid 999 --shell /bin/bash --home /home/argocd argocd
RUN chown argocd:argocd /deno-dir

WORKDIR /tmp

ADD ${HELM_URL} .

RUN tar xf ${HELM_FILE_NAME}
RUN cp linux-amd64/helm /usr/bin/helm

ADD --chmod=755 "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" /usr/bin/yq
COPY add-helm-repos.sh /usr/bin/add-helm-repos

COPY --chown=argocd:argocd plugin.yaml /home/argocd/cmp-server/config/plugin.yaml