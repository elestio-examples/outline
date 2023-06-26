#set env vars
set -o allexport; source .env; set +o allexport;

# apt install jq -y

chmod +x ./scripts/*.sh
mkdir -p ./config/uc/fixtures
chown -R 1000:1000 ./config/uc/fixtures

if [ -e "./env.minio" ]; then
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
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
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
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}

EOT

cat << EOT >> ./env.minio

MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
MINIO_BROWSER=off

EOT

cat << EOT >> ./env.oidc

OIDC_CLIENT_ID=050984
OIDC_CLIENT_SECRET=${OIDC_CLIENT_SECRET}
OIDC_AUTH_URI=$URL_ADDRESS/uc/oauth/authorize/
OIDC_TOKEN_URI=http://wk-nginx/uc/oauth/token/
OIDC_USERINFO_URI=http://wk-nginx/uc/oauth/userinfo/

OIDC_USERNAME_CLAIM=preferred_username

OIDC_DISPLAY_NAME=OpenID

OIDC_SCOPES=openid profile email

EOT

cat << EOT >> ./env.oidc-server

DEBUG=0
LANGUAGE_CODE=en-us
TIME_ZONE=UTC
FORCE_SCRIPT_NAME=/uc
SECRET_KEY=${OUTLINE_SECRET_KEY}


EOT

cat << EOT >> ./env.outline

# Copy this file to .env, remove this comment and change the keys. For development
# with docker this should mostly work out of the box other than setting the Slack
# keys (for auth) and the SECRET_KEY.
#
# Please use `openssl rand -hex 32` to create SECRET_KEY
SECRET_KEY=${OUTLINE_SECRET_KEY}
UTILS_SECRET=${OUTLINE_UTILS_SECRET}


# Must point to the publicly accessible URL for the installation
URL=$URL_ADDRESS
PORT=3000

# Optional. If using a Cloudfront distribution or similar the origin server
# should be set to the same as URL.
CDN_URL=$URL_ADDRESS

# enforce (auto redirect to) https in production, (optional) default is true.
# set to false if your SSL is terminated at a loadbalancer, for example
FORCE_HTTPS=false

ENABLE_UPDATES=true
DEBUG=cache,presenters,events,emails,mailer,utils,multiplayer,server,services

# Third party signin credentials (at least one is required)

# To configure Google auth, you'll need to create an OAuth Client ID at
# => https://console.cloud.google.com/apis/credentials
#
# When configuring the Client ID, add an Authorized redirect URI:
# https://<your Outline URL>/auth/google.callback
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Comma separated list of domains to be allowed (optional)
# If not set, all Google apps domains are allowed by default
GOOGLE_ALLOWED_DOMAINS=

# Third party credentials (optional)
SLACK_VERIFICATION_TOKEN=
SLACK_MESSAGE_ACTIONS=false
GOOGLE_ANALYTICS_ID=
SENTRY_DSN=

# AWS credentials (optional in development)
AWS_ACCESS_KEY_ID=${MINIO_ACCESS_KEY}
AWS_SECRET_ACCESS_KEY=${MINIO_SECRET_KEY}
AWS_REGION=xx-xxxx-x
AWS_S3_UPLOAD_BUCKET_URL=$URL_ADDRESS
AWS_S3_UPLOAD_MAX_SIZE=26214400
AWS_S3_FORCE_PATH_STYLE=true
# uploaded s3 objects permission level, default is private
# set to "public-read" to allow public access
AWS_S3_ACL=private

# Emails configuration (optional)
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USERNAME=${SMTP_USERNAME}
SMTP_PASSWORD=${SMTP_PASSWORD}
SMTP_FROM_EMAIL=${SMTP_FROM_EMAIL}
SMTP_REPLY_EMAIL=${SMTP_FROM_EMAIL}

# Custom logo that displays on the authentication screen, scaled to height: 60px
# TEAM_LOGO=https://example.com/images/logo.png

# See translate.getoutline.com for a list of available language codes and their
# percentage translated.
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