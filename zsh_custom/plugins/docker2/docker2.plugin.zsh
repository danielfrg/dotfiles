docker-stop-all() { docker stop $(docker ps -a -q) }
docker-prune() {docker system prune -f }
docker-clean() { docker-stop-all; docker-prune; }
