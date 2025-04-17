#!/bin/bash

docker stop dio-lab01-backend && docker stop dio-lab01-database && docker stop dio-lab01-frontend

docker build -t rodrigosouza/dio-lab01-database database
docker build -t rodrigosouza/dio-lab01-backend backend
docker build -t rodrigosouza/dio-lab01-frontend frontend

# docker push rodrigosouza/dio-lab01-database
# docker push rodrigosouza/dio-lab01-backend
# docker push rodrigosouza/dio-lab01-frontend

docker run -d --rm --name dio-lab01-database -p 3306:3306 -e MYSQL_ROOT_PASSWORD=Senha123 -e MYSQL_DATABASE=meubanco rodrigosouza/dio-lab01-database
docker run -d --rm --name dio-lab01-backend -p 7890:80 rodrigosouza/dio-lab01-backend
docker run -d --rm --name dio-lab01-frontend -p 8080:80 rodrigosouza/dio-lab01-frontend