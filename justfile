# Vendor a single chart by name (e.g. just vendor alloy)
vendor name:
    #!/usr/bin/env bash
    set -euo pipefail
    chart_key="{{name}}"
    case "$chart_key" in
        alloy) rm -rf charts/alloy && helm pull --untar -d charts/ --repo https://grafana.github.io/helm-charts --version 1.7.0 alloy ;;
        argo-cd) rm -rf charts/argo-cd && helm pull --untar -d charts/ --version 7.8.4 oci://ghcr.io/argoproj/argo-helm/argo-cd ;;
        cert-manager) rm -rf charts/cert-manager && helm pull --untar -d charts/ --repo https://charts.jetstack.io/ --version v1.20.1 cert-manager ;;
        cert-manager-webhook-hetzner) rm -rf charts/cert-manager-webhook-hetzner && helm pull --untar -d charts/ --repo https://charts.hetzner.cloud/ --version 0.6.7 cert-manager-webhook-hetzner ;;
        cilium) rm -rf charts/cilium && helm pull --untar -d charts/ --repo https://helm.cilium.io/ --version 1.19.2 cilium ;;
        cloudnative-pg) rm -rf charts/cloudnative-pg && helm pull --untar -d charts/ --repo https://cloudnative-pg.github.io/charts --version 0.28.0 cloudnative-pg ;;
        external-dns) rm -rf charts/external-dns && helm pull --untar -d charts/ --repo https://kubernetes-sigs.github.io/external-dns/ --version 1.20.0 external-dns ;;
        forgejo) rm -rf charts/forgejo && helm pull --untar -d charts/ --version 16.2.2 oci://code.forgejo.org/forgejo-helm/forgejo ;;
        harbor) rm -rf charts/harbor && helm pull --untar -d charts/ --repo https://helm.goharbor.io --version 1.18.3 harbor ;;
        hcloud-cloud-controller-manager) rm -rf charts/hcloud-cloud-controller-manager && helm pull --untar -d charts/ --repo https://charts.hetzner.cloud --version 1.30.1 hcloud-cloud-controller-manager ;;
        hcloud-csi) rm -rf charts/hcloud-csi && helm pull --untar -d charts/ --repo https://charts.hetzner.cloud --version 2.20.0 hcloud-csi ;;
        base) rm -rf charts/base && helm pull --untar -d charts/ --repo https://istio-release.storage.googleapis.com/charts --version 1.29.1 base ;;
        cni) rm -rf charts/cni && helm pull --untar -d charts/ --repo https://istio-release.storage.googleapis.com/charts --version 1.29.1 cni ;;
        gateway) rm -rf charts/gateway && helm pull --untar -d charts/ --repo https://istio-release.storage.googleapis.com/charts --version 1.29.1 gateway ;;
        istiod) rm -rf charts/istiod && helm pull --untar -d charts/ --repo https://istio-release.storage.googleapis.com/charts --version 1.29.1 istiod ;;
        keycloakx) rm -rf charts/keycloakx && helm pull --untar -d charts/ --repo https://codecentric.github.io/helm-charts --version 7.1.9 keycloakx ;;
        kube-prometheus-stack) rm -rf charts/kube-prometheus-stack && helm pull --untar -d charts/ --repo https://prometheus-community.github.io/helm-charts --version 69.7.4 kube-prometheus-stack ;;
        loki) rm -rf charts/loki && helm pull --untar -d charts/ --repo https://grafana.github.io/helm-charts --version 6.25.0 loki ;;
        seaweedfs) rm -rf charts/seaweedfs && helm pull --untar -d charts/ --repo https://seaweedfs.github.io/seaweedfs/helm --version 4.18.0 seaweedfs ;;
        tempo) rm -rf charts/tempo && helm pull --untar -d charts/ --repo https://grafana.github.io/helm-charts --version 1.18.1 tempo ;;
        trust-manager) rm -rf charts/trust-manager && helm pull --untar -d charts/ --repo https://charts.jetstack.io/ --version v0.22.0 trust-manager ;;
        vault) rm -rf charts/vault && helm pull --untar -d charts/ --repo https://helm.releases.hashicorp.com --version 0.32.0 vault ;;
        vault-secrets-operator) rm -rf charts/vault-secrets-operator && helm pull --untar -d charts/ --repo https://helm.releases.hashicorp.com --version 1.3.0 vault-secrets-operator ;;
        *) echo "Unknown chart: $chart_key" && exit 1 ;;
    esac
    echo "  vendored $chart_key"

# Vendor all charts from upstream
vendor-all:
    #!/usr/bin/env bash
    set -euo pipefail
    failed=()
    for chart in \
        alloy argo-cd cert-manager cert-manager-webhook-hetzner cilium \
        cloudnative-pg external-dns forgejo harbor \
        hcloud-cloud-controller-manager hcloud-csi \
        base cni gateway istiod \
        keycloakx kube-prometheus-stack loki seaweedfs tempo \
        trust-manager vault vault-secrets-operator; do
        if just vendor "$chart"; then
            :
        else
            failed+=("$chart")
        fi
    done
    if [ ${#failed[@]} -gt 0 ]; then
        echo "Failed: ${failed[*]}"
        exit 1
    fi

# Remove a vendored chart directory
remove name:
    #!/usr/bin/env bash
    set -euo pipefail
    rm -rf "charts/{{name}}"
    echo "  removed charts/{{name}}/"
