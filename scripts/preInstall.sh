#set env vars
set -o allexport; source .env; set +o allexport;

# apt install jq -y

chmod +x ./scripts/*.sh
mkdir -p ./config/uc/fixtures
chown -R 1000:1000 ./config/uc/fixtures

if [ -e "./config/uc/fixtures/oidc-server-outline-client.json" ]; then
   exit 0;
fi

MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY:-`openssl rand -hex 8`}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY:-`openssl rand -hex 32`}
OIDC_CLIENT_SECRET=${MINIO_SECRET_KEY:-`openssl rand -hex 28`}
OUTLINE_SECRET_KEY=${OUTLINE_SECRET_KEY:-`openssl rand -hex 32`}
OUTLINE_UTILS_SECRET=${OUTLINE_UTILS_SECRET:-`openssl rand -hex 32`}
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY:-`openssl rand -hex 32`}


cat << EOT >> ./scripts/config.sh

MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
MINIO_ROOT_USER=${MINIO_ACCESS_KEY}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
MINIO_ROOT_PASSWORD=${MINIO_SECRET_KEY}
OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
OUTLINE_SECRET_KEY=${OUTLINE_SECRET_KEY}
OUTLINE_UTILS_SECRET=${OUTLINE_UTILS_SECRET}
DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}
URL=$URL_ADDRESS
EOT

cat << EOT >> ./.env

NETWORKS=outlinewiki
NETWORKS_EXTERNAL=false
HTTP_IP=172.17.0.1
HTTP_PORT_IP=8888
OUTLINE_VERSION=latest
POSTGRES_VERSION=15.2-alpine3.17
MINIO_VERSION=RELEASE.2022-11-17T23-20-09Z
MINIO_MC_VERSION=RELEASE.2022-11-17T21-20-39Z
MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
MINIO_ROOT_USER=${MINIO_ACCESS_KEY}
MINIO_ROOT_PASSWORD=${MINIO_SECRET_KEY}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
MINIO_BROWSER=off
OIDC_CLIENT_ID=050984
OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
OIDC_AUTH_URI=$URL_ADDRESS/uc/oauth/authorize/
OIDC_TOKEN_URI=http://wk-nginx/uc/oauth/token/
OIDC_USERINFO_URI=http://wk-nginx/uc/oauth/userinfo/
OIDC_USERNAME_CLAIM=preferred_username
OIDC_DISPLAY_NAME=OpenID
OIDC_SCOPES="openid profile email"
OIDC_DISABLE_REDIRECT=true
DEBUG=0
LANGUAGE_CODE=en-us
TIME_ZONE=UTC
FORCE_SCRIPT_NAME=/uc
SECRET_KEY=${OUTLINE_SECRET_KEY}
UTILS_SECRET=${OUTLINE_UTILS_SECRET}
URL=$URL_ADDRESS
PORT=3000
CDN_URL=$URL_ADDRESS
FORCE_HTTPS=false
ENABLE_UPDATES=true
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
SLACK_VERIFICATION_TOKEN=
SLACK_MESSAGE_ACTIONS=false
GOOGLE_ANALYTICS_ID=
SENTRY_DSN=
GOOGLE_ALLOWED_DOMAINS=
AWS_ACCESS_KEY_ID=${MINIO_ACCESS_KEY}
AWS_SECRET_ACCESS_KEY=${MINIO_SECRET_KEY}
AWS_REGION=xx-xxxx-x
AWS_S3_UPLOAD_BUCKET_URL=$URL_ADDRESS
AWS_S3_UPLOAD_MAX_SIZE=26214400
FILE_STORAGE_UPLOAD_MAX_SIZE=26214400
AWS_S3_FORCE_PATH_STYLE=true
AWS_S3_ACL=private
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USERNAME=${SMTP_USERNAME}
SMTP_PASSWORD=${SMTP_PASSWORD}
SMTP_FROM_EMAIL=${SMTP_FROM_EMAIL}
SMTP_REPLY_EMAIL=${SMTP_FROM_EMAIL}
SMTP_SECURE=false
# TEAM_LOGO=https://example.com/images/logo.png
DEFAULT_LANGUAGE=en_US
PGSSLMODE=disable
ALLOWED_DOMAINS=

EOT

cat << EOT >> ./config/uc/fixtures/oidc-server-outline-client.json

[
    {
     "model": "oidc_provider.client",
     "pk": 1,
     "fields": {
      "name": "outline",
      "owner": null,
      "client_type": "confidential",
      "client_id": "050984",
      "client_secret": "$OIDC_CLIENT_SECRET",
      "jwt_alg": "RS256",
      "date_created": "2022-02-15",
      "website_url": "",
      "terms_url": "",
      "contact_email": "",
      "logo": "",
      "reuse_consent": true,
      "require_consent": true,
      "_redirect_uris": "$URL_ADDRESS/auth/oidc.callback",
      "_post_logout_redirect_uris": "",
      "_scope": "",
      "response_types": [
       1,
       2,
       3,
       4,
       5,
       6
      ]
     }
    }
    ]


EOT
