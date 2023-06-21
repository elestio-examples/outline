#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
if [ -e "./scripts/config.sh" ]; then
    sleep 30s;
    exit 0;
fi
sleep 60s;

    docker exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "make init"
	docker exec ${PIPELINE_NAME}_wk-oidc-server_1 bash -c "python manage.py loaddata oidc-server-outline-client"




    docker exec -t ${PIPELINE_NAME}_wk-oidc-server_1 sh -c "python manage.py createsuperuser --noinput --username=admin --email=$ADMIN_EMAIL"
		docker exec -t ${PIPELINE_NAME}_wk-oidc-server_1 sh -c "python manage.py shell <<EOF
from django.contrib.auth.models import User

user = User.objects.get(username='admin')
user.set_password('$ADMIN_PASSWORD')
user.save()
EOF"
