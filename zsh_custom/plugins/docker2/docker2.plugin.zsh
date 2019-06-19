docker-stop-all() { docker stop $(docker ps -a -q) }
docker-delete-stopped() { docker rm $(docker ps -a -q) }
docker-rmi-none() { docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}') }
docker-rm-networks() { docker network rm $(docker network ls --format '{{.ID}}') }
docker-clean() { docker-stop-all; docker-delete-stopped; docker-rmi-none; docker-rm-networks; }
