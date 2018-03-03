docker-stop-all() { docker stop $(docker ps -a -q) }
docker-delete-stop() { docker rm $(docker ps -a -q) }
docker-rmi-none() { docker rmi -f $(docker images | grep "^<none>" | awk '{print $3}') }
docker-clean() { docker-delete-stop; docker-rmi-none; }
