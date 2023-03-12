#set env vars
#set -o allexport; source .env; set +o allexport;

# apt install jq -y

# mkdir -p ./data
# chown -R 1000:1000 ./data

MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY:-`openssl rand -hex 8`}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY:-`openssl rand -hex 32`}
SECRET_KEY=${SECRET_KEY:-`openssl rand -hex 32`}
UTILS_SECRET=${UTILS_SECRET:-`openssl rand -hex 32`}
SECRET_KEY=${SECRET_KEY:-`openssl rand -hex 32`}
OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET:-`openssl rand -hex 28`}

cat << EOT >> ./.env
MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
SECRET_KEY=${SECRET_KEY}
UTILS_SECRET=${UTILS_SECRET}
OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
SECRET_KEY=${SECRET_KEY}
EOT