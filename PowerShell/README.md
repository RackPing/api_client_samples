# RackPing API 2.0 Client Sample PowerShell Programs

Microsoft PowerShell sample programs that you can copy-and-paste to automate common RackPing monitoring tasks from the command lin, including managing checks and contacts.e

## Getting Started

* [Create a FREE RackPing monitoring account!](https://www.rackping.com/cgi-bin/signup.cgi) (Ctrl-click or Cmd-click link to signup in new tab)
* Download or copy-and-paste a program, then configure set.sh with your RackPing login and API key.

### Prerequisites

Tested with Microsoft PowerShell 7.1 for linux.

```
jq (optional for the demo.sh test harness)
```

### Installing

For setting the permissions on all files in this folder:

```
./make.sh
```

On Mac OS High Sierra or newer, you can install PowerShell with:
```
brew install powershell
```

## Documentation

See the [RackPing API web page](https://www.rackping.com/api.html) for:

* RackPing 2.0 API PDF
* errata (recent changes)
* interactive Live API demo in your browser.

## Running the tests

After installing all the files in this folder, you can use demo.sh as a test harness to create a temporary check and contact using your RackPing account:

```
source ../set.sh
time ./demo.sh
```

## Version

1.0

## License

Copyright RackPing USA 2013-2021

## Keywords

RackPing REST API, SDK, Monitoring, Observability, Nocode, No-code, programming, scripting, automation.

