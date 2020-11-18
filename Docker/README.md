# RackPing API 2.0 Client Docker

Dockerfile and instructions to build an image to install several scripting languages, the RackPing API sample programs, and the demo harness.

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* See `make.sh`

### Prerequisites

* Docker

### Installing

See `make.sh` for various docker commands:

```
sudo docker build -t rackping_api:latest .
docker images
```

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Running the tests

To run the test harness using the available scripting languages:

```
docker run --env-file ./env.list rackping_api
```

See `make.sh` for how to run the tests for one scripting language.

## Version

1.0

## License

Copyright RackPing USA 2013-2021

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.

