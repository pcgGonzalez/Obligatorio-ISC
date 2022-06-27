#!/bin/bash

sudo apt-get update

##########INSTALACION DE GIT#########################
sudo apt-get install git -y
#################INSTALACION DE AWS Y PAQUETES NECESARIOS################################
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sleep 60
####################INSTALACIÓN DE KUBECTL DESDE AWS################
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
sleep 20
###################################################################################################################################################

list=$(ls /home/admin/online-boutique/src) 

aws eks --region us-east-1 update-kubeconfig --name eks-cluster

#pasar parametro por parametro
for i in $list
do
  kubectl create -f /home/admin/online-boutique/src/$i/deployment/kubernetes-manifests.yaml
done

