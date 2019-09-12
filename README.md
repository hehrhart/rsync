# rsync
Rsync docker container
# rsync-deploy

Be able to deploy with the rsync and gitlab-ci method

## Build

> create base64 rsa key `cat ~/.ssh/id_rsa | base64`

```bash
docker image build --build-arg RSA_KEY=<id_rsa | base64> -t registry.gitlab.com/pok-project/rsync-deploy:latest .
docker image build -t registry.gitlab.com/pok-project/rsync-deploy:latest .
```

docker build -t registry.gitlab.com/pok-project/rsync-deploy:latest .
docker push registry.gitlab.com/pok-project/rsync-deploy:latest

## Run

```bash
docker container run --rm -e RSA_PASSPHRASE=hN5aola5gk7v15EUoJOIb2hn6fp6fbh7 rsync:latest
```

Use absolute path for source and dist folder. If wou want sync all files includes in folder finish path by `/`.

## Exclude files

> for exclude file during transfert, we use `--exclude-from`option of [rsync](https://linux.die.net/man/1/rsync)

Add **RSYNC_EXCLUDE** env variable with list of files or directories in value. Use `:` as separator of each item.

```bash
docker container run ... -e RSYNC_EXCLUDE=node_modules:assets ...
```
