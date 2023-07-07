<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Outline, verified and packaged by Elestio

A better community platform for the modern web.

[Outline](https://www.getoutline.com/) is a platform for Team Knowledge System.

<img src="https://github.com/elestio-examples/outline/raw/main/outline.png" alt="outline" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/outline">fully managed Outline</a> on <a target="_blank" href="https://elest.io/">elest.io</a> Application for Managing Team Documentation and Knowledge base System.

[![deploy](https://github.com/elestio-examples/outline/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/outline)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/outline.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.


Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:9098`

## Docker-compose

Here are some example snippets to help you get started creating a container.

       version: "3.3"
       services:
        wk-redis:
            image: redis:latest
            restart: always
        wk-postgres:
            image: postgres:${POSTGRES_VERSION}
            environment:
            POSTGRES_USER: user
            POSTGRES_PASSWORD: pass
            POSTGRES_DB: outline
            volumes:
            - ./data/pgdata:/var/lib/postgresql/data
            restart: always
        wk-minio:
            image: minio/minio:${MINIO_VERSION}
            volumes:
            - ./data/minio_root:/minio_root:z
            - ./data/certs:/root/.minio/certs:z
            command: "minio server /minio_root"
            env_file:
            - ./.env
            restart: always
        wk-createbuckets:
            image: minio/mc:${MINIO_MC_VERSION}
            depends_on:
            - wk-minio
            env_file:
            - ./.env
            entrypoint: >
            /bin/sh -c "
            until (/usr/bin/mc config host add minio http://wk-minio:9000 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}) do echo '...waiting...' && sleep 1; done;
            /usr/bin/mc mb minio/outline-bucket;
            /usr/bin/mc anonymous set download minio/outline-bucket;
            exit 0;
            "
        wk-outline:
            image: elestio4test/outline:${OUTLINE_VERSION}
            command: sh -c "yarn db:migrate --env production-ssl-disabled && yarn start"
            environment:
            - DATABASE_URL=postgres://user:pass@wk-postgres:5432/outline
            - DATABASE_URL_TEST=postgres://user:pass@wk-postgres:5432/outline-test
            - REDIS_URL=redis://wk-redis:6379
            - AWS_S3_UPLOAD_BUCKET_NAME=outline-bucket
            env_file:
            - ./.env
            restart: always
            depends_on:
            - wk-postgres
            - wk-redis
            - wk-minio
        wk-oidc-server:
            image: vicalloy/oidc-server
            volumes:
            - ./config/uc/fixtures:/app/oidc_server/fixtures:z
            - ./data/uc/db:/app/db:z
            - ./data/uc/static_root:/app/static_root:z
            restart: always
            env_file:
            - ./.env
        wk-nginx:
            image: nginx
            ports:
            - 172.17.0.1:9098:80
            volumes:
            - ./config/nginx/:/etc/nginx/conf.d/:ro
            - ./data/uc/static_root:/uc/static_root:ro
            restart: always
            depends_on:
            - wk-minio
            - wk-outline
            - wk-oidc-server

### Environment variables

|       Variable       | Value (example) |
| :------------------: | :-------------: |
| POSTGRES_VERSION     |     latest      |
| MINIO_VERSION        |     latest      |
| MINIO_MC_VERSION     |     latest      |
| OUTLINE_VERSION      |     latest      |




# Maintenance

## Logging

The Elestio Outline Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://docs.getoutline.com/s/guide">Outline documentation</a>

- <a target="_blank" href="https://github.com/outline/outline.git">Outline Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/outline">Elestio/outline Github repository</a>