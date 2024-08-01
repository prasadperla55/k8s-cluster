#!/bin/bash
echo "Updating system..."
yum install docker -y 
systemctl start docker  
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sleep 10
sudo systemctl enable --now kubelet
kubeadm init
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
