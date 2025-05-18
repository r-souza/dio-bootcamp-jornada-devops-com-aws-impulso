#!/bin/bash

# Clean up resources if needed
# Uncomment the following lines to delete resources before applying new configurations (if necessary)
# kubectl delete configmap mysql-initdb-config
# kubectl delete deployments.apps mysql && kubectl delete service mysql && kubectl delete pvc mysql-pv-claim && kubectl delete pv mysql-pv-volume
# kubectl delete service lab01-frontend && kubectl delete deployments.apps lab01-frontend
# kubectl delete service lab01-backend && kubectl delete deployments.apps lab01-backend

docker build -t rodrigoevildead/dio-lab01-database database
docker build -t rodrigoevildead/dio-lab01-backend backend
docker build -t rodrigoevildead/dio-lab01-frontend frontend

docker push rodrigoevildead/dio-lab01-database
docker push rodrigoevildead/dio-lab01-backend
docker push rodrigoevildead/dio-lab01-frontend

# Create ConfigMap for MySQL initialization script
kubectl create configmap mysql-initdb-config --from-file=./database/init.sql

# Create PV, PVC, Deployment and Service for MySQL
kubectl apply -f mysql-pv.yaml && kubectl apply -f mysql-deployment.yaml   

# Create Deployment and Service for Frontend
kubectl apply -f frontend-deployment.yaml

# Create Deployment and Service for Backend
kubectl apply -f backend-deployment.yaml
