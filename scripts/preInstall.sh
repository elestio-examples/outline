#set env vars
#set -o allexport; source .env; set +o allexport;

# apt install jq -y

# mkdir -p ./data
# chown -R 1000:1000 ./data

docker-compose run --rm outline yarn db:create --env=production-ssl-disabled
docker-compose run --rm outline yarn db:migrate --env=production-ssl-disabled