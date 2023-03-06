# Post-install calico updates

See also: https://github.com/onedr0p/flux-cluster-template/issues/321

```shell
kubectl patch installation default --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch installation default --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch installation default --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch podsecuritypolicy tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch podsecuritypolicy tigera-operator --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch podsecuritypolicy tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch -n tigera-operator deployment tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch -n tigera-operator deployment tigera-operator --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch -n tigera-operator deployment tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch -n tigera-operator serviceaccount tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch -n tigera-operator serviceaccount tigera-operator --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch -n tigera-operator serviceaccount tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch clusterrole tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch clusterrole tigera-operator --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch clusterrole tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch clusterrolebinding tigera-operator tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch clusterrolebinding tigera-operator tigera-operator --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
kubectl patch clusterrolebinding tigera-operator tigera-operator --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
```

Optionally:

```shell
kubectl patch apiserver default --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-name": "tigera-operator"}}}'
kubectl patch apiserver default --type=merge -p '{"metadata": {"annotations": {"meta.helm.sh/release-namespace": "tigera-operator"}}}'
kubectl patch apiserver default --type=merge -p '{"metadata": {"labels": {"app.kubernetes.io/managed-by": "Helm"}}}'
```
