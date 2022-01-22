# Setting up a local Gitlab runner, for testing/building

https://docs.gitlab.com/runner/install/docker.html

This will let you run using the CI environment, just found it myself so this guide will grow as we discover things.

```shell
gitlab-runner <runner command and options...>
```
turns into
```shell
docker run <chosen docker options...> gitlab/gitlab-runner <runner command and options...>
```

## Add as a long living container

Make a docker data volume
```shell
docker volume create gitlab-runner-config
```
Run the runner in `-d` daemon mode with
```shell
docker run -d --name gitlab-runner --restart always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v gitlab-runner-config:/etc/gitlab-runner \
gitlab/gitlab-runner:latest
```

## Reading the logs
```shell
docker logs gitlab-runner
```

## Docker images available

- `gitlab/gitlab-runner:latest`
- `gitlab/gitlab-runner:alpine`

## Run runner interactive

```shell
docker run --rm -t -i gitlab/gitlab-runner --help
```

## Upgrade version

```shell
  docker pull gitlab/gitlab-runner:latest
  docker stop gitlab-runner && docker rm gitlab-runner
  docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
```








https://docs.gitlab.com/runner/install/docker.html