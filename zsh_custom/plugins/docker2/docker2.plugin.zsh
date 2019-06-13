docker-stop-all() { docker stop $(docker ps -a -q) }
docker-delete-stop() { docker rm $(docker ps -a -q) }
docker-rmi-none() { docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}') }
docker-rm-networks() { docker network rm $(docker network ls --format '{{.ID}}') }
docker-clean() { docker-delete-stop; docker-rmi-none; docker-rmi-networks; }
