# Talos

1. create talconfig.yaml
2. talhelper gensecret >talsecret.yaml
3. talhelper genconfig -e talenv.yaml -s talsecret.yaml
4. sops -e -i talenv.yaml
5. sops -e -i talsecret.yaml
6. ./vmware.sh create
7. talosctl bootstrap -e 192.168.14.10 -n 192.168.14.10
8. talosctl config endpoint 192.168.14.254
9. talosctl config node 192.168.14.10 192.168.14.11 192.168.14.12 192.168.14.13 192.168.14.14
10. talosctl kubeconfig .
11. talosctl -n 192.168.14.254 config new vmtoolsd-secret.yaml --roles os:admin
12. kubectl -n kube-system create secret generic talos-vmtoolsd-config --from-file=talosconfig=./vmtoolsd-secret.yaml
13. rm vmtoolsd-secret.yaml
