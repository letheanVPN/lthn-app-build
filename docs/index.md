git merge --no-ff "develop"
```dockerfile
FROM lthn/build as builder
WORKDIR /src
make
```

This Docker file is big, never include it in the end image, once you have built your code in dockerfile add.

```dockerfile
FROM ubuntu:16.04
COPY --from=builder /src/build/release/bin /home/lthn/build/bin 
```

# Development Flow
Code is created on a branch with a merge request made to track and talk between intrested developers.

## Add a new feature to work on from the issues list
```shell
git checkout -b feature/feature-name
# do your work/add what youve done
git commit -m "Work on feature/feature-name"
# push to branch
git push origin master
```
The merge request you made will be building through the pipeline, if it completes you can merge into `develop`

## Push to external's / Releases

We have a GitHub and docker.io accounts that get selective updates.

Everything that gets pushed to master will get push out to Docker Hub, Git Hub and create support docs + binaries made on GitLab.

The credentials for GitHub, DockerHub are sandboxed in protected environments, only maintainers and above can push (unless CODEOWNERS file add additional approvals)
