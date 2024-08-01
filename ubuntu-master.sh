#!/bin/bash
sudo hostnamectl set-hostname control-plane
bash
sudo apt-get update -y
sudo apt-get install docker.io -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sleep 10
sudo apt-mark hold kubelet kubeadm kubectl
sleep 10
sudo systemctl enable --now kubelet
sudo kubeadm init 
sleep 10
mkdir -p $HOME/.kube
sleep 10
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sleep 10
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sleep 10
export KUBECONFIG=/etc/kubernetes/admin.conf
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/calico.yaml -O
sleep 10
kubectl apply -f calico.yaml
