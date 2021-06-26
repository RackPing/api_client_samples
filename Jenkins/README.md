# Jenkins Pipeline Scripts

Some Jenkins Pipeline scripts are included if you want to do build automation.

* jenkinsfile.smoketest

This is recommended for testing the RackPing REST API samples Docker image build process, but without pushing to a repo hub.

(Since Docker Hub is no longer free, not everybody wants to incur fees.)

* jenkinsfile.dockerhub

This is a sample showing the recommended "official Jenkins" way to use the full Jenkins and Docker plugins. You will
need to customize the Docker Hub ID credentials and test it in your Jenkins environment. See jenkinsfile.smoketest for how
to use the dir() command.

## Configuration for Jenkins remote and Docker on a Mac OSX build node

After installing docker, here are the additional configuration steps needed for a Jenkins node to build this pipeline.

A recent version of Java is needed.

```
brew install openjdk@11
```

Some docker commands require sudo access, which requires sudo with no password for Jenkins, where `jenkins` is the build user:
```
sudo visudo -f /etc/sudoers.d/sudoers
jenkins ALL=(ALL) NOPASSWD: /usr/local/bin/docker
```

Jenkins requires a PATH setting to find the docker command:

Under Manage Settings -> Configure System -> Global properties -> Environment variables, add this path to your environment for docker:

```
PATH+EXTRA
$PATH:/usr/local/bin
```

In your Jenkins build node settings, under Launch method -> Advanced, the full Java command path needs to be set:

```
JavaPath
/usr/local/opt/openjdk@11/bin/java
```

## References

1. https://zwbetz.com/add-your-account-as-a-sudoer-on-mac/
1. https://appfleet.com/blog/building-docker-images-to-docker-hub-using-jenkins-pipelines/
1. https://www.jenkins.io/doc/book/pipeline/jenkinsfile/
