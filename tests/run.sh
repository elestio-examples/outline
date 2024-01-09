#!/usr/bin/env bash

docker-compose up -d;
sleep 75s;

 docker-compose exec -T wk-oidc-server bash -c "make init"
	docker-compose exec -T wk-oidc-server bash -c "python manage.py loaddata oidc-server-outline-client"




    docker-compose exec -T wk-oidc-server sh -c "python manage.py createsuperuser --noinput --username=admin --email=$ADMIN_EMAIL"
    docker-compose exec -T wk-oidc-server sh -c "python manage.py shell <<EOF
from django.contrib.auth.models import User

user = User.objects.get(username='admin')
user.set_password('$ADMIN_PASSWORD')
user.save()
EOF"