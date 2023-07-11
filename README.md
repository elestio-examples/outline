# Outline CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/outline"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Outline server with CI/CD on Elestio

<img src="outline.png" style='width: 100%;'/>
<br/>
<br/>

# Once deployed ...

You can open Outline UI here:

    URL: https://[CI_CD_DOMAIN]
    email: admin
    password: [ADMIN_PASSWORD]

# Custom domain instructions (IMPORTANT)

By default, we set up a CNAME on elestio.app domain, but probably you will want to have your own domain.

***Step1:*** Add your domain in the Elestio dashboard as explained here:

    https://docs.elest.io/books/security/page/custom-domain-and-automated-encryption-ssltls

***Step2:*** Update the environment variables to reflect your custom domain Open Elestio dashboard > Service overview > Click on the Update CONFIG button > Env tab there edit 'URL_ADDRESS with your real domain and after `SERVICE_NAME` key values removed all the env vars and click the button 'Update & Restart'.

**Step3:*** You must reset the Outline instance DB, you can do that with those commands, connect over SSH and run this:

    cd /opt/app;
    docker-compose down;
    rm -rf ./data;
    rm -rf ./config/uc/fixtures/oidc-server-outline-client.json;
    ./scripts/preInstall.sh;
    docker-compose up -d;
    ./scripts/postInstall.sh;

You will start over with a fresh instance of Outline directly configured with the correct custom domain name and federation will work as expected
