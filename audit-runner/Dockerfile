FROM alpine:3.19

# Install packages
RUN apk add --no-cache bash curl git \
  && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community yq

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl && mv kubectl /usr/local/bin/

# Install ArgoCD CLI
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
  && chmod +x /usr/local/bin/argocd

# Add script and supporting files
WORKDIR /app
COPY scripts/audit-gitops.sh .
COPY scripts/verify-drift.sh .
COPY scripts/drift-report.log .

ENTRYPOINT ["bash", "/app/audit-gitops.sh"]
