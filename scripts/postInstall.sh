#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

    docker-compose exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "make init"
	docker-compose exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "python manage.py loaddata oidc-server-outline-client"