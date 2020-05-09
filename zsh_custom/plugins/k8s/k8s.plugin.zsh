# typos
alias kubeclt=kubectl

# kube-ps1 prompt
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"


kubedecode() {
    if [ $# -ne 2 ]
    then
        echo "Arguments: secret name - key"
    else
        kubectl get secret $1 -o json | jq -r ".[\"data\"][\"$2\"]" | base64 --decode
    fi
}
