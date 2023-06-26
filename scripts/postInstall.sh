#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."

sleep 60s;

    docker-compose exec -T wk-oidc-server bash -c "make init"
	docker-compose exec -T wk-oidc-server bash -c "python manage.py loaddata oidc-server-outline-client"




    docker-compose exec -T wk-oidc-server sh -c "python manage.py createsuperuser --noinput --username=admin --email=$ADMIN_EMAIL"
    docker-compose exec -T wk-oidc-server sh -c "python manage.py shell <<EOF
from django.contrib.auth.models import User

user = User.objects.get(username='admin')
user.set_password('$ADMIN_PASSWORD')
user.save()
EOF"
