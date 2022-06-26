#!/bin/bash

sudo apt-get update

##########INSTALACION DE GIT#########################
sudo apt-get install git -y
###################################################################################################################################################
#################INSTALACION DE AWS Y PAQUETES NECESARIOS################################
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set aws_session_token $AWS_SESSION_TOKEN
aws configure set region $AWS_DEFAULT_REGION
###################################################################################################################################################
#####################INSTALACION DE DOCKER#########################
sudo apt-get install apt-transport-https -y
sudo apt-get install ca-certificates -y
sudo apt-get install curl -y
sudo apt-get install gnupg -y
sudo apt-get install lsb-release -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" |\
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
###################################################################################################################################################
###################SE BAJA LA IMAGEN DEL CARTSERVICE DE DOCKERHUB, SE LOGUEA EN AWS Y LUEGO LA SUBE AL REPO EN ECR#################################
sudo docker login --username $DOCKER_USER --password $DOCKER_PWD
sudo docker pull obligatorioisc/cartservice:v1
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 007518468067.dkr.ecr.us-east-1.amazonaws.com
sudo docker tag obligatorioisc/cartservice:v1 007518468067.dkr.ecr.us-east-1.amazonaws.com/online-boutique:cartservice
sudo docker push 007518468067.dkr.ecr.us-east-1.amazonaws.com/online-boutique:cartservice

###################################################################################################################################################
############CLONADO DEL REPO ONLINE-BOUTIQUE EN LA INSTANCIA#########################
git clone https://$GIT_USER:$GIT_PWD@github.com/ISC-ORT-FI/online-boutique.git
###################################################################################################################################################

###################################################################################################################################################
####################INSTALACIÓN DE KUBECTL DESDE AWS################
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
curl -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl.sha256
openssl sha1 -sha256 kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
aws eks --region us-east-1 update-kubeconfig --name "eks-cluster"
###################################################################################################################################################


###################################################################################################################################################
###################CON EL SCRIPT SE CREAN LAS IMAGENES RESTANTES QUE NO DAN ERROR, SE PUSHEAN AL REPO EN ECR Y#################################
###################SE CAMBIAN LOS MANIFESTOS DE KUBERNETES TAMBIEN PARA PODER CONSTRUIR LOS DEPLOYMENTS#################################
###################################################################################################################################################
microservices=$(ls /home/admin/online-boutique/src)
IMG="007518468067.dkr.ecr.us-east-1.amazonaws.com\/obligatorio-isc:"

for ms in $microservices
do
  sed -i "s/<IMAGE:TAG>/"$IMG$ms"/g" online-boutique/src/$ms/deployment/kubernetes-manifests.yaml
  sed '/selector:/i\  replicas: 2' online-boutique/src/$ms/deployment/kubernetes-manifests.yaml
  sudo docker build -t 007518468067.dkr.ecr.us-east-1.amazonaws.com/obligatorio-isc:"$ms" online-boutique/src/$ms/
  sudo docker push 007518468067.dkr.ecr.us-east-1.amazonaws.com/obligatorio-isc:"$ms"
  kubectl create -f online-boutique/src/$ms/deployment/kubernetes-manifests.yaml
done
