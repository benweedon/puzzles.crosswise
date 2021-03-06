#!/usr/bin/env sh

# update the container images
docker pull nginx
docker pull redis
docker pull bweedon/puzzles.crosswise

# stop the containers
docker stop nginx
docker stop redis
docker stop puzzles

# remove the containers
docker rm nginx
docker rm redis
docker rm puzzles

# remove the network
docker network rm puzzles_network

# recreate the network
docker network create --driver bridge puzzles_network

# start the containers back up
docker run --name nginx --net puzzles_network -p 80:80 -p 443:443 \
    -v /home/bweedon/puzzles.crosswise/nginx.conf:/etc/nginx/conf.d/nginx.conf \
    -v /home/bweedon/webroot/:/etc/nginx/html/ \
    -v /etc/letsencrypt/live/puzzles.crosswise.app/fullchain.pem:/etc/nginx/fullchain.pem \
    -v /etc/letsencrypt/live/puzzles.crosswise.app/privkey.pem:/etc/nginx/privkey.pem \
    --restart always -d nginx
docker run --name redis --net puzzles_network --restart always -d redis
docker run --name puzzles --net puzzles_network --restart always -d bweedon/puzzles.crosswise
