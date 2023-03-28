#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

    docker-compose exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "make init"
	docker-compose exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "python manage.py loaddata oidc-server-outline-client"

echo "Restarting ..."

    docker-compose down;
    docker-compose up;

    docker exec -t ${PIPELINE_NAME}_wk-oidc-server_1 sh -c "python manage.py createsuperuser --noinput --username=admin --email=$ADMIN_EMAIL"
	docker exec -t ${PIPELINE_NAME}_wk-oidc-server_1 sh -c "python manage.py shell <<EOF
    from django.contrib.auth.models import User

    user = User.objects.get(username='admin')
    user.set_password('$ADMIN_PASSWORD')
    user.save()
    EOF"

echo "Restarting ..."

	docker-compose down;
	docker-compose up -d;