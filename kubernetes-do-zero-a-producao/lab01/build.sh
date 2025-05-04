#!/bin/bash

docker stop dio-lab01-backend && docker stop dio-lab01-database && docker stop dio-lab01-frontend

docker build -t rodrigoevildead/dio-lab01-database database
docker build -t rodrigoevildead/dio-lab01-backend backend
docker build -t rodrigoevildead/dio-lab01-frontend frontend

docker push rodrigoevildead/dio-lab01-database
docker push rodrigoevildead/dio-lab01-backend
docker push rodrigoevildead/dio-lab01-frontend

# docker run -d --rm --name dio-lab01-database -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco rodrigoevildead/dio-lab01-database

docker run -d --rm --name dio-lab01-database -p 3306:3306 rodrigoevildead/dio-lab01-database
docker run -d --rm --name dio-lab01-backend -p 7890:80 rodrigoevildead/dio-lab01-backend
docker run -d --rm --name dio-lab01-frontend -p 8880:80 rodrigoevildead/dio-lab01-frontend


kubectl create configmap mysql-initdb-config --from-file=./database/init.sql


# kubectl create secret generic lab01-database-secret --from-literal=mysql-root-password=Senha123

 k delete deployments.apps mysql && k delete service mysql && k delete pvc mysql-pv-claim && k delete pv mysql-pv-volume

 k apply -f mysql-pv.yaml && k apply -f mysql-deployment.yaml   