# Jenkins Pipeline Scripts

Some Jenkins Pipeline scripts are included if you want to do automated building and testing of the scripts in the Docker/ folder.

* jenkinsfile.smoketest (easy)

The smoketest script is recommended for testing the RackPing REST API samples Docker image build process, but without pushing to a repo hub.

* jenkinsfile.dockerhub (advanced)

The dockerhub script is an advanced sample showing the official way to use the full Jenkins and Docker plugins. You will need to customize the Jenkins and Docker nodes, which may take an hour if not previously configured. See the References section for more information.

## Configuration for Jenkins remote and Docker on a Mac OSX build node

After installing the docker environment on your build node, here are the additional configuration steps needed for a Jenkins node to build this pipeline.

A recent version of Java is needed, as of 2021 Java 8 or higher.

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

Jenkins Docker Pipeline plugin requires a path to the `docker` command in ~jenkins_user/.bashrc:
```
export PATH=$PATH:/usr/local/bin
```

Jenkins Docker Pipeline plugin requires a clean secrets setup:
```
rm -fr ~/.docker/config.json /usr/local/bin/docker-credential-osxkeychain
```

## References

1. https://zwbetz.com/add-your-account-as-a-sudoer-on-mac/
1. https://appfleet.com/blog/building-docker-images-to-docker-hub-using-jenkins-pipelines/
1. https://www.jenkins.io/doc/book/pipeline/jenkinsfile/
1. https://stackoverflow.com/questions/42787779/docker-login-error-storing-credentials-write-permissions-error/52994440
