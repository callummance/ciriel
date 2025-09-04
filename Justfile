
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
    mkdir /tmp/ciriel_ssd
    mkdir /tmp/ciriel_hdd
    minikube start
    minikube dashboard & disown

[group("dev-kube-cluster")]
bootstrap-flux-dev:
    flux bootstrap git \
        --url=ssh://git@github.com/callummance/ciriel \
        --branch=kube-dev \
        --private-key-file=./secrets/deploy.key \
        --path=kubernetes/fluxcd/clusters/staging

[group("dev-kube-cluster")]
insert-age-key-dev:
    cat ~/.ssh/id_rsa | kubectl create secret generic sops-age \
        --namespace=flux-system \
        --from-file=age.agekey=/dev/stdin

reconcile-all:
    flux reconcile source git flux-system

#gh_token := `cat gh_token.age | age --decrypt -i ~/.ssh/id_rsa`
#test:
#    @echo "{{ gh_token }}"