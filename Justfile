
[group("nix-deploy")]
gen-nix-vars:
    nix-instantiate --eval -E "builtins.fromJSON (builtins.readFile ./config.json)" | nixfmt > ./nixos/vars/global.nix

[group("nix-deploy")]
deploy-ciriel addr: gen-nix-vars
    nix run github:nix-community/nixos-anywhere -- \
        --generate-hardware-config nixos-generate-config ./nixos/hosts/ciriel/hardware-configuration.nix \
        --flake ./nixos\#ciriel \
        --target-host root@{{addr}} \
        --show-trace

[group("dev-kube-cluster")]
gen-kube-staging-vars:
    uv run ./kubernetes/generate_config.py staging

[group("dev-kube-cluster")]
encrypt-token-local: 
    #!/usr/bin/env bash
    token=`python -c "import getpass; print(getpass.getpass(prompt='Token: '))"`
    echo "$token" | age --encrypt -a -R ~/.ssh/id_rsa.pub -o ./secrets/gh_token.age

[group("dev-kube-cluster")]
gen-gh-deploy-key:
    ssh-keygen -f ./secrets/deploy.key -N ""
    gh repo deploy-key add ./secrets/deploy.key.pub -w -t "ciriel-flux-dev"

[group("dev-kube-cluster")]
start-dev-cluster:
    mkdir -p /tmp/ciriel/ssd_store
    mkdir -p /tmp/ciriel/hdd_store
    minikube start \
        --static-ip 192.168.49.2 \
        --driver docker \
        --extra-config=apiserver.service-node-port-range=1-65535
    nohup minikube mount /tmp/ciriel/ssd_store:/opt/ssd_store > /tmp/ciriel/ssd_mount.log & 
    nohup minikube mount /tmp/ciriel/hdd_store:/opt/hdd_store > /tmp/ciriel/hdd_mount.log & 

[group("dev-kube-cluster")]
dev-dash:
    minikube dashboard & disown

[group("dev-kube-cluster")]
bootstrap-flux-dev:
    yes | flux bootstrap git \
        --url=ssh://git@github.com/callummance/ciriel \
        --branch=kube-dev \
        --private-key-file=./secrets/deploy.key \
        --path=kubernetes/fluxcd/clusters/staging

[group("dev-kube-cluster")]
insert-age-key-dev:
    cat ~/.ssh/id_ed25519 | ssh-to-age -private-key | kubectl create secret generic sops-age \
        --namespace=flux-system \
        --from-file=age.agekey=/dev/stdin

reconcile-all:
    flux reconcile source git flux-system

#gh_token := `cat gh_token.age | age --decrypt -i ~/.ssh/id_rsa`
#test:
#    @echo "{{ gh_token }}"