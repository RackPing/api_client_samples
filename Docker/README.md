# RackPing API 2.0 Client Sample Programs Docker

This folder includes a Dockerfile and instructions to build a container with the current RackPing API sample programs, several programming languages and the test harness.

Docker makes getting started easier, and isolates any changes from your notebook or server setup or filesystem.

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* See `make.sh`

### Prerequisites

* Docker (tested on Mac OS X and linux)

### Installing

See `make.sh` for various docker commands including:

* Click on the green Github "Code" button, then "Download zip" to download the complete source code for all languages.
* unzip and cd to the Docker folder and run the following commands:

```
# add your RackPing API credentials to the Docker environment configuration file:
vi env.list
# now build the Docker container. Don't forget the dot at the end:
sudo docker build -t rackping_api:latest .
# view info on the new Docker image:
docker images
```

```
REPOSITORY                           TAG                                              IMAGE ID            CREATED             SIZE
rackping_api                         latest                                           166eeb4b9ee8        1 minute ago        2.2GB
```

## Running the tests

To run the complete test harness using the available scripting languages, then terminate the docker process:

```
docker run --env-file ./env.list rackping_api
```

See `make.sh` for further sample commands for how to:

* run the tests for only one scripting language.

* maintain a persistent docker process, login to it, and/or run the test harness one or more times to pre-compile the Go and Java programs for improved performance.

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Version

1.0

## License

Copyright RackPing USA 2013-2021

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.

